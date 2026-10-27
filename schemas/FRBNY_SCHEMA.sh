#!/bin/bash
duckdb <<'EOF'

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("Operation Id" AS VARCHAR) AS "Operation Id",
        TRY_CAST("Auction Status" AS VARCHAR) AS "Auction Status",
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Operation Date" AS DATE) AS "Operation Date",
        TRY_CAST("Settlement Date" AS DATE) AS "Settlement Date",
        TRY_CAST("Maturity Date" AS DATE) AS "Maturity Date",
        TRY_CAST("Release Time" AS VARCHAR) AS "Release Time",
        TRY_CAST("Close Time" AS VARCHAR) AS "Close Time",
        TRY_CAST("Note" AS VARCHAR) AS "Note",
        TRY_CAST("Total Par Amt Submitted ($Millions)" AS BIGINT) AS "Total Par Amt Submitted ($Millions)",
        TRY_CAST("Total Par Amt Accepted ($Millions)" AS BIGINT) AS "Total Par Amt Accepted ($Millions)",
        TRY_CAST("Total Par Amt Extended ($Millions)" AS DOUBLE) AS "Total Par Amt Extended ($Millions)",
        TRY_CAST("CUSIP" AS VARCHAR) AS "CUSIP",
        TRY_CAST("Security Descripton" AS VARCHAR) AS "Security Descripton",
        TRY_CAST("Par Amt Submitted" AS BIGINT) AS "Par Amt Submitted",
        TRY_CAST("Par Amt Accepted" AS BIGINT) AS "Par Amt Accepted",
        TRY_CAST("Par Amt Extended" AS BIGINT) AS "Par Amt Extended",
        TRY_CAST("Weighted Average Rate" AS DOUBLE) AS "Weighted Average Rate",
        TRY_CAST("SOMA Holdings" AS BIGINT) AS "SOMA Holdings",
        TRY_CAST("Theoretical Available To Borrow" AS BIGINT) AS "Theoretical Available To Borrow",
        TRY_CAST("Actual Available To Borrow" AS BIGINT) AS "Actual Available To Borrow",
        TRY_CAST("Outstanding Loans" AS BIGINT) AS "Outstanding Loans",
        TRY_CAST("Last Updated" AS VARCHAR) AS "Last Updated",
  )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/seclending/results/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/seclending/results/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("Operation Date" AS DATE) AS "Operation Date",
        TRY_CAST("Operation Id" AS VARCHAR) AS "Operation Id",
        TRY_CAST("Auction Status" AS VARCHAR) AS "Auction Status",
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Operation Direction" AS VARCHAR) AS "Operation Direction",
        TRY_CAST("Auction Method" AS VARCHAR) AS "Auction Method",
        TRY_CAST("Release Time" AS VARCHAR) AS "Release Time",
        TRY_CAST("Close Time" AS VARCHAR) AS "Close Time",
        TRY_CAST("Note" AS VARCHAR) AS "Note",
        TRY_CAST("Settlement Date" AS DATE) AS "Settlement Date",
        TRY_CAST("Maturity/Call Date Range" AS VARCHAR) AS "Maturity/Call Date Range",
        TRY_CAST("Total Par Amt Accepted ($Millions)" AS BIGINT) AS "Total Par Amt Accepted ($Millions)",
        TRY_CAST("Total Par Amt Submitted ($Millions)" AS BIGINT) AS "Total Par Amt Submitted ($Millions)",
        TRY_CAST("Inclusion/Exclusion" AS VARCHAR) AS "Inclusion/Exclusion",
        TRY_CAST("CUSIP" AS VARCHAR) AS "CUSIP",
        TRY_CAST("Security Description" AS VARCHAR) AS "Security Description",
        TRY_CAST("Par Amt Accepted ($)" AS BIGINT) AS "Par Amt Accepted ($)",
        TRY_CAST("Weighted Avg. Accpt. Price/Rate" AS VARCHAR) AS "Weighted Avg. Accpt. Price/Rate",
        TRY_CAST("Least Favorable Accpt. Price/Rate" AS VARCHAR) AS "Least Favorable Accpt. Price/Rate",
        TRY_CAST("% Partial Allocation at Least Favorable Accpt. Price/Rate" AS VARCHAR) AS "% Partial Allocation at Least Favorable Accpt. Price/Rate",
        TRY_CAST("Last Updated" AS VARCHAR) AS "Last Updated",
  )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/tsy/results/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/tsy/results/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (

        TRY_CAST("Auction Status" AS VARCHAR) AS "Auction Status",
        TRY_CAST("Operation Id" AS VARCHAR) AS "Operation Id",
        TRY_CAST("Operation Date" AS DATE) AS "Operation Date",
        TRY_CAST("Operation Direction" AS VARCHAR) AS "Operation Direction",
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Auction Method" AS VARCHAR) AS "Auction Method",
        TRY_CAST("Release/Start Time" AS VARCHAR) AS "Release/Start Time",
        TRY_CAST("Close/End Time" AS VARCHAR) AS "Close/End Time",
        TRY_CAST("Class Type" AS VARCHAR) AS "Class Type",
        TRY_CAST("Settlement Date" AS DATE) AS "Settlement Date",
        TRY_CAST("Note" AS VARCHAR) AS "Note",
        TRY_CAST("Total Amt Accepted Current ($Millions)" AS DOUBLE) AS "Total Amt Accepted Current ($Millions)",
        TRY_CAST("Total Amt Accepted Original ($Millions)" AS DOUBLE) AS "Total Amt Accepted Original ($Millions)",
        TRY_CAST("Total Amt Submitted Current ($Millions)" AS DOUBLE) AS "Total Amt Submitted Current ($Millions)",
        TRY_CAST("Total Amt Submitted Original ($Millions)" AS DOUBLE) AS "Total Amt Submitted Original ($Millions)",
        TRY_CAST("Total Amt Accepted Par ($Millions)" AS DOUBLE) AS "Total Amt Accepted Par ($Millions)",
        TRY_CAST("Total Amt Submitted Par ($Millions)" AS DOUBLE) AS "Total Amt Submitted Par ($Millions)",
        TRY_CAST("Inclusion/Exclusion" AS VARCHAR) AS "Inclusion/Exclusion",
        TRY_CAST("Security Description" AS VARCHAR) AS "Security Description",
        TRY_CAST("CUSIP" AS VARCHAR) AS "CUSIP",
        TRY_CAST("Spec Pool Current Face Amt Accepted ($)" AS DOUBLE) AS "Spec Pool Current Face Amt Accepted ($)",
        TRY_CAST("Spec Pool Original Face Amt Accepted ($)" AS DOUBLE) AS "Spec Pool Original Face Amt Accepted ($)",
        TRY_CAST("TBA Par Amount Accepted ($)" AS BIGINT) AS "TBA Par Amount Accepted ($)",
        TRY_CAST("Basket ID" AS VARCHAR) AS "Basket ID",
        TRY_CAST("Basket Total Current Face Amt Accepted ($)" AS DOUBLE) AS "Basket Total Current Face Amt Accepted ($)",
        TRY_CAST("Basket Total Original Face Amt Accepted ($)" AS DOUBLE) AS "Basket Total Original Face Amt Accepted ($)",
        TRY_CAST("Basket Pool Security Description" AS VARCHAR) AS "Basket Pool Security Description",
        TRY_CAST("Basket Pool CUSIP" AS VARCHAR) AS "Basket Pool CUSIP",
        TRY_CAST("Basket Pool Current Face Amt Accepted ($)" AS DOUBLE) AS "Basket Pool Current Face Amt Accepted ($)",
        TRY_CAST("Basket Pool Original Face Amt Accepted ($)" AS DOUBLE) AS "Basket Pool Original Face Amt Accepted ($)",
        TRY_CAST("Last Updated" AS VARCHAR) AS "Last Updated",
  )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/ambs/results/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/ambs/results/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (

        TRY_CAST("Operation Id" AS VARCHAR) AS "Operation Id",
        TRY_CAST("Auction Status" AS VARCHAR) AS "Auction Status",
        TRY_CAST("Operation Date" AS DATE) AS "Operation Date",
        TRY_CAST("Settlement Date" AS DATE) AS "Settlement Date",
        TRY_CAST("Maturity Date" AS DATE) AS "Maturity Date",
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Operation Method" AS VARCHAR) AS "Operation Method",
        TRY_CAST("Settlement Type" AS VARCHAR) AS "Settlement Type",
        TRY_CAST("Term (Calendar Days)" AS BIGINT) AS "Term (Calendar Days)",
        TRY_CAST("Term" AS VARCHAR) AS "Term",
        TRY_CAST("Release Time" AS VARCHAR) AS "Release Time",
        TRY_CAST("Close Time" AS VARCHAR) AS "Close Time",
        TRY_CAST("Note" AS VARCHAR) AS "Note",
        TRY_CAST("Operation Limit ($Billions)" AS DOUBLE) AS "Operation Limit ($Billions)",
        TRY_CAST("Participating Counterparties" AS BIGINT) AS "Participating Counterparties",
        TRY_CAST("Accepted Counterparties" AS BIGINT) AS "Accepted Counterparties",
        TRY_CAST("Tsy Amt Submitted ($Billions)" AS DOUBLE) AS "Tsy Amt Submitted ($Billions)",
        TRY_CAST("Tsy Amt Accepted ($Billions)" AS DOUBLE) AS "Tsy Amt Accepted ($Billions)",
        TRY_CAST("Tsy Minimum Bid Rate(%)" AS DOUBLE) AS "Tsy Minimum Bid Rate(%)",
        TRY_CAST("Tsy Maximum Bid Rate(%)" AS DOUBLE) AS "Tsy Maximum Bid Rate(%)",
        TRY_CAST("Tsy Offering Rate(%)" AS DOUBLE) AS "Tsy Offering Rate(%)",
        TRY_CAST("Tsy Stop-Out Rate(%)" AS DOUBLE) AS "Tsy Stop-Out Rate(%)",
        TRY_CAST("Tsy Award Rate (%)" AS DOUBLE) AS "Tsy Award Rate (%)",
        TRY_CAST("Tsy Weighted Average Rate (%)" AS DOUBLE) AS "Tsy Weighted Average Rate (%)",
        TRY_CAST("Tsy High Rate (%)" AS DOUBLE) AS "Tsy High Rate (%)",
        TRY_CAST("Tsy Low Rate (%)" AS DOUBLE) AS "Tsy Low Rate (%)",
        TRY_CAST("Tsy Amt At Stop-Out (%)" AS BIGINT) AS "Tsy Amt At Stop-Out (%)",
        TRY_CAST("Agy Amt Submitted ($Billions)" AS DOUBLE) AS "Agy Amt Submitted ($Billions)",
        TRY_CAST("Agy Amt Accepted ($Billions)" AS DOUBLE) AS "Agy Amt Accepted ($Billions)",
        TRY_CAST("Agy Minimum Bid Rate(%)" AS DOUBLE) AS "Agy Minimum Bid Rate(%)",
        TRY_CAST("Agy Maximum Bid Rate(%)" AS DOUBLE) AS "Agy Maximum Bid Rate(%)",
        TRY_CAST("Agy Offering Rate(%)" AS DOUBLE) AS "Agy Offering Rate(%)",
        TRY_CAST("Agy Stop-Out Rate(%)" AS DOUBLE) AS "Agy Stop-Out Rate(%)",
        TRY_CAST("Agy Award Rate (%)" AS DOUBLE) AS "Agy Award Rate (%)",
        TRY_CAST("Agy Weighted Average Rate (%)" AS DOUBLE) AS "Agy Weighted Average Rate (%)",
        TRY_CAST("Agy High Rate (%)" AS DOUBLE) AS "Agy High Rate (%)",
        TRY_CAST("Agy Low Rate (%)" AS DOUBLE) AS "Agy Low Rate (%)",
        TRY_CAST("Agy Amt At Stop-Out (%)" AS DOUBLE) AS "Agy Amt At Stop-Out (%)",
        TRY_CAST("Mbs Amt Submitted ($Billions)" AS DOUBLE) AS "Mbs Amt Submitted ($Billions)",
        TRY_CAST("Mbs Amt Accepted ($Billions)" AS DOUBLE) AS "Mbs Amt Accepted ($Billions)",
        TRY_CAST("Mbs Minimum Bid Rate(%)" AS DOUBLE) AS "Mbs Minimum Bid Rate(%)",
        TRY_CAST("Mbs Maximum Bid Rate(%)" AS DOUBLE) AS "Mbs Maximum Bid Rate(%)",
        TRY_CAST("Mbs Offering Rate(%)" AS DOUBLE) AS "Mbs Offering Rate(%)",
        TRY_CAST("Mbs Stop-Out Rate(%)" AS DOUBLE) AS "Mbs Stop-Out Rate(%)",
        TRY_CAST("Mbs Award Rate (%)" AS DOUBLE) AS "Mbs Award Rate (%)",
        TRY_CAST("Mbs Weighted Average Rate (%)" AS DOUBLE) AS "Mbs Weighted Average Rate (%)",
        TRY_CAST("Mbs High Rate (%)" AS DOUBLE) AS "Mbs High Rate (%)",
        TRY_CAST("Mbs Low Rate (%)" AS DOUBLE) AS "Mbs Low Rate (%)",
        TRY_CAST("Mbs Amt At Stop-Out (%)" AS DOUBLE) AS "Mbs Amt At Stop-Out (%)",
        TRY_CAST("Oth Amt Submitted ($Billions)" AS DOUBLE) AS "Oth Amt Submitted ($Billions)",
        TRY_CAST("Oth Amt Accepted ($Billions)" AS DOUBLE) AS "Oth Amt Accepted ($Billions)",
        TRY_CAST("Oth Minimum Bid Rate(%)" AS DOUBLE) AS "Oth Minimum Bid Rate(%)",
        TRY_CAST("Oth Maximum Bid Rate(%)" AS DOUBLE) AS "Oth Maximum Bid Rate(%)",
        TRY_CAST("Oth Offering Rate(%)" AS DOUBLE) AS "Oth Offering Rate(%)",
        TRY_CAST("Oth Stop-Out Rate(%)" AS DOUBLE) AS "Oth Stop-Out Rate(%)",
        TRY_CAST("Oth Award Rate (%)" AS DOUBLE) AS "Oth Award Rate (%)",
        TRY_CAST("Oth Weighted Average Rate (%)" AS DOUBLE) AS "Oth Weighted Average Rate (%)",
        TRY_CAST("Oth High Rate (%)" AS DOUBLE) AS "Oth High Rate (%)",
        TRY_CAST("Oth Low Rate (%)" AS DOUBLE) AS "Oth Low Rate (%)",
        TRY_CAST("Oth Amt At Stop-Out (%)" AS DOUBLE) AS "Oth Amt At Stop-Out (%)",
        TRY_CAST("Total Amt Submitted ($Billions)" AS DOUBLE) AS "Total Amt Submitted ($Billions)",
        TRY_CAST("Total Amt Accepted ($Billions)" AS DOUBLE) AS "Total Amt Accepted ($Billions)",
        TRY_CAST("Last Updated" AS VARCHAR) AS "Last Updated",
        TRY_CAST("Bank Prop Amt Accepted ($Billions)" AS DOUBLE) AS "Bank Prop Amt Accepted ($Billions)",
        TRY_CAST("GSE Prop Amt Accepted ($Billions)" AS DOUBLE) AS "GSE Prop Amt Accepted ($Billions)",
        TRY_CAST("MMF Prop Amt Accepted ($Billions)" AS DOUBLE) AS "MMF Prop Amt Accepted ($Billions)",
        TRY_CAST("PD Prop Amt Accepted ($Billions)" AS DOUBLE) AS "PD Prop Amt Accepted ($Billions)",
        TRY_CAST("Total Tsy Settle Amt Accepted ($Billions)" AS DOUBLE) AS "Total Tsy Settle Amt Accepted ($Billions)",
        TRY_CAST("Total Mbs Settle Amt Accepted ($Billions)" AS DOUBLE) AS "Total Mbs Settle Amt Accepted ($Billions)",
        TRY_CAST("Total Agy Settle Amt Accepted ($Billions)" AS DOUBLE) AS "Total Agy Settle Amt Accepted ($Billions)",
        TRY_CAST("Total US Dollar Settle Amt Accepted ($Billions)" AS DOUBLE) AS "Total US Dollar Settle Amt Accepted ($Billions)",
  )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/rp/results/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/rp/results/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("Operation Id" AS VARCHAR) AS "Operation Id",
        TRY_CAST("Operation Date" AS DATE) AS "Operation Date",
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Note" AS VARCHAR) AS "Note",
        TRY_CAST("Total Amt Accepted ($Billions)" AS DOUBLE) AS "Total Amt Accepted ($Billions)",
        TRY_CAST("Bank Prop Amt Accepted ($Billions)" AS DOUBLE) AS "Bank Prop Amt Accepted ($Billions)",
        TRY_CAST("GSE Prop Amt Accepted ($Billions)" AS DOUBLE) AS "GSE Prop Amt Accepted ($Billions)",
        TRY_CAST("MMF Prop Amt Accepted ($Billions)" AS DOUBLE) AS "MMF Prop Amt Accepted ($Billions)",
        TRY_CAST("PD Prop Amt Accepted ($Billions)" AS DOUBLE) AS "PD Prop Amt Accepted ($Billions)",
        )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/rp/reverserepo/propositions/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/rp/reverserepo/propositions/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("Operation Type" AS VARCHAR) AS "Operation Type",
        TRY_CAST("Counterparty" AS VARCHAR) AS "Counterparty",
        TRY_CAST("Currency" AS VARCHAR) AS "Currency",
        TRY_CAST("Trade Date" AS DATE) AS "Trade Date",
        TRY_CAST("Settlement Date" AS DATE) AS "Settlement Date",
        TRY_CAST("Maturity Date" AS DATE) AS "Maturity Date",
        TRY_CAST("Term (days)" AS BIGINT) AS "Term (days)",
        TRY_CAST("Amount" AS DOUBLE) AS "Amount",
        TRY_CAST("Interest Rate" AS DOUBLE) AS "Interest Rate",
        TRY_CAST("isSmallValue" AS VARCHAR) AS "isSmallValue",
        TRY_CAST("Last Updated" AS VARCHAR) AS "Last Updated",
  )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/fxs/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/fxs/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("Effective Date" AS DATE) AS "Effective Date",
        TRY_CAST("Rate Type" AS VARCHAR) AS "Rate Type",
        TRY_CAST("Rate (%)" AS DOUBLE) AS "Rate (%)",
        TRY_CAST("1st Percentile (%)" AS DOUBLE) AS "1st Percentile (%)",
        TRY_CAST("25th Percentile (%)" AS DOUBLE) AS "25th Percentile (%)",
        TRY_CAST("75th Percentile (%)" AS DOUBLE) AS "75th Percentile (%)",
        TRY_CAST("99th Percentile (%)" AS DOUBLE) AS "99th Percentile (%)",
        TRY_CAST("Volume ($Billions)" AS BIGINT) AS "Volume ($Billions)",
        TRY_CAST("Target Rate From (%)" AS DOUBLE) AS "Target Rate From (%)",
        TRY_CAST("Target Rate To (%)" AS DOUBLE) AS "Target Rate To (%)",
        TRY_CAST("Intra Day - Low (%)" AS DOUBLE) AS "Intra Day - Low (%)",
        TRY_CAST("Intra Day - High (%)" AS DOUBLE) AS "Intra Day - High (%)",
        TRY_CAST("Standard Deviation (%)" AS DOUBLE) AS "Standard Deviation (%)",
        TRY_CAST("30-Day Average SOFR" AS DOUBLE) AS "30-Day Average SOFR",
        TRY_CAST("90-Day Average SOFR" AS DOUBLE) AS "90-Day Average SOFR",
        TRY_CAST("180-Day Average SOFR" AS DOUBLE) AS "180-Day Average SOFR",
        TRY_CAST("SOFR Index" AS DOUBLE) AS "SOFR Index",
        TRY_CAST("Revision Indicator (Y/N)" AS VARCHAR) AS "Revision Indicator (Y/N)",
        TRY_CAST("Footnote ID" AS BIGINT) AS "Footnote ID",
        )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/rates/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/rates/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (
        TRY_CAST("As Of Date" AS DATE) AS "As Of Date",
        TRY_CAST("CUSIP" AS VARCHAR) AS "CUSIP",
        TRY_CAST("Security Type" AS VARCHAR) AS "Security Type",
        TRY_CAST("Security Description" AS VARCHAR) AS "Security Description",
        TRY_CAST("Term" AS VARCHAR) AS "Term",
        TRY_CAST("Maturity Date" AS DATE) AS "Maturity Date",
        TRY_CAST("Issuer" AS VARCHAR) AS "Issuer",
        TRY_CAST("Spread (%)" AS DOUBLE) AS "Spread (%)",
        TRY_CAST("Coupon (%)" AS DOUBLE) AS "Coupon (%)",
        TRY_CAST("Current Face Value" AS DOUBLE) AS "Current Face Value",
        TRY_CAST("Par Value" AS BIGINT) AS "Par Value",
        TRY_CAST("Inflation Compensation" AS DOUBLE) AS "Inflation Compensation",
        TRY_CAST("Percent Outstanding" AS DOUBLE) AS "Percent Outstanding",
        TRY_CAST("Change From Prior Week" AS DOUBLE) AS "Change From Prior Week",
        TRY_CAST("Change From Prior Year" AS DOUBLE) AS "Change From Prior Year",
        TRY_CAST("is Aggregated" AS VARCHAR) AS "is Aggregated",
        )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/soma/agency/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/soma/agency/MASTER.parquet' (FORMAT parquet);

