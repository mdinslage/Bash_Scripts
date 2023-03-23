#!/bin/bash
shopt -s globstar nullglob
total=0

for file in **/*.pdf; do
    pages=$(pdfinfo "$file" | grep Pages | awk '{print $2}')
    total=$((total+pages))
    echo "$file has $pages pages."
done

echo "Total number of pages: $total"
