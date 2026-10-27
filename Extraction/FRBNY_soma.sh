#!/bin/bash
# FRBNY_soma.sh
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)

# Appended /soma to base paths to align with API routing and local storage intent
BASE_URL="https://markets.newyorkfed.org/api/soma"
BASE_TARGET="~/USTs-and-Liquidity/data/FRBNY/soma"

ENDPOINT_asof=(
        "asofdates"
)
ENDPOINTS_hld=(
        "tsy"
        "agency"
)

# Loop 1: Fetch asof dates
for ep1 in "${ENDPOINT_asof[@]}"; do
        target="${BASE_TARGET}/${ep1}"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        
        url="${BASE_URL}/${ep1}/list.csv"                 
        output="${target}/tmp/${DATE}"
        HTTP_STATUS=$(curl -g -s -o /dev/null -w "%{http_code}" "${url}")
        
        if [ "${HTTP_STATUS:-000}" -ne 200 ]; then
                echo "  -> Endpoint failed (HTTP ${HTTP_STATUS:-000}). Bypassing to next endpoint."
                continue
        fi

        curl -g -s "${url}" | sed -E "s/\"'-([0-9])/\"-\1/g" | duckdb -c "COPY (SELECT * FROM read_csv_auto('/dev/stdin')) TO '${output}.parquet' (FORMAT parquet, COMPRESSION 'zstd');"        
done

# Loop 2: Fetch holdings utilizing parsed dates
for ep2 in "${ENDPOINTS_hld[@]}"; do
        target="${BASE_TARGET}/${ep2}"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        
        # mapfile executes the subshell and cleanly loads the raw DuckDB output into an array
        mapfile -t AS_OF < <(duckdb -csv -noheader -c "SELECT \"As Of Date\" FROM read_parquet('${BASE_TARGET}/asofdates/tmp/*.parquet');")
        
        for dt in "${AS_OF[@]}"; do
                url="${BASE_URL}/${ep2}/get/asof/${dt}.csv"                 
                output="${target}/tmp/${dt}"
                HTTP_STATUS=$(curl -g -s -o /dev/null -w "%{http_code}" "${url}")
                
                if [ "${HTTP_STATUS:-000}" -ne 200 ]; then
                        echo "  -> Endpoint failed (HTTP ${HTTP_STATUS:-000}). Bypassing to next endpoint."
                        continue
                fi

                curl -g -s "${url}" | sed -E "s/\"'-([0-9])/\"-\1/g" | duckdb -c "COPY (SELECT * FROM read_csv_auto('/dev/stdin')) TO '${output}.parquet' (FORMAT parquet, COMPRESSION 'zstd');"        
        done
done

echo "✅ All pipelines completed successfully."