COPY (
  SELECT DISTINCT * REPLACE (     
        TRY_CAST("As Of Date" AS DATE) AS "As Of Date",
        TRY_CAST("CUSIP" AS VARCHAR) AS "CUSIP",
        TRY_CAST("Security Type" AS VARCHAR) AS "Security Type",
        TRY_CAST("Security Description" AS VARCHAR) AS "Security Description",
        TRY_CAST("Term" AS VARCHAR) AS "Term",
        TRY_CAST("Maturity Date" AS DATE) AS "Maturity Date",
        TRY_CAST("Issuer" AS VARCHAR) AS "Issuer",
        TRY_CAST("Spread (%)" AS DOUBLE) AS "Spread (%)",
        TRY_CAST("Coupon (%)" AS DOUBLE) AS "Coupon (%)",
        TRY_CAST("Current Face Value" AS DOUBLE) AS "Current Face Value",
        TRY_CAST("Par Value" AS BIGINT) AS "Par Value",
        TRY_CAST("Inflation Compensation" AS DOUBLE) AS "Inflation Compensation",
        TRY_CAST("Percent Outstanding" AS DOUBLE) AS "Percent Outstanding",
        TRY_CAST("Change From Prior Week" AS DOUBLE) AS "Change From Prior Week",
        TRY_CAST("Change From Prior Year" AS DOUBLE) AS "Change From Prior Year",
        TRY_CAST("is Aggregated" AS VARCHAR) AS "is Aggregated",
        )
  FROM read_parquet('/home/boom/.workspace/J_mkts/mdata/FRBNY/soma/tsy/tmp/*.parquet', union_by_name=True)
) TO '/home/boom/.workspace/J_mkts/mdata/FRBNY/soma/tsy/MASTER.parquet' (FORMAT parquet);
EOF
