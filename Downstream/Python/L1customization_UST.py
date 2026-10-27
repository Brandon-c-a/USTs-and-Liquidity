### MSPD ###
# 3 #
df_MSPD3mkt = df_MSPD3mkt.select(pl.all().exclude(ex_cols)).filter(
        pl.col("security_class2_desc").is_not_null()  & pl.col("security_class2_desc").str.contains(r"^[0-9A-Za-z]{9}$")
    ).select(
        pl.col("security_class2_desc").alias("CUSIP"),
        pl.col("security_class1_desc").alias("TYPE"),

        ((pl.col("outstanding_amt")*1000000).round(0).cast(pl.UInt64)).alias("outstanding_amt"),
        ((pl.col("inflation_adj_amt")*1000000).round(0).cast(pl.Int64)).alias("inflation_adj_amt"),
        ((pl.col("issued_amt")*1000000).round(0).cast(pl.UInt64)).alias("issued_amt"),
        ((pl.col("redeemed_amt")*1000000).round(0).cast(pl.Int64)).alias("redeemed_amt"),

        pl.all().exclude([
            "security_class1_desc", "security_class2_desc", 
            "issued_amt", "inflation_adj_amt", "redeemed_amt", "outstanding_amt",
            "security_type_desc","series_cd"
            ])
    ).with_columns(
        pl.lit(True).cast(pl.Boolean).alias("UST_MSPD_3")
    ).sort(["maturity_date", "outstanding_amt"], descending=[False, True])

# 5 #
df_MSPD5 = df_MSPD5.select(pl.all().exclude(ex_cols)).filter(
        pl.col("security_class2_desc").is_not_null() & pl.col("security_class2_desc").str.contains(r"^[0-9A-Za-z]{9}$")
).select(
    pl.col("security_class2_desc").alias("CUSIP"),
    pl.col("cusip").alias("Stripped_CUSIP"),
    pl.col("security_class1_desc").str.replace_all("Treasury ", "", literal=True).alias("TYPE"),

    
    pl.col("maturity_date").alias("maturity_date_T5"),
    pl.col("interest_rate_pct").alias("interest_rate_pct_T5"),
    
    ((pl.col("outstanding_amt")*1000).round(0).cast(pl.UInt64)).alias("outstanding_amt_T5"),
    
    ((pl.col("portion_stripped_amt")*1000).round(0).cast(pl.UInt64)).alias("portion_stripped_amt"),
    ((pl.col("portion_unstripped_amt")*1000).round(0).cast(pl.UInt64)).alias("portion_unstripped_amt"),
    ((pl.col("reconstituted_amt")*1000).round(0).cast(pl.UInt64)).alias("reconstituted_amt"),

    pl.all().exclude([
        "security_class2_desc", "security_class1_desc", "cusip", 
        "maturity_date", "interest_rate_pct", "outstanding_amt", 
        "portion_stripped_amt","portion_unstripped_amt","reconstituted_amt",
        "series_cd"
        ])
).with_columns(
    pl.lit(True).cast(pl.Boolean).alias("UST_MSPD_5")
)

### AUCTION ###
df_AUC_UST = df_AUC_UST.select(pl.all().exclude(exclusions_AUCTION)).select([
        (pl.col("cusip").alias("CUSIP")), 
        pl.all().exclude("cusip")
]).with_columns(
    pl.lit(True).cast(pl.Boolean).alias("UST_AUC")
).sort(["record_date","issue_date"])

### FRN
df_FRNidx = (
    df_FRNidx.select([
        "record_date", "maturity_date",
        pl.col("cusip").alias("CUSIP"),
        "spread","daily_index","daily_int_accrual_rate", "daily_accrued_int_per100","accr_int_per100_pmt_period", 
        pl.all().exclude([
            "record_date","CUSIP","cusip", "maturity_date", "spread",
            "daily_index","daily_int_accrual_rate",
            "daily_accrued_int_per100","accr_int_per100_pmt_period"
            ])
        ])
    )
### TIPS ###
df_TIPSsmy = ( 
    df_TIPSsmy.with_columns( pl.col("cusip").alias("CUSIP") ).drop("cusip")
    )
df_TIPSidx = (
    df_TIPSidx.drop( ["pdf_link", "xml_link"] ).with_columns(
        pl.col("index_date").alias("record_date"),
        pl.col("cusip").alias("CUSIP"),
    ).drop("cusip").join(
        df_TIPSsmy.select([
            "CUSIP","dated_date","original_auction_date","maturity_date",
        ]), 
        on="CUSIP", 
        how ="inner"
    ).unique()
).sort("index_date")
