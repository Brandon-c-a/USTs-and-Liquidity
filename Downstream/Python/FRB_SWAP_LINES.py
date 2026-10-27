import polars as pl
FRB_fxs = FRB_fxs.filter(pl.col("isSmallValue").is_null())

#import polars as pl

# 1. Standardize and deduplicate ALL counterparties, currencies, amounts, and interest rates
swaps_all = (
    FRB_fxs.with_columns(
        Counterparty=pl.col("Counterparty").str.strip_chars(),
        Currency=pl.col("Currency").str.strip_chars(),
        Last_Updated=(
            pl.col("Last Updated").str.to_datetime("%m/%d/%Y %H:%M:%S", strict=False)
            if FRB_fxs.schema["Last Updated"] == pl.String
            else pl.col("Last Updated")
        ),
        Settlement_Date=pl.col("Settlement Date").cast(pl.Date),
        Maturity_Date=pl.col("Maturity Date").cast(pl.Date),
        Amount=pl.col("Amount").cast(pl.Float64).fill_null(0.0),
        Interest_Rate=pl.col("Interest Rate").cast(pl.Float64).fill_null(0.0),
    )
    .with_columns(
        Maturity_Date=pl.col("Maturity_Date").fill_null(
            pl.col("Settlement_Date") + pl.duration(days=pl.col("Term (days)"))
        ),
        # Precompute notional-weighted rate numerator (Amount * Interest_Rate)
        rate_weight_num=pl.col("Amount") * pl.col("Interest_Rate"),
    )
    .filter(pl.col("Settlement_Date").is_not_null() & (pl.col("Amount") != 0.0))
    .sort("Last_Updated")
    .unique(
        subset=[
            "Counterparty",
            "Currency",
            "Trade Date",
            "Settlement_Date",
            "Maturity_Date",
            "Term (days)",
            "Amount",
        ],
        keep="last",
    )
    .sort(["Settlement_Date", "Counterparty"])
)

# 2. Build event ledger tracking BOTH principal delta and notional-weighted interest rate delta
drawdowns = swaps_all.select(
    date=pl.col("Settlement_Date"),
    Counterparty=pl.col("Counterparty"),
    Currency=pl.col("Currency"),
    settled_amt=pl.col("Amount"),
    matured_amt=pl.lit(0.0),
    delta=pl.col("Amount"),
    rate_num_delta=pl.col("rate_weight_num"),
)
repayments = swaps_all.select(
    date=pl.col("Maturity_Date"),
    Counterparty=pl.col("Counterparty"),
    Currency=pl.col("Currency"),
    settled_amt=pl.lit(0.0),
    matured_amt=pl.col("Amount"),
    delta=-pl.col("Amount"),
    rate_num_delta=-pl.col("rate_weight_num"),
)

daily_net_all = (
    pl.concat([drawdowns, repayments])
    .group_by(["date", "Counterparty", "Currency"])
    .agg(
        daily_settled=pl.col("settled_amt").sum().round(2),
        daily_matured=pl.col("matured_amt").sum().round(2),
        net_change=pl.col("delta").sum().round(2),
        net_rate_num=pl.col("rate_num_delta").sum(),
    )
    .sort(["Counterparty", "Currency", "date"])
    .with_columns(
        running_swap_balance=pl.col("net_change")
        .cum_sum()
        .over(["Counterparty", "Currency"])
        .round(2),
        running_rate_num=pl.col("net_rate_num")
        .cum_sum()
        .over(["Counterparty", "Currency"]),
    )
)

# 3. Build dense (unison_date x Counterparty x Currency) spine for exact forward-filling
frb_unison = pl.DataFrame(
    {
        "unison_date": pl.date_range(
            start=swaps_all["Settlement_Date"].min(),
            end=swaps_all["Maturity_Date"].max(),
            interval="1d",
            eager=True,
        )
    }
)
counterparty_pairs = swaps_all.select(["Counterparty", "Currency"]).unique()
master_spine = frb_unison.join(counterparty_pairs, how="cross")

# 4. Construct full Long Panel with active Weighted Average Coupon (wac_rate)
df_fxs_panel = (
    master_spine.join(
        daily_net_all,
        left_on=["unison_date", "Counterparty", "Currency"],
        right_on=["date", "Counterparty", "Currency"],
        how="left",
    )
    .sort(["Counterparty", "Currency", "unison_date"])
    .with_columns(
        daily_settled=pl.col("daily_settled").fill_null(0.0),
        daily_matured=pl.col("daily_matured").fill_null(0.0),
        net_change=pl.col("net_change").fill_null(0.0),
        running_swap_balance=pl.col("running_swap_balance")
        .fill_null(strategy="forward")
        .over(["Counterparty", "Currency"])
        .fill_null(0.0),
        running_rate_num=pl.col("running_rate_num")
        .fill_null(strategy="forward")
        .over(["Counterparty", "Currency"])
        .fill_null(0.0),
    )
    .with_columns(
        running_swap_balance=pl.when(pl.col("running_swap_balance").abs() < 1e-6)
        .then(0.0)
        .otherwise(pl.col("running_swap_balance")),
        running_rate_num=pl.when(pl.col("running_swap_balance").abs() < 1e-6)
        .then(0.0)
        .otherwise(pl.col("running_rate_num")),
    )
    .with_columns(
        # Active Notional-Weighted Average Swap Interest Rate (%)
        wac_rate=pl.when(pl.col("running_swap_balance") > 0.0)
        .then((pl.col("running_rate_num") / pl.col("running_swap_balance")).round(4))
        .otherwise(None)
    )
)

