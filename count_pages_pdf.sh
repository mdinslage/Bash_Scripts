#!/bin/bash

total_pages=0

# Loop through each PDF file in the directory (case-insensitive)
shopt -s nocaseglob
for f in *.pdf; do
  if [[ -f "$f" ]]; then
    pages=$(pdfinfo "$f" | grep Pages | awk '{print $2}')
    echo "File: $f, Pages: $pages"
    total_pages=$((total_pages + pages))
  fi
done
shopt -u nocaseglob  # Reset case-insensitive option

# Print the total number of pages
echo -e "\033[32mTotal Pages: $total_pages\033[0m"

