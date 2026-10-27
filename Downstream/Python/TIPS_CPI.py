import os
import requests
import polars as pl
import calendar
from datetime import date, datetime
from decimal import Decimal, ROUND_FLOOR, ROUND_HALF_UP

import os
import requests
import polars as pl


### TIPS ### 
# M5 
df_MSPD5_TIPS = (
    df_MSPD5.filter(pl.col("TYPE").str.contains("Inflation"))
    )
# M3_mkt     
df_MSPD3mkt_TIPS = ( 
    df_MSPD3mkt.filter(
            (pl.col("TYPE").str.contains("Inflation")) & (pl.col("outstanding_amt").is_not_null()) 
        )
    )
df_MSPD_HIST_JTIPS = ( 
    df_MSPD5_TIPS.join(
            df_MSPD3mkt_TIPS.filter( pl.col("outstanding_amt").is_not_null() ),
            on=["record_date", "CUSIP", "TYPE"], 
            how="left", 
            coalesce=True
        ).drop([
            "UST_MSPD_5","UST_MSPD_3","maturity_date_T5",
            "interest_rate_pct_T5","outstanding_amt_T5",
            "interest_pay_date_3","interest_pay_date_4","redeemed_amt"
            ])
    )


# 1. Setup API configuration
url = "https://api.stlouisfed.org/fred/series/observations"
FRED_API_KEY = os.environ.get("FRED_API_KEY")

# Fix: Ensure realtime_end is strictly '9999-12-31' if passing a future date,
# or omit it to default to today's data depending on your output strategy.
params = {
    "series_id": "CPIAUCNS",
    "api_key": FRED_API_KEY,
    "file_type": "json",
    "output_type": "4",
    "realtime_start": "1996-01-01",
    "realtime_end": "9999-12-31" 
}

# 2. Execute Request
response = requests.get(url, params=params)
if response.status_code != 200:
    raise ConnectionError(f"ALFRED API Failure: {response.text}")

# 3. Parse JSON directly into Polars 
# Since FRED returns a nested JSON object with an "observations" key, 
# you should extract that list before feeding it to Polars.
json_data = response.json()
import polars as pl

# Sample incoming payload structure from FRED
df = pl.DataFrame(json_data["observations"])
df = (
    df.select([
    pl.col("date").str.to_date(),
    (
        pl.col("value")
        .replace(".", None)          # Convert FRED's "." missing string token to null         # Parse the numeric string to a float first
        .cast(pl.Decimal(9, 6))      # Cast safely to your targeted Decimal precision
    )
    ])
)
df_monthly_cpi_M = df.select([
    pl.col("date").alias("cpi_date_m"),
    pl.col("date").dt.year().cast(pl.UInt16).alias("cpi_year_m"),
    pl.col("date").dt.month().cast(pl.UInt8).alias("cpi_month_m"),
    pl.col("value").alias("cpi_val_m"),
])
df_monthly_cpi_M1 = df.select([    
    pl.col("date").alias("cpi_date_m+1"),
    pl.col("date").dt.year().cast(pl.UInt16).alias("cpi_month_m+1"),
    pl.col("date").dt.month().cast(pl.UInt8).alias("cpi_year_m+1"),
    pl.col("value").alias("cpi_val_m+1"),
])
#df_monthly_cpi.sort(["cpi_year","cpi_month"])
#print(df.head())
lf_long = (
    df_TIPSAUC.join(
        df_MSPD3mkt_TIPS.unique("CUSIP").select(
            "CUSIP",  "interest_pay_date_1", "interest_pay_date_2"
        ),
        on="CUSIP", 
        how="inner"
    ).filter(
    pl.col("reopening") == False
    ).select([
        "CUSIP", "original_issue_date", "issue_date", "dated_date", 
        "maturity_date", "interest_pay_date_1", "interest_pay_date_2", "first_int_payment_date",
        pl.col("ref_cpi_on_dated_date").alias("base_cpi")
    ]).with_columns(
            date=pl.date_ranges(
                end=pl.col("maturity_date"),
                start=pl.col("dated_date"),
                interval="1d",
                closed="none",  # Options: "both", "left", "right", "none"
            )
        )
        .explode("date")
        .select("CUSIP", "date") # Drop original bounds if no longer required
    ).filter(
    pl.col("date") <=  pl.date(
                            year=year_now, 
                            month=month_now, 
                            day=pl.col("date").dt.days_in_month()
                        )
    )
ref_cpi_all_dates = lf_long.select("date").with_columns(
        #pl.lit(None).alias("RefCPI_date"),
        (pl.col("date") != pl.col("date").dt.month_start()).cast(pl.UInt8).alias("start_month_TF")
    ).with_columns(
        pl.col("date").dt.offset_by("-3mo").dt.month_start().alias("cpi_date_m"),
        pl.col("date").dt.offset_by("-2mo").dt.month_start().alias("cpi_date_m+1"),
     #   pl.col("date").dt.days_in_month().alias("days_month") #* pl.col("start_month_TF")
    ).join(
        df_monthly_cpi_M.select(["cpi_date_m","cpi_val_m"]), 
        on="cpi_date_m", how="left"
    ).join(
        df_monthly_cpi_M1.select(["cpi_date_m+1","cpi_val_m+1"]),
        on="cpi_date_m+1", how="left"
    ).with_columns(
        pl.col("cpi_val_m").alias("RefCPI_m"),
        pl.col("cpi_val_m+1").alias("RefCPI_m+1")
    ).drop(
        ["cpi_val_m", "cpi_val_m+1"]
    ).with_columns(
        (
            pl.col("RefCPI_m") + 
                (
                pl.col("start_month_TF") * 
                    (
                    (pl.col("RefCPI_m+1") - pl.col("RefCPI_m")) *
                        (
                        ((pl.col("date").dt.offset_by("-1d")).dt.day().cast(pl.UInt8))/
                        ((pl.col("date").dt.days_in_month()).cast(pl.UInt8))
                        )
                    )#.cast(pl.Decimal(9,6))#.alias("RefCPI_date")        
                )
        ).cast(pl.Decimal(9,5)).alias("RefCPI_date")        
    ).unique()
#ref_cpi_all_dates.sort("date")

df_TIPSidx_master = lf_long.join(
    df_TIPSAUC.sort("dated_date").unique(subset="CUSIP", keep="first").sort("dated_date").select([
        "CUSIP",pl.col("ref_cpi_on_dated_date").cast(pl.Decimal(9,5)),"dated_date", "strippable",
    ]),
    on="CUSIP", how="left"
).join(
    ref_cpi_all_dates.select([
        "date","RefCPI_date",
    ]),
    on="date",how="left"
).with_columns(
    (pl.col("RefCPI_date")/pl.col("ref_cpi_on_dated_date")).alias("index_ratio_date")
)
#.filter(pl.col("date")>=date(2008,5,7)).sort(["CUSIP","date"])#.filter(pl.col("dated_date") == pl.col("date"))
df_TIPSAUC = df_TIPSAUC.join(
    df_TIPSidx_master.select([
        pl.col("date").alias("record_date"),"ref_cpi_on_dated_date",
        "index_ratio_date","CUSIP", "RefCPI_date",
    ]),
    on=["CUSIP","record_date"],how="left", coalesce=True
)
df_MSPD_HIST_JTIPS = df_MSPD_HIST_JTIPS.join(
    df_TIPSidx_master.select([
        pl.col("date").alias("record_date"), "CUSIP","strippable","ref_cpi_on_dated_date",
        "index_ratio_date", "RefCPI_date",
    ]),
    on=["record_date","CUSIP"],how="left", coalesce=True
)
