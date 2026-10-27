# UST LazyFrames
df_MSPD_3 = pl.scan_parquet(MSPD_3_files).collect()
df_MSPD3mkt = pl.scan_parquet(MSPD_3mkt_files).collect()
df_MSPD5 = pl.scan_parquet(MSPD_5_files).collect()

df_FRNidx = pl.scan_parquet(FRN_idx_files).collect()
df_TIPSidx = pl.scan_parquet(TIPS_idx_files).collect()
df_TIPSsmy = pl.scan_parquet(TIPS_smy_files).collect()

df_AUC_UST = pl.scan_parquet(AUCTIONS_files).collect()
df_AUC_FUT = pl.scan_parquet(FUT_AUCTIONS_files).collect()
df_AUC_REC = pl.scan_parquet(REC_AUCTIONS_files).collect()

df_BBops = pl.scan_parquet(BBops_files).collect()    
df_BBsd = pl.scan_parquet(BBsd_files).collect()

### Transformed 
df_TIPSAUC = pl.scan_parquet(TIPSAUC_F).collect()

