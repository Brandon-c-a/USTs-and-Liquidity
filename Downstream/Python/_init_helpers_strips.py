master_strips = df_TST.filter(
        (pl.col("announcemtd_cusip") != "null") |  (pl.col("tint_cusip_2") != "null") | (pl.col("tint_cusip_1") != "null") | (pl.col("original_cusip") != "null") | (pl.col("corpus_cusip") != "null") 
).sort("maturity_date",descending=True)

master_strips_rct = master_strips.filter(pl.col("maturity_date") > MSPD_date)
