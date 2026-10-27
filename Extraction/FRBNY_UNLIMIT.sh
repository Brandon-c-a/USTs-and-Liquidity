#!/bin/bash
# FRBNY_Daily.sh
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)
BASE_URL="https://markets.newyorkfed.org/api"
BASE_TARGET="~/USTs-and-Liquidity/data/FRBNY"

ENDPOINTS_rp=(
        "results"
        "reverserepo/propositions"
)
ENDPOINTS__all=(
        "fxs"
        "rates"
)

for ep1 in "${ENDPOINTS_rp[@]}"; do
        target="${BASE_TARGET}/rp/${ep1}"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        suffix="search.csv?startDate=1900-01-01"
        url="${BASE_URL}/rp/${ep1}/${suffix}"                 
        output="${target}/tmp/${DATE}_${TIME}"
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

for ep2 in "${ENDPOINTS__all[@]}"; do
        target="${BASE_TARGET}/${ep2}"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        suffix="all/search.csv?startDate=1900-01-01"
        url="${BASE_URL}/${ep2}/${suffix}"                 
        output="${target}/tmp/${DATE}_${TIME}"
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
echo "✅ All pipelines completed successfully."
