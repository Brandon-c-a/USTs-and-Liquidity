#!/bin/bash
# FRBNY_LIMIT.sh :: startDate=2026-01-01&endDate=2027-01-01  :: #START=$((2000 + YEAR))
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)
START=1990
YEAR=$(date +%Y)
YRS=($(seq $START $YEAR))

BASE_URL="https://markets.newyorkfed.org/api"
BASE_TARGET="~/USTs-and-Liquidity/data/FRBNY"
ENDPOINTS=(
        "tsy"
        "seclending"
        "ambs"
)

for ep in "${ENDPOINTS[@]}"; do
        target="${BASE_TARGET}/${ep}/results"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        
        url_path="${BASE_URL}/${ep}/all/results/details/search.csv?"

        # IF iteration variable i is assigned in 2+ nested loops, the inner sequence will overwrite the outer loop's state.
        for yr in "${YRS[@]}"; do
                endYR=$((yr + 1))
                suffix="startDate=${yr}-01-01&endDate=${endYR}-01-01"                
                url="${url_path}${suffix}"
                output="${target}/tmp/${DATE}_${TIME}_${yr}"
                echo "  -> Fetching startDate [${yr}] endDate [${endYR}]..."
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

echo "✅ All pipelines completed successfully."
