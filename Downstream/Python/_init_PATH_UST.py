# Directory Paths
Basedir = Path('~/USTs-and-Liquidity/data')
USTdir = Path('~/USTs-and-Liquidity/data/UST')
FRBNYdir = Path('~/USTs-and-Liquidity/data/FRBNY')
Transformed_dir = Path('~/USTs-and-Liquidity/data/data_transformed')
BLSdir = Path('~/USTs-and-Liquidity/data/BLS')

###        MONTHLY STATEMENT OF PUBLIC DEBT Tables (3, 3_marketable, & 5) >>>> ENDPOINT list   ###
MSPD_3_PATH = Path(f"{USTdir}"'/v1/debt/mspd/mspd_table_3')
MSPD_3_files = list(MSPD_3_PATH.glob("MASTER.parquet"))

MSPD_3mkt = Path(f"{USTdir}"'/v1/debt/mspd/mspd_table_3_market')
MSPD_3mkt_files = list(MSPD_3mkt.glob("MASTER.parquet"))

MSPD_5_PATH = Path(f"{USTdir}"'/v1/debt/mspd/mspd_table_5')
MSPD_5_files = list(MSPD_5_PATH.glob("MASTER.parquet"))

###   FLOATING RATE NOTES   ### ### ### ### ### ### ### ### ### ### 
FRN_idx = Path(f"{USTdir}"'/v1/accounting/od/frn_daily_indexes')
FRN_idx_files = list(FRN_idx.glob("MASTER.parquet"))

# TIPS / CPI Index
TIPS_idx = Path(f"{USTdir}"'/v1/accounting/od/tips_cpi_data_detail')
TIPS_idx_files = list(TIPS_idx.glob("MASTER.parquet"))

TIPS_smy = Path(f"{USTdir}"'/v1/accounting/od/tips_cpi_data_summary')
TIPS_smy_files = list(TIPS_smy.glob("MASTER.parquet"))

CPI_U = Path(f"{BLSdir}"'/CPI_U')
CPI_U_files = list(CPI_U.glob("*.parquet"))
###      AUCTIONS ENDPOINT       ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### 
AUCTIONS = Path(f"{USTdir}"'/v1/accounting/od/auctions_query')
AUCTIONS_files = list(AUCTIONS.glob("MASTER.parquet"))

Future_AUCTIONS = Path(f"{USTdir}"'/v1/accounting/od/upcoming_auctions')
FUT_AUCTIONS_files = list(Future_AUCTIONS.glob("MASTER.parquet"))

Record_AUCTIONS = Path(f"{USTdir}"'/v2/accounting/od/record_setting_auction')
REC_AUCTIONS_files = list(Record_AUCTIONS.glob("MASTER.parquet"))


###   Treasury Buyback (Operations | Security Details)   ### ### ### ### ### ### 
buybacks_OPS = Path(f"{USTdir}"'/v1/accounting/od/buybacks_operations')
BBops_files = list(buybacks_OPS.glob("MASTER.parquet"))


buybacks_SD = Path(f"{USTdir}"'/v1/accounting/od/buybacks_security_details')
BBsd_files = list(buybacks_SD.glob("MASTER.parquet"))


###############################################################################################
### TRANSFORMED ###
###############################################################################################
TIPSAUC_P = Path(f"{Transformed_dir}"'/UST/auctions')
TIPSAUC_F = list(TIPSAUC_P.glob("TIPS.parquet"))

