### FRN ### 
# M3
df_MSPD3mkt_FRN = (
    df_MSPD3mkt.filter(
        (pl.col("TYPE").str.contains("Float")) & (pl.col("outstanding_amt").is_not_null())
        )
    )
# 1. FIXED 13-WEEK BILL HELPER (Computes ΔT and 9-decimal Money Market Index Rate r)
df_AUC_B13_Hdiscount = (
    df_AUC_UST.filter(
        (pl.col("security_type") == "Bill")
        & (pl.col("total_accepted") > 0)
        & (pl.col("security_term") == "13-Week")
    )
    .select([
        "record_date",
        "CUSIP",
        "auction_date",
        "issue_date",
        "maturity_date",
        "high_price",
        "high_discnt_rate",  # D (in percent, e.g., 0.095)
    ])
    .with_columns([
        # ΔT = days from issue_date (inclusive) to maturity_date (exclusive)
        (pl.col("maturity_date") - pl.col("issue_date")).dt.total_days().alias("ΔT"),
        (pl.col("high_discnt_rate") / 100.0).alias("D_dec"),
    ])
    .with_columns([
        # r = D / (1 - (ΔT / 360) * D), rounded to 9 decimal places in percent form
        # Uses .sub() to prevent clipboard/terminal stripping of the minus sign
        (
            pl.col("high_discnt_rate")
            / pl.lit(1.0).sub((pl.col("ΔT") / 360.0) * pl.col("D_dec"))
        )
        .cast(pl.Decimal(12,9))
        .alias("index_rate_pct")
    ])
    .with_columns([
        (pl.col("index_rate_pct") / 100.0).cast(pl.Decimal(13,11)).alias("r_dec"),
        # Effective date of index reset is the calendar day following the 13-week bill auction
        (pl.col("auction_date") + pl.duration(days=1)).alias("effective_start_date"),
    ])
    .sort("auction_date")
)

# 2. EXTRACT UNIQUE COUPON DATES BEFORE SUBSETTING
df_FRNcpn_dates = (
    df_MSPD3mkt_FRN.filter(pl.col("outstanding_amt").is_not_null())
    .select([
        "CUSIP",
        "interest_pay_date_1",
        "interest_pay_date_2",
        "interest_pay_date_3",
        "interest_pay_date_4",
    ])
    .unique(subset=["CUSIP"])
)

# 3. BASE FRN AUCTION DATAFRAME WITH COUPON SCHEDULE & T_{-1} ANCHOR
df_AUC_FRN = (
    df_AUC_UST.filter(pl.col("floating_rate") == True)
    .select([
        "record_date",
        "CUSIP",
        "maturity_date",                 # T_N
        "auction_date",
        "price_per100",                  # P (or P_C for reopenings)
        "accrued_int_per100",            # AI
        "spread",                        # s (in percent)
        "high_discnt_margin",            # m (in percent)
        "frn_index_determination_rate",  # D from 13-week bill; exact 9-dec r joined below
        "frn_index_determination_date",
        "high_price",
        "original_issue_date",
        "original_dated_date",
        "issue_date",                    # T_0
        "dated_date",
        "back_dated_date",
        "currently_outstanding",
        "total_accepted",
        "int_payment_frequency",
        "first_int_payment_date",
        "reopening",
    ])
    .join(df_FRNcpn_dates, on="CUSIP", how="left")
    .join(
        df_AUC_B13_Hdiscount.select([
            pl.col("auction_date").alias("frn_index_determination_date"),
            pl.col("high_discnt_rate").alias("b13_high_discnt_rate"),
            pl.col("index_rate_pct").alias("r_issue_pct"),
            pl.col("r_dec").alias("r_issue_dec"),
        ]),
        on="frn_index_determination_date",
        how="left",
    )
    .with_columns([
        # Determine T_{-1} for Sections IV.C and IV.E:
        # In Fiscal Data, `dated_date` on a reopening row is already updated to the start of the
        # current quarterly interest period (either original_dated_date for 1st reopening or
        # first_int_payment_date for 2nd reopening). We coalesce with original_dated_date as a fallback.
        pl.coalesce(["dated_date", "original_dated_date"]).alias("T_minus_1")
    ])
)

# 4. PARTITION INTO APPENDIX B SECTION IV REGIMES (WITH COUPON DATES INCLUDED)
df_AUC_FRN_A = df_AUC_FRN.filter(
    pl.col("high_discnt_margin").is_not_null()
    & (pl.col("total_accepted") > 0)
    & (pl.col("reopening") == False)
    & (pl.col("issue_date") <= pl.col("dated_date"))
    & (pl.col("price_per100") == 100.00)
)

df_AUC_FRN_B = df_AUC_FRN.filter(
    pl.col("high_discnt_margin").is_not_null()
    & (pl.col("total_accepted") > 0)
    & (pl.col("reopening") == False)
    & (pl.col("issue_date") <= pl.col("dated_date"))
    & (pl.col("price_per100") > 100.00)
)

df_AUC_FRN_C = df_AUC_FRN.filter(
    pl.col("high_discnt_margin").is_not_null()
    & (pl.col("total_accepted") > 0)
    & (pl.col("reopening") == True)
)

