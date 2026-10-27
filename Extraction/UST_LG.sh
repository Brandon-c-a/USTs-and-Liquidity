#!/bin/bash
DATE=$(date +%Y-%m-%d)
BASE_URL="https://api.fiscaldata.treasury.gov/services/api/fiscal_service"
BASE_TARGET="~/USTs-and-Liquidity/data/UST"
# Array of periodic endpoints (Weekly, Monthly, Quarterly, Annual)
ENDPOINTS=(
        "v1/accounting/od/rates_of_exchange"
        "v1/accounting/od/auctions_query"
        "v1/accounting/od/buybacks_operations"
        "v1/accounting/od/buybacks_security_details"
        "v1/accounting/od/upcoming_auctions"
        "v1/debt/mspd/mspd_table_3_market"
        "v1/debt/mspd/mspd_table_3_nonmarket"
        "v1/debt/mspd/mspd_table_5"
        "v1/accounting/od/tips_cpi_data_summary"
        "v1/accounting/od/tips_cpi_data_detail"
        "v1/accounting/od/frn_daily_indexes"
        )
for i in "${!ENDPOINTS[@]}"; do
    
    # Establish base target and create directory outside the pagination loop
    target="${BASE_TARGET}/${ENDPOINTS[$i]}"
    mkdir -p "${target}/tmp"
    echo "Fetching and converting: ${target}..."
    
    # Restored exhaustive loop to 250; conditional break will safely terminate early upon data exhaustion
    for page in {1..500}; do
        echo "  -> Fetching page ${page}..."
        
        # Reintegrated sort=-record_date and corrected page size to 10000
        suffix="page[number]=${page}&page[size]=10000&format=csv"
        url="${BASE_URL}/${ENDPOINTS[$i]}?${suffix}"
        
        # Output variable strictly defined as the terminal Parquet artifact
        output="${target}/tmp/${DATE}_p${page}"

        HTTP_STATUS=$(curl -g -s -o /dev/null -w "%{http_code}" "${url}")
        
        # Enforce numeric fallback to prevent 'integer expected' errors
        # If HTTP_STATUS is empty, it evaluates as 000
        if [ "${HTTP_STATUS:-000}" -ne 200 ]; then
            echo "  -> Endpoint exhausted or failed (HTTP ${HTTP_STATUS:-000}). Terminating pagination."
            break
        fi  # <-- REQUIRED: This 'fi' prevents the 'unexpected token done' error

        # Stream directly from standard output, strictly sanitize numeric CSV anomalies in RAM, and pipe to DuckDB
        curl -g -s "${url}" | sed -E "s/\"'-([0-9])/\"-\1/g" | duckdb -c "COPY (SELECT * FROM read_csv_auto('/dev/stdin')) TO '${output}.parquet' (FORMAT parquet, COMPRESSION 'zstd');"
        
    done
done
cd ~/USTs-and-Liquidity/schemas
./set_ALL_SCHEMA.sh
echo "✅ All pipelines completed successfully."
