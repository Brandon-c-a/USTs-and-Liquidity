######################## __rct \ RECENT ,  ############################ 
#AUCTION 
df_AUC_MTD = df_AUC_UST.filter(pl.col("issue_date") > MSPD_date
).sort("record_date",descending=True)

# MSPD 5
df_MSPD5_rct = df_MSPD5.filter(
    pl.col("record_date") >= MSPD_date
).sort("record_date")


df_MSPD3mkt_rct = (
    df_MSPD3mkt.filter(pl.col("record_date") >= MSPD_date)
).sort("record_date")


# MSPD join
df_MSPD_Jrct = df_MSPD3mkt_rct.sort( ["CUSIP", "issue_date"], descending=[False, True] ).with_columns(
        sequence_id=pl.int_range(1, pl.len() + 1).over("CUSIP")
    ).pivot(
        index='CUSIP',
        on="sequence_id",
        values=[
            "issue_date", "yield_pct",  
            "issued_amt", "inflation_adj_amt",
        ]
    )
df_MSPD_Jrct = df_MSPD_Jrct.join(
    df_MSPD3mkt_rct.filter(
        pl.col("outstanding_amt").is_not_null()
    ),
    on="CUSIP", how="full", coalesce=True
).join(
    df_MSPD5_rct.drop(["maturity_date_T5", "interest_rate_pct_T5", "outstanding_amt_T5"]),
        on=["CUSIP", "record_date", "TYPE"], how="full", coalesce=True
      )

extracted_schema_Jrct = df_MSPD_Jrct.select(pl.all().exclude(head_cols_mspd)).collect_schema()
ordered_columns_Jrct = pl.DataFrame({
    "column_name": extracted_schema_Jrct.names(),
    "data_type": [str(dtype) for dtype in extracted_schema_Jrct.values()]
}).sort(["data_type", "column_name"],descending=[False,False]).get_column("column_name").to_list()
ordered_columns_Jrct = head_cols_mspd + ordered_columns_Jrct
df_MSPD_Jrct = df_MSPD_Jrct.select(ordered_columns_Jrct)
