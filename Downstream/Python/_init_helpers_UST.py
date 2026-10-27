ex_cols = [
    "record_fiscal_year", "record_fiscal_quarter", "src_line_nbr", 
    "record_calendar_year", "record_calendar_quarter", "record_calendar_month", "record_calendar_day"
]
exclusions_AUCTION = [
        "pdf_filenm_announcemt",
        "pdf_filenm_comp_results",
        "pdf_filenm_noncomp_results",
        "pdf_filenm_spec_announcemt",
        "xml_filenm_announcemt",
        "xml_filenm_comp_results",
]
dynamic_auction_metrics = [
    "record_date", "auction_date", "issue_date", 
    "offering_amt", "total_tendered", "total_accepted",
    "bid_to_cover_ratio", "high_yield", "avg_med_yield", "low_yield", 
    "price_per100", "accrued_int_per1000",
    "primary_dealer_accepted", "direct_bidder_accepted", 
    "indirect_bidder_accepted", "soma_accepted"
]
static_security_attributes = [
    "CUSIP", "maturity_date", "security_type", "security_term", 
    "original_security_term", "series", "callable", "strippable", 
    "floating_rate", "int_payment_frequency", "original_issue_date", 
    "call_date", "corpus_cusip"
]

MSPD_date = df_MSPD3mkt.get_column("record_date").max()
TIPS_min_dt = df_TIPSidx.get_column("index_date").min()

df_unison = pl.DataFrame({
    "unison_date": pl.date_range(
        start=MSPD_date,
        end=MSPD_date + timedelta(days=30),
        interval="1d",
        eager=True
    )
})


head_cols_mspd = [
    "outstanding_amt","portion_stripped_amt","portion_unstripped_amt","reconstituted_amt", 
    "maturity_date","CUSIP", "Stripped_CUSIP", 
]

exclusions = [
    "Total Treasury TIPS", "Total Treasury Bills", "Total Treasury Bonds","Total Treasury Notes", 
    "Total Treasury Floating Rate Bonds", "Total Treasury Floating Rate Notes", 
    "Total Matured Treasury Bonds", "Total Matured Treasury Bills", "Total Matured Treasury Notes",
    "Total Unmatured Treasury Bonds", "Total Unmatured Treasury Bills", "Total Unmatured Treasury Notes",
    "Total Unmatured Treasury Floating Rate Bonds", "Total Unmatured Treasury Floating Rate Notes",
    "Grand Total", "null"
]