df_AUC_FRN_E = df_AUC_FRN.filter(
    pl.col("high_discnt_margin").is_not_null()
    & (pl.col("total_accepted") > 0)
    & (pl.col("reopening") == False)
    & (pl.col("issue_date") > pl.col("dated_date"))
)

# 5. SECTION IV.D: QUARTERLY INTEREST PAYMENT SCHEDULE & DISCOUNT ENGINE (df_AUC_FRN_D)
# Generates the N remaining quarterly periods (i = 1..N) for every valid FRN auction,
# implementing Section IV.D formulas (a), (b), and (c) plus compound factors B_i.
df_AUC_FRN_D = (
    df_AUC_FRN.filter(
        pl.col("high_discnt_margin").is_not_null()
        & (pl.col("total_accepted") > 0)
        & pl.col("first_int_payment_date").is_not_null()
        & pl.col("maturity_date").is_not_null()
    )
    .with_columns([
        # Determine the start of the active coupon period (T_{-1}) relative to issue_date (T_0):
        # For original issues where issue_date == dated_date, T_0 is the start.
        # For reopenings (or issue_date > dated_date), the first remaining coupon date after issue_date
        # is either `first_int_payment_date` (for original issue & 1st reopening) or the next quarterly
        # month-end (for 2nd reopening, which settles 1 month after `first_int_payment_date`).
        pl.when(pl.col("issue_date") < pl.col("first_int_payment_date"))
        .then(pl.col("first_int_payment_date"))
        .otherwise(
            pl.col("first_int_payment_date").dt.offset_by("3mo").dt.month_end()
        )
        .alias("T_1_date")
    ])
    .with_columns([
        # Generate the sequence of remaining quarterly payment dates T_1 .. T_N
        pl.date_ranges(
            start=pl.col("T_1_date"),
            end=pl.col("maturity_date"),
            interval="3mo",
        )
        .list.eval(pl.element().dt.month_end())
        .alias("T_i")
    ])
    .explode("T_i")
    .with_columns([
        # Index i = 1..N per auction (identified by CUSIP and issue_date)
        pl.int_range(1, pl.len() + 1)
        .over(["CUSIP", "issue_date", "auction_date"])
        .alias("i"),
        pl.len()
        .over(["CUSIP", "issue_date", "auction_date"])
        .alias("N"),
        # Preceding date T_{i-1}: for i = 1, it is T_0 (issue_date); for i > 1, it is the prior T_{i-1}
        pl.col("T_i")
        .shift(1)
        .over(["CUSIP", "issue_date", "auction_date"])
        .fill_null(pl.col("issue_date"))
        .alias("T_i_minus_1"),
    ])
    .with_columns([
        # Exact calendar days in period: (T_i - T_{i-1})
        (pl.col("T_i") - pl.col("T_i_minus_1")).dt.total_days().alias("days_in_period"),
        # Convert spread (s) and discount margin (m) from percent to decimal
        (pl.col("spread") / 100.0).alias("s_dec"),
        (pl.col("high_discnt_margin") / 100.0).alias("m_dec"),
        # Coalesce accrued_int_per100 with 0.0 for new issues at par/premium
        pl.col("accrued_int_per100").fill_null(0.0).alias("AI_per100"),
    ])
    .with_columns([
        # Daily projected interest per $100 par: a_i = 100 * max(r + s, 0) / 360
        (
            pl.lit(100.0)
            * pl.max_horizontal(pl.col("r_issue_dec") + pl.col("s_dec"), pl.lit(0.0))
            / 360.0
        )
        .round(9)
        .alias("a_i"),
        # Projected compound factor: B_i = 1 + (r + m) * (T_i - T_{i-1}) / 360
        (
            pl.lit(1.0)
            + (pl.col("r_issue_dec") + pl.col("m_dec"))
            * (pl.col("days_in_period") / 360.0)
        )
        .round(9)
        .alias("B_i"),
    ])
    .with_columns([
        # Projected cash flow A_i (excluding pre-issue AI, including 100 par at i == N)
        (
            (pl.col("a_i") * pl.col("days_in_period")).round(9)
            + pl.when(pl.col("i") == pl.col("N")).then(100.0).otherwise(0.0)
        ).alias("A_i"),
        # Section IV.D Projected Quarterly Interest Payment IP_i:
        # - Case (b): Reopening (or back-dated) and i == 1 -> AI + a_i * (T_1 - T_0)
        # - Cases (a) & (c): New issue or i > 1 -> a_i * (T_i - T_{i-1})
        (
            pl.when(pl.col("i") == 1)
            .then(pl.col("AI_per100") + (pl.col("a_i") * pl.col("days_in_period")).round(9))
            .otherwise((pl.col("a_i") * pl.col("days_in_period")).round(9))
        ).alias("IP_i_projected"),
        # Cumulative compound factor product: prod_{k=1}^{i} B_k
        pl.col("B_i")
        .cum_prod()
        .over(["CUSIP", "issue_date", "auction_date"])
        .round(9)
        .alias("cum_B_i"),
    ])
)
