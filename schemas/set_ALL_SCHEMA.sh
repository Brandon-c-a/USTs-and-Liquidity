#!/bin/bash

duckdb <<EOF

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date                 AS DATE) AS record_date,
        TRY_CAST(cusip                       AS VARCHAR) AS cusip,
        TRY_CAST(security_type                  AS VARCHAR) AS security_type,
        TRY_CAST(security_term                  AS VARCHAR) AS security_term,
        TRY_CAST(auction_date                 AS DATE) AS auction_date,
        TRY_CAST(issue_date                 AS DATE) AS issue_date,
        TRY_CAST(maturity_date                 AS DATE) AS maturity_date,
        TRY_CAST(price_per100                   AS DECIMAL(12,9)) AS price_per100,
        TRY_CAST(accrued_int_per100             AS DECIMAL(12,10)) AS accrued_int_per100,
        TRY_CAST(accrued_int_per1000            AS DECIMAL(12,9)) AS accrued_int_per1000,
        TRY_CAST(adj_accrued_int_per1000        AS DECIMAL(12,9)) AS adj_accrued_int_per1000,
        TRY_CAST(adj_price                      AS DECIMAL(12,9)) AS adj_price,
        TRY_CAST(allocation_pctage              AS DECIMAL(5,2)) AS allocation_pctage,
        TRY_CAST(allocation_pctage_decimals     AS TINYINT) AS allocation_pctage_decimals,
        TRY_CAST(announcemtd_cusip                         AS VARCHAR) AS announcemtd_cusip,
        TRY_CAST(announcemt_date                 AS DATE) AS announcemt_date,
        TRY_CAST(auction_format                 AS VARCHAR) AS auction_format,
        TRY_CAST(avg_med_discnt_rate            AS DECIMAL(12,9)) AS avg_med_discnt_rate,
        TRY_CAST(avg_med_investment_rate        AS DECIMAL(12,9)) AS avg_med_investment_rate,
        TRY_CAST(avg_med_price                  AS DECIMAL(12,9)) AS avg_med_price,
        TRY_CAST(avg_med_discnt_margin          AS DECIMAL(12,9)) AS avg_med_discnt_margin,
        TRY_CAST(avg_med_yield                  AS DECIMAL(12,9)) AS avg_med_yield,
        TRY_CAST(back_dated                     AS BOOLEAN) AS back_dated,
        TRY_CAST(back_dated_date                 AS DATE) AS back_dated_date,
        TRY_CAST(bid_to_cover_ratio             AS DECIMAL(12,9)) AS bid_to_cover_ratio,
        TRY_CAST(callable                       AS BOOLEAN) AS callable,
        TRY_CAST(call_date                 AS DATE) AS call_date,
        TRY_CAST(called_date                 AS DATE) AS called_date,
        TRY_CAST(cash_management_bill_cmb       AS BOOLEAN) AS cash_management_bill_cmb,
        TRY_CAST(closing_time_comp              AS TIME) AS closing_time_comp,
        TRY_CAST(closing_time_noncomp           AS TIME) AS closing_time_noncomp,
        TRY_CAST(comp_accepted                  AS UBIGINT) AS comp_accepted,
        TRY_CAST(comp_bid_decimals              AS DECIMAL(12,9)) AS comp_bid_decimals,
        TRY_CAST(comp_tendered                  AS UBIGINT) AS comp_tendered,
        TRY_CAST(comp_tenders_accepted          AS BOOLEAN) AS comp_tenders_accepted,
        TRY_CAST(corpus_cusip                          AS VARCHAR) AS corpus_cusip,
        TRY_CAST(cpi_base_reference_period      AS VARCHAR) AS cpi_base_reference_period,
        TRY_CAST(currently_outstanding          AS UBIGINT) AS currently_outstanding,
        TRY_CAST(dated_date                 AS DATE) AS dated_date,
        TRY_CAST(direct_bidder_accepted         AS UBIGINT) AS direct_bidder_accepted,
        TRY_CAST(direct_bidder_tendered         AS UBIGINT) AS direct_bidder_tendered,
        TRY_CAST(est_pub_held_mat_by_type_amt   AS UBIGINT) AS est_pub_held_mat_by_type_amt,
        TRY_CAST(fima_included                  AS BOOLEAN) AS fima_included,
        TRY_CAST(fima_noncomp_accepted          AS UBIGINT) AS fima_noncomp_accepted,
        TRY_CAST(fima_noncomp_tendered          AS UBIGINT) AS fima_noncomp_tendered,
        TRY_CAST(first_int_period               AS VARCHAR) AS first_int_period,
        TRY_CAST(first_int_payment_date                 AS DATE) AS first_int_payment_date,
        TRY_CAST(floating_rate                  AS BOOLEAN) AS floating_rate,
        TRY_CAST(frn_index_determination_date                 AS DATE) AS frn_index_determination_date,
        TRY_CAST(frn_index_determination_rate   AS DECIMAL(12,9)) AS frn_index_determination_rate,
        TRY_CAST(high_discnt_rate               AS DECIMAL(12,9)) AS high_discnt_rate,
        TRY_CAST(high_investment_rate           AS DECIMAL(12,9)) AS high_investment_rate,
        TRY_CAST(high_price                     AS DECIMAL(12,9)) AS high_price,
        TRY_CAST(high_discnt_margin             AS DECIMAL(12,9)) AS high_discnt_margin,
        TRY_CAST(high_yield                     AS DECIMAL(12,9)) AS high_yield,
        TRY_CAST(index_ratio_on_issue_date                 AS DECIMAL(12,9)) AS index_ratio_on_issue_date,
        TRY_CAST(indirect_bidder_accepted       AS UBIGINT) AS indirect_bidder_accepted,
        TRY_CAST(indirect_bidder_tendered       AS UBIGINT) AS indirect_bidder_tendered,
        TRY_CAST(int_payment_frequency          AS VARCHAR) AS int_payment_frequency,
        TRY_CAST(int_rate                       AS DECIMAL(12,9)) AS int_rate,
        TRY_CAST(low_discnt_rate                AS DECIMAL(12,9)) AS low_discnt_rate,
        TRY_CAST(low_investment_rate            AS DECIMAL(12,9)) AS low_investment_rate,
        TRY_CAST(low_price                      AS DECIMAL(12,9)) AS low_price,
        TRY_CAST(low_discnt_margin              AS DECIMAL(12,9)) AS low_discnt_margin,
        TRY_CAST(low_yield                      AS DECIMAL(12,9)) AS low_yield,
        TRY_CAST(mat_date                 AS DATE) AS mat_date   ,
        TRY_CAST(max_comp_award                 AS UBIGINT) AS max_comp_award,
        TRY_CAST(max_noncomp_award              AS UINTEGER) AS max_noncomp_award,
        TRY_CAST(max_single_bid                 AS UBIGINT) AS max_single_bid,
        TRY_CAST(min_bid_amt                    AS UINTEGER) AS min_bid_amt,
        TRY_CAST(min_strip_amt                  AS UINTEGER) AS min_strip_amt,
        TRY_CAST(min_to_issue                   AS UINTEGER) AS min_to_issue,
        TRY_CAST(multiples_to_bid               AS UINTEGER) AS multiples_to_bid,
        TRY_CAST(multiples_to_issue             AS UINTEGER) AS multiples_to_issue,
        TRY_CAST(nlp_exclusion_amt              AS UBIGINT) AS nlp_exclusion_amt,
        TRY_CAST(nlp_reporting_threshold        AS UBIGINT) AS nlp_reporting_threshold,
        TRY_CAST(noncomp_accepted               AS UBIGINT) AS noncomp_accepted,
        TRY_CAST(noncomp_tenders_accepted       AS BOOLEAN) AS noncomp_tenders_accepted,
        TRY_CAST(offering_amt                   AS UBIGINT) AS offering_amt,
        TRY_CAST(original_cusip                          AS VARCHAR) AS original_cusip,
        TRY_CAST(original_dated_date                 AS DATE) AS original_dated_date,
        TRY_CAST(original_issue_date                 AS DATE) AS original_issue_date,
        TRY_CAST(original_security_term         AS VARCHAR) AS original_security_term,
        TRY_CAST(pdf_filenm_announcemt          AS VARCHAR) AS pdf_filenm_announcemt,
        TRY_CAST(pdf_filenm_comp_results        AS VARCHAR) AS pdf_filenm_comp_results,
        TRY_CAST(pdf_filenm_noncomp_results     AS VARCHAR) AS pdf_filenm_noncomp_results,
        TRY_CAST(primary_dealer_accepted        AS UBIGINT) AS primary_dealer_accepted,
        TRY_CAST(primary_dealer_tendered        AS UBIGINT) AS primary_dealer_tendered,
        TRY_CAST(ref_cpi_on_dated_date          AS DECIMAL(12,9)) AS ref_cpi_on_dated_date,
        TRY_CAST(ref_cpi_on_issue_date          AS DECIMAL(12,9)) AS ref_cpi_on_issue_date,
        TRY_CAST(reopening                      AS BOOLEAN) AS reopening,
        TRY_CAST(security_term_day_month        AS VARCHAR) AS security_term_day_month,
        TRY_CAST(security_term_week_year        AS VARCHAR) AS security_term_week_year,
        TRY_CAST(series                         AS VARCHAR) AS series,
        TRY_CAST(soma_accepted                  AS UBIGINT) AS soma_accepted,
        TRY_CAST(soma_holdings                  AS UBIGINT) AS soma_holdings,
        TRY_CAST(soma_included                  AS BOOLEAN) AS soma_included,
        TRY_CAST(soma_tendered                  AS UBIGINT) AS soma_tendered,
        TRY_CAST(spread                         AS DECIMAL(12,9)) AS spread,
        TRY_CAST(std_int_payment_per1000        AS DECIMAL(12,9)) AS std_int_payment_per1000,
        TRY_CAST(strippable                     AS BOOLEAN) AS strippable,
        TRY_CAST(tiin_conversion_factor_per1000 AS DECIMAL(12,9)) AS tiin_conversion_factor_per1000,
        TRY_CAST(total_accepted                 AS UBIGINT) AS total_accepted,
        TRY_CAST(total_tendered                 AS UBIGINT) AS total_tendered,
        TRY_CAST(treas_retail_accepted          AS UINTEGER) AS treas_retail_accepted,
        TRY_CAST(treas_retail_tenders_accepted  AS BOOLEAN) AS treas_retail_tenders_accepted,
        TRY_CAST(unadj_accrued_int_per1000      AS DECIMAL(12,9)) AS unadj_accrued_int_per1000,
        TRY_CAST(unadj_price                    AS DECIMAL(12,9)) AS unadj_price,
        TRY_CAST(xml_filenm_announcemt          AS VARCHAR) AS xml_filenm_announcemt,
        TRY_CAST(xml_filenm_comp_results        AS VARCHAR) AS xml_filenm_comp_results,
        TRY_CAST(inflation_index_security       AS BOOLEAN) AS inflation_index_security,
        TRY_CAST(tint_cusip_1                   AS VARCHAR) AS tint_cusip_1,
        TRY_CAST(tint_cusip_2                   AS VARCHAR) AS tint_cusip_2,
        TRY_CAST(pdf_filenm_spec_announcemt     AS VARCHAR) AS pdf_filenm_spec_announcemt
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/auctions_query/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/auctions_query/MASTER.parquet' (FORMAT parquet);


COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(operation_date AS DATE) AS operation_date,
        TRY_CAST(operation_start_time_est AS VARCHAR) AS operation_start_time_est,
        TRY_CAST(cusip_nbr AS VARCHAR) AS cusip_nbr,
        TRY_CAST(coupon_rate_pct AS DECIMAL(12,9)) AS coupon_rate_pct,
        TRY_CAST(maturity_date AS DATE) AS maturity_date,
        TRY_CAST(par_amt_accepted AS DECIMAL(23,8)) AS par_amt_accepted,
        TRY_CAST(weighted_avg_accepted_price AS DECIMAL(23,8)) AS weighted_avg_accepted_price
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/buybacks_security_details/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/buybacks_security_details/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(total_par_amt_offered AS DECIMAL(23,8)) AS total_par_amt_offered,
        TRY_CAST(total_par_amt_accepted AS DECIMAL(23,8)) AS total_par_amt_accepted,
        TRY_CAST(max_par_amt_redeemed AS UBIGINT) AS max_par_amt_redeemed,
        TRY_CAST(settlement_date          AS DATE) AS settlement_date,
        TRY_CAST(preliminary_ann_pdf      AS VARCHAR) AS preliminary_ann_pdf,
        TRY_CAST(preliminary_ann_xml      AS VARCHAR) AS preliminary_ann_xml,
        TRY_CAST(final_ann_pdf            AS VARCHAR) AS final_ann_pdf,
        TRY_CAST(final_ann_xml            AS VARCHAR) AS final_ann_xml,
        TRY_CAST(results_pdf              AS VARCHAR) AS results_pdf,
        TRY_CAST(results_xml              AS VARCHAR) AS results_xml,
        TRY_CAST(special_ann_pdf          AS VARCHAR) AS special_ann_pdf,
        TRY_CAST(operation_type           AS VARCHAR) AS operation_type,
        TRY_CAST(security_type            AS VARCHAR) AS security_type,
        TRY_CAST(maturity_bucket          AS VARCHAR) AS maturity_bucket,
        TRY_CAST(nbr_issues_accepted      AS UTINYINT) AS nbr_issues_accepted,
        TRY_CAST(par_amt_per_offer        AS USMALLINT) AS par_amt_per_offer,
        TRY_CAST(max_nbr_offers           AS UTINYINT) AS max_nbr_offers, 
        TRY_CAST(nbr_issues_eligible      AS UTINYINT) AS nbr_issues_eligible,
        TRY_CAST(operation_date AS DATE) AS operation_date,
        TRY_CAST(operation_start_time_est AS TIME) AS operation_start_time_est,
        TRY_CAST(operation_close_time_est AS TIME) AS operation_close_time_est,
        )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/buybacks_operations/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/buybacks_operations/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(security_type AS VARCHAR) AS security_type,
        TRY_CAST(security_term AS VARCHAR) AS security_term,
        TRY_CAST(reopening AS BOOLEAN) AS reopening,
        TRY_CAST(cusip AS VARCHAR) AS cusip,
        TRY_CAST(offering_amt AS UBIGINT) AS offering_amt,
        TRY_CAST(announcemt_date AS DATE) AS announcemt_date,
        TRY_CAST(auction_date AS DATE) AS auction_date,
        TRY_CAST(issue_date AS DATE) AS issue_date
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/upcoming_auctions/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/upcoming_auctions/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(security_type AS VARCHAR) AS security_type,
        TRY_CAST(security_term AS VARCHAR) AS security_term,
        TRY_CAST(first_auc_date_single_price AS DATE) AS first_auc_date_single_price,
        TRY_CAST(low_rate_pct AS DECIMAL(12,9)) AS low_rate_pct,
        TRY_CAST(first_auc_date_low_rate AS DATE) AS first_auc_date_low_rate,
        TRY_CAST(high_rate_pct AS DECIMAL(12,9)) AS high_rate_pct,
        TRY_CAST(first_auc_date_high_rate AS DATE) AS first_auc_date_high_rate,
        TRY_CAST(high_offer_amt AS UBIGINT) AS high_offer_amt,
        TRY_CAST(first_auc_date_high_offer AS DATE) AS first_auc_date_high_offer,
        TRY_CAST(high_bid_cover_ratio AS DECIMAL(12,9)) AS high_bid_cover_ratio,
        TRY_CAST(first_auc_date_high_bid_cover AS DATE) AS first_auc_date_high_bid_cover,
        TRY_CAST(src_line_nbr AS UBIGINT) AS src_line_nbr,
        TRY_CAST(record_fiscal_year AS USMALLINT) AS record_fiscal_year,
        TRY_CAST(record_fiscal_quarter AS UTINYINT) AS record_fiscal_quarter,
        TRY_CAST(record_calendar_year AS USMALLINT) AS record_calendar_year,
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,
        TRY_CAST(record_calendar_month AS UTINYINT) AS record_calendar_month,
        TRY_CAST(record_calendar_day AS UTINYINT) AS record_calendar_day
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v2/accounting/od/record_setting_auction/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v2/accounting/od/record_setting_auction/MASTER.parquet' (FORMAT parquet);


COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(security_type_desc AS VARCHAR) AS security_type_desc,
        TRY_CAST(series_cd AS VARCHAR) AS series_cd,
        TRY_CAST(security_class1_desc AS VARCHAR) AS security_class1_desc,
        TRY_CAST(security_class2_desc AS VARCHAR) AS security_class2_desc,
        TRY_CAST(security_class3_desc AS VARCHAR) AS security_class3_desc,
        TRY_CAST(interest_rate_pct AS DECIMAL(6,5)) AS interest_rate_pct,
        TRY_CAST(yield_pct AS DECIMAL(6,5)) AS yield_pct,
        TRY_CAST(issue_date AS DATE) AS issue_date,
        TRY_CAST(maturity_date AS DATE) AS maturity_date,
        CAST(try_strptime(interest_pay_date_1, '%m/%d') AS DATE) AS interest_pay_date_1,
        CAST(try_strptime(interest_pay_date_2, '%m/%d') AS DATE) AS interest_pay_date_2,
        CAST(try_strptime(interest_pay_date_3, '%m/%d') AS DATE) AS interest_pay_date_3,
        CAST(try_strptime(interest_pay_date_4, '%m/%d') AS DATE) AS interest_pay_date_4,
        TRY_CAST(issued_amt AS DECIMAL(23,10)) AS issued_amt,
        TRY_CAST(inflation_adj_amt AS DECIMAL(23,10)) AS inflation_adj_amt,
        TRY_CAST(redeemed_amt AS DECIMAL(23,10)) AS redeemed_amt,
        TRY_CAST(outstanding_amt AS DECIMAL(23,8)) AS outstanding_amt,
        TRY_CAST(prior_month_outstanding_amt AS DECIMAL(23,8)) AS prior_month_outstanding_amt,
        TRY_CAST(current_month_issued_amt AS DECIMAL(23,10)) AS current_month_issued_amt,
        TRY_CAST(current_month_redeemed_amt AS DECIMAL(23,10)) AS current_month_redeemed_amt,
        TRY_CAST(current_month_outstanding_amt AS DECIMAL(23,8)) AS current_month_outstanding_amt,
        TRY_CAST(src_line_nbr AS UBIGINT) AS src_line_nbr,
        TRY_CAST(record_fiscal_year AS USMALLINT) AS record_fiscal_year,
        TRY_CAST(record_fiscal_quarter AS UTINYINT) AS record_fiscal_quarter,
        TRY_CAST(record_calendar_year AS USMALLINT) AS record_calendar_year,
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,
        TRY_CAST(record_calendar_month AS UTINYINT) AS record_calendar_month,
        TRY_CAST(record_calendar_day AS UTINYINT) AS record_calendar_day
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_3/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_3/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(security_type_desc AS VARCHAR) AS security_type_desc,
        TRY_CAST(security_class1_desc AS VARCHAR) AS security_class1_desc,
        TRY_CAST(security_class2_desc AS VARCHAR) AS security_class2_desc,
        TRY_CAST(series_cd AS VARCHAR) AS series_cd,
        TRY_CAST(interest_rate_pct AS DECIMAL(6,5)) AS interest_rate_pct,
        TRY_CAST(yield_pct AS DECIMAL(6,5)) AS yield_pct,
        TRY_CAST(issue_date AS DATE) AS issue_date,
        TRY_CAST(maturity_date AS DATE) AS maturity_date,
        CAST(try_strptime(interest_pay_date_1, '%m/%d') AS DATE) AS interest_pay_date_1,
        CAST(try_strptime(interest_pay_date_2, '%m/%d') AS DATE) AS interest_pay_date_2,
        CAST(try_strptime(interest_pay_date_3, '%m/%d') AS DATE) AS interest_pay_date_3,
        CAST(try_strptime(interest_pay_date_4, '%m/%d') AS DATE) AS interest_pay_date_4,
        TRY_CAST(issued_amt AS DECIMAL(23,10)) AS issued_amt,
        TRY_CAST(inflation_adj_amt AS DECIMAL(23,10)) AS inflation_adj_amt,
        TRY_CAST(redeemed_amt AS DECIMAL(23,10)) AS redeemed_amt,
        TRY_CAST(outstanding_amt AS DECIMAL(23,8)) AS outstanding_amt,
        TRY_CAST(src_line_nbr AS UBIGINT) AS src_line_nbr,
        TRY_CAST(record_fiscal_year AS USMALLINT) AS record_fiscal_year,
        TRY_CAST(record_fiscal_quarter AS UTINYINT) AS record_fiscal_quarter,
        TRY_CAST(record_calendar_year AS USMALLINT) AS record_calendar_year,
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,
        TRY_CAST(record_calendar_month AS UTINYINT) AS record_calendar_month,
        TRY_CAST(record_calendar_day AS UTINYINT) AS record_calendar_day
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_3_market/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_3_market/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(cusip AS VARCHAR) AS cusip,                   
        TRY_CAST(security_class1_desc    AS VARCHAR) AS security_class1_desc  ,     
        TRY_CAST(security_class2_desc    AS VARCHAR) AS security_class2_desc  ,     
        TRY_CAST(interest_rate_pct       AS DECIMAL(16,14)) AS interest_rate_pct,     
        TRY_CAST(maturity_date           AS DATE) AS maturity_date,     
        TRY_CAST(outstanding_amt         AS DECIMAL(28,14)) AS outstanding_amt,      
        TRY_CAST(portion_unstripped_amt  AS DECIMAL(28,14)) AS portion_unstripped_amt,      
        TRY_CAST(portion_stripped_amt    AS DECIMAL(28,14)) AS portion_stripped_amt,      
        TRY_CAST(reconstituted_amt       AS DECIMAL(28,14)) AS reconstituted_amt ,      
        TRY_CAST(src_line_nbr            AS UBIGINT) AS src_line_nbr,      
        TRY_CAST(record_fiscal_year      AS USMALLINT) AS record_fiscal_year,      
        TRY_CAST(record_fiscal_quarter   AS UTINYINT) AS record_fiscal_quarter,      
        TRY_CAST(record_calendar_year    AS USMALLINT) AS record_calendar_year,      
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,      
        TRY_CAST(record_calendar_month   AS UTINYINT) AS record_calendar_month,     
        TRY_CAST(record_calendar_day     AS UTINYINT) AS record_calendar_day,
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_5/tmp/*.parquet', union_by_name=True)
)  TO '~/USTs-and-Liquidity/data/UST/v1/debt/mspd/mspd_table_5/MASTER.parquet' (FORMAT parquet);


COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(frn AS VARCHAR) AS frn,
        TRY_CAST(cusip AS VARCHAR) AS cusip,
        TRY_CAST(original_dated_date AS DATE) AS original_dated_date,
        TRY_CAST(original_issue_date AS DATE) AS original_issue_date,
        TRY_CAST(maturity_date AS DATE) AS maturity_date,
        TRY_CAST(spread AS DECIMAL(12,10)) AS spread,
        TRY_CAST(start_of_accrual_period AS DATE) AS start_of_accrual_period,
        TRY_CAST(end_of_accrual_period AS DATE) AS end_of_accrual_period,
        TRY_CAST(daily_index AS DECIMAL(12,10)) AS daily_index,
        TRY_CAST(daily_int_accrual_rate AS DECIMAL(12,10)) AS daily_int_accrual_rate,
        TRY_CAST(daily_accrued_int_per100 AS DECIMAL(12,10)) AS daily_accrued_int_per100,
        TRY_CAST(accr_int_per100_pmt_period AS DECIMAL(12,10)) AS accr_int_per100_pmt_period
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/frn_daily_indexes/*/*', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/frn_daily_indexes/MASTER.parquet' (FORMAT parquet, COMPRESSION 'zstd');