# 5. Pivot USD Balances AND USD Weighted Average Interest Rates into Wide Matrices
usd_panel = df_fxs_panel.filter(pl.col("Currency") == "USD")

df_fxs_usd_matrix = usd_panel.pivot(
    index="unison_date",
    on="Counterparty",
    values="running_swap_balance",
).sort("unison_date")

df_fxs_usd_rates = (
    usd_panel.pivot(
        index="unison_date",
        on="Counterparty",
        values="wac_rate",
    )
    .sort("unison_date")
    .rename(
        {
            c: f"{c}_Rate"
            for c in usd_panel["Counterparty"].unique().to_list()
        }
    )
)

cb_11_cols = [
    "Banco de Mexico",
    "Bank of Canada",
    "Bank of England",
    "Bank of Japan",
    "Bank of Korea",
    "Danmarks Nationalbank",
    "European Central Bank",
    "Monetary Authority of Singapore",
    "Norges Bank",
    "Reserve Bank of Australia",
    "Swiss National Bank",
]

# Ensure all 11 central bank balance and rate columns exist
for c in cb_11_cols:
    if c not in df_fxs_usd_matrix.columns:
        df_fxs_usd_matrix = df_fxs_usd_matrix.with_columns(pl.lit(0.0).alias(c))
    if f"{c}_Rate" not in df_fxs_usd_rates.columns:
        df_fxs_usd_rates = df_fxs_usd_rates.with_columns(
            pl.lit(None, dtype=pl.Float64).alias(f"{c}_Rate")
        )

non_ecb_cols = [c for c in cb_11_cols if c != "European Central Bank"]
target_13_cols = cb_11_cols + ["Non_ECB_USD_Balance", "Total_USD_Swap_Balance"]
rate_11_cols = [f"{c}_Rate" for c in cb_11_cols]
ma_windows = (5, 15, 30, 60, 90)

# 6. Compute aggregate balances, 5/15/30/60/90d MAs, Weighted Rates, and Benchmark Spreads
df_fxs_usd_matrix = (
    df_fxs_usd_matrix.with_columns(
        Non_ECB_USD_Balance=pl.sum_horizontal(non_ecb_cols).round(2),
        Total_USD_Swap_Balance=pl.sum_horizontal(cb_11_cols).round(2),
    )
    .select(["unison_date"] + target_13_cols)
    .join(df_fxs_usd_rates.select(["unison_date"] + rate_11_cols), on="unison_date", how="left")
    .sort("unison_date")
    .with_columns(
        pl.col("unison_date").dt.month().alias("month"),
        pl.col("unison_date").dt.year().alias("year"),
        # Compute Total & Non-ECB Notional-Weighted Average Swap Rates (%)
        Non_ECB_USD_Rate=pl.when(pl.col("Non_ECB_USD_Balance") > 0)
        .then(
            pl.sum_horizontal(
                [pl.col(c) * pl.col(f"{c}_Rate").fill_null(0.0) for c in non_ecb_cols]
            )
            / pl.col("Non_ECB_USD_Balance")
        )
        .otherwise(None)
        .round(4),
        Total_USD_Swap_Rate=pl.when(pl.col("Total_USD_Swap_Balance") > 0)
        .then(
            pl.sum_horizontal(
                [pl.col(c) * pl.col(f"{c}_Rate").fill_null(0.0) for c in cb_11_cols]
            )
            / pl.col("Total_USD_Swap_Balance")
        )
        .otherwise(None)
        .round(4),
        # Vectorized 5, 15, 30, 60, 90-day moving averages across all 13 balance columns
        *[
            (
                pl.col(target_13_cols)
                .rolling_mean(window_size=w, min_samples=1)
                .round(2)
                + 0.0
            ).name.suffix(f"_{w}d_MA")
            for w in ma_windows
        ],
    )
)

# 7. Join Benchmark Rates (df_USTycrv 1_Mo & 3_Mo) and compute Swap Spreads (in % pts)
if "df_USTycrv" in globals():
    bench_curve = (
        df_USTycrv.select(
            unison_date=pl.col("date").cast(pl.Date),
            UST_1Mo_Rate=pl.col("1_Mo").cast(pl.Float64),
            UST_3Mo_Rate=pl.col("3_Mo").cast(pl.Float64),
        )
        .sort("unison_date")
    )
    rate_13_cols = rate_11_cols + ["Non_ECB_USD_Rate", "Total_USD_Swap_Rate"]

    df_fxs_usd_matrix = (
        df_fxs_usd_matrix.join(bench_curve, on="unison_date", how="left")
        .with_columns(
            # Forward-fill weekend/holiday Treasury benchmark yields across daily swap calendar
            UST_1Mo_Rate=pl.col("UST_1Mo_Rate").fill_null(strategy="forward"),
            UST_3Mo_Rate=pl.col("UST_3Mo_Rate").fill_null(strategy="forward"),
        )
        .with_columns(
            # Compute Swap Rate Spread over 1-Month UST (7d/28d tenor proxy) and 3-Month UST (84d tenor proxy)
            *[
                (pl.col(r_col) - pl.col("UST_1Mo_Rate"))
                .round(4)
                .alias(r_col.replace("_Rate", "_Spread_vs_1Mo"))
                for r_col in rate_13_cols
            ],
            *[
                (pl.col(r_col) - pl.col("UST_3Mo_Rate"))
                .round(4)
                .alias(r_col.replace("_Rate", "_Spread_vs_3Mo"))
                for r_col in rate_13_cols
            ],
        )
    )

df_fxs_usd_matrix.filter(pl.col("Total_USD_Swap_Balance") > 0)
