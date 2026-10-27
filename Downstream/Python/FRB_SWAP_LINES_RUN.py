import polars as pl

# 1. Filter first, then standardize types and deduplicate revisions in a single pass
swaps = (
    FRB_fxs.filter(
        (pl.col("Counterparty") == "European Central Bank")
        & (pl.col("Currency") == "USD")
    )
    .with_columns(
        Last_Updated=(
            pl.col("Last Updated").str.to_datetime("%m/%d/%Y %H:%M:%S", strict=False)
            if FRB_fxs.schema["Last Updated"] == pl.String
            else pl.col("Last Updated")
        ),
        Settlement_Date=pl.col("Settlement Date").cast(pl.Date),
        Maturity_Date=pl.col("Maturity Date").cast(pl.Date),
        Amount=pl.col("Amount").cast(pl.Float64).fill_null(0.0),
    )
    .with_columns(
        Maturity_Date=pl.col("Maturity_Date").fill_null(
            pl.col("Settlement_Date") + pl.duration(days=pl.col("Term (days)"))
        )
    )
    .filter(pl.col("Settlement_Date").is_not_null() & (pl.col("Amount") != 0.0))
    .sort("Last_Updated")
    .unique(
        subset=["Trade Date", "Settlement_Date", "Maturity_Date", "Term (days)", "Amount"],
        keep="last",
    )
    .sort("Settlement_Date")
)

# Retain FRB_fxsECB alias for downstream notebook compatibility
FRB_fxsECB = swaps

# 2. Build self-contained master calendar covering the full swap lifecycle
frb_unison = pl.DataFrame(
    {
        "unison_date": pl.date_range(
            start=swaps["Settlement_Date"].min(),
            end=swaps["Maturity_Date"].max(),
            interval="1d",
            eager=True,
        )
    }
)

# 3. Build event ledger separating gross drawdowns, gross repayments, and net delta
drawdowns = swaps.select(
    date=pl.col("Settlement_Date"),
    settled_amt=pl.col("Amount"),
    matured_amt=pl.lit(0.0),
    delta=pl.col("Amount"),
)
repayments = swaps.select(
    date=pl.col("Maturity_Date"),
    settled_amt=pl.lit(0.0),
    matured_amt=pl.col("Amount"),
    delta=-pl.col("Amount"),
)

# 4. Aggregate daily flows and compute cumulative running balance
daily_net = (
    pl.concat([drawdowns, repayments])
    .group_by("date")
    .agg(
        daily_settled=pl.col("settled_amt").sum().round(2),
        daily_matured=pl.col("matured_amt").sum().round(2),
        net_change=pl.col("delta").sum().round(2),
    )
    .sort("date")
    .with_columns(
        running_swap_balance=pl.col("net_change").cum_sum().round(2)
    )
)

# 5. Join to master calendar, forward-fill balance, and zero out IEEE 754 float dust
final_tracker = (
    frb_unison.join(daily_net, left_on="unison_date", right_on="date", how="left")
    .with_columns(
        daily_settled=pl.col("daily_settled").fill_null(0.0),
        daily_matured=pl.col("daily_matured").fill_null(0.0),
        net_change=pl.col("net_change").fill_null(0.0),
        running_swap_balance=pl.col("running_swap_balance")
        .fill_null(strategy="forward")
        .fill_null(0.0),
    )
    .with_columns(
        running_swap_balance=pl.when(pl.col("running_swap_balance").abs() < 1e-6)
        .then(0.0)
        .otherwise(pl.col("running_swap_balance"))
    )
)

final_tracker.filter(pl.col("running_swap_balance") > 0).sort("running_swap_balance")