COPY (
  SELECT DISTINCT * REPLACE (   
        TRY_CAST(cusip AS VARCHAR ) AS cusip,
        TRY_CAST(original_issue_date AS DATE ) AS original_issue_date,
        TRY_CAST(dated_date AS DATE ) AS dated_date,
        TRY_CAST(ref_cpi_on_dated_date AS DECIMAL(9,5) ) AS ref_cpi_on_dated_date,
        TRY_CAST(interest_rate AS DECIMAL(9,6) ) AS interest_rate,
        TRY_CAST(series AS VARCHAR    ) AS series,
        TRY_CAST(additional_issue_date AS VARCHAR ) AS additional_issue_date,

  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/tips_cpi_data_summary/*/*', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/tips_cpi_data_summary/MASTER.parquet' (FORMAT parquet, COMPRESSION 'zstd');

COPY (
  SELECT DISTINCT * REPLACE (   
        TRY_CAST(cusip               AS VARCHAR) AS cusip,
        TRY_CAST(original_issue_date AS DATE       ) AS original_issue_date,
        TRY_CAST(index_date          AS DATE       ) AS index_date,
        TRY_CAST(ref_cpi             AS DECIMAL(9,5)     ) AS ref_cpi,
        TRY_CAST(index_ratio         AS DECIMAL(7,5)     ) AS index_ratio,
        TRY_CAST(pdf_link            AS VARCHAR    ) AS pdf_link,
        TRY_CAST(xml_link            AS VARCHAR    ) AS xml_link,

  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/od/tips_cpi_data_detail/*/*', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/od/tips_cpi_data_detail/MASTER.parquet' (FORMAT parquet, COMPRESSION 'zstd');

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(transaction_today_amt AS BIGINT) AS transaction_today_amt,
        TRY_CAST(transaction_mtd_amt AS BIGINT) AS transaction_mtd_amt,
        TRY_CAST(transaction_fytd_amt AS BIGINT) AS transaction_fytd_amt,
        TRY_CAST(src_line_nbr AS UBIGINT) AS src_line_nbr,
        TRY_CAST(record_fiscal_year AS USMALLINT) AS record_fiscal_year,
        TRY_CAST(record_fiscal_quarter AS UTINYINT) AS record_fiscal_quarter,
        TRY_CAST(record_calendar_year AS USMALLINT) AS record_calendar_year,
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,
        TRY_CAST(record_calendar_month AS UTINYINT) AS record_calendar_month,
        TRY_CAST(record_calendar_day AS UTINYINT) AS record_calendar_day
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/dts/public_debt_transactions/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/dts/public_debt_transactions/MASTER.parquet' (FORMAT parquet, COMPRESSION 'zstd');

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST(record_date AS DATE) AS record_date,
        TRY_CAST(adj_today_amt AS BIGINT) AS adj_today_amt,
        TRY_CAST(adj_mtd_amt AS BIGINT) AS adj_mtd_amt,
        TRY_CAST(adj_fytd_amt AS BIGINT) AS adj_fytd_amt,
        TRY_CAST(src_line_nbr AS UBIGINT) AS src_line_nbr,
        TRY_CAST(record_fiscal_year AS USMALLINT) AS record_fiscal_year,
        TRY_CAST(record_fiscal_quarter AS UTINYINT) AS record_fiscal_quarter,
        TRY_CAST(record_calendar_year AS USMALLINT) AS record_calendar_year,
        TRY_CAST(record_calendar_quarter AS UTINYINT) AS record_calendar_quarter,
        TRY_CAST(record_calendar_month AS UTINYINT) AS record_calendar_month,
        TRY_CAST(record_calendar_day AS UTINYINT) AS record_calendar_day
  )
  FROM read_parquet('~/USTs-and-Liquidity/data/UST/v1/accounting/dts/adjustment_public_debt_transactions_cash_basis/tmp/*.parquet', union_by_name=True)
) TO '~/USTs-and-Liquidity/data/UST/v1/accounting/dts/adjustment_public_debt_transactions_cash_basis/MASTER.parquet' (FORMAT parquet, COMPRESSION 'zstd');
EOF
