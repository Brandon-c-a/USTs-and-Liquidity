#!/bin/bash
# FRBNY_LG.sh
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)
START=1990
YEAR=$(date +%Y)
YRS=($(seq $START $YEAR))

BASE_URL="https://markets.newyorkfed.org/api"
BASE_TARGET="~/USTs-and-Liquidity/data/FRBNY"

ENDPOINTS=(
        "pd/get/all/timeseries.csv"
)
for ep0 in "${ENDPOINTS[@]}"; do
        target="${BASE_TARGET}/pd/timeseries"
        mkdir -p "${target}/tmp"
        echo "Fetching and converting: ${target}..."
        
        url="${BASE_URL}/${ep0}"                 
        output="${target}/tmp/${DATE}_${TIME}"
        HTTP_STATUS=$(curl -g -s -o /dev/null -w "%{http_code}" "${url}")
        
        if [ "${HTTP_STATUS:-000}" -ne 200 ]; then
                echo "  -> Endpoint failed (HTTP ${HTTP_STATUS:-000}). Bypassing to next endpoint."
                continue
        fi

        curl -g -s "${url}" | sed -E "s/\"'-([0-9])/\"-\1/g" | duckdb -c "COPY (SELECT * FROM read_csv_auto('/dev/stdin')) TO '${output}.parquet' (FORMAT parquet, COMPRESSION 'zstd');"        
done

cd ~/USTs-and-Liquidity/Extraction
./FRBNY_UNLIMIT.sh
./FRBNY_LIMIT.sh
cd ~/USTs-and-Liquidity/schemas
./FRBNY_SCHEMA.sh

