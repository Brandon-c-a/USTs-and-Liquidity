df_AUC_HIST_UST = df_AUC_UST


df_MSPD_HIST_Jstripped = df_MSPD5.filter(pl.col("portion_stripped_amt") > 0).join((df_MSPD3mkt.filter(pl.col("outstanding_amt").is_not_null()).select([ 
    "CUSIP", "outstanding_amt",	"inflation_adj_amt","interest_rate_pct",	"record_date",]),
    on=["record_date", "CUSIP"], how="left").sort("record_date")
    ).join(df_TIPSidx, on=["record_date", "CUSIP"],how="left").sort("CUSIP")

df_MSPD_HIST_Junstripped = df_MSPD5.filter(pl.col("portion_stripped_amt") > 0).with_columns(
        (pl.col("maturity_date") - pl.col("record_date")).dt.total_days().alias("Tenor_days")
    )
df_MSPD_HIST_unstrippable = df_MSPD3mkt.join(df_MSPD5, on="CUSIP", how="anti").filter(pl.col("outstanding_amt").is_not_null())
