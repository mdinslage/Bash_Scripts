#!/bin/bash

total_pages=0

# Loop through each PDF file in the directory (case-insensitive)
shopt -s nocaseglob
for f in *.pdf; do
  if [[ -f "$f" ]]; then
    pages=$(pdfinfo "$f" 2>/dev/null | grep Pages | awk '{print $2}')
    if [[ -n "$pages" ]]; then
      echo "File: $f, Pages: $pages"
      total_pages=$((total_pages + pages))
    else
      echo -e "\033[31mWarning: Could not get page count for file: $f\033[0m"
    fi
  fi
done
shopt -u nocaseglob  # Reset case-insensitive option

# Print the total number of pages
echo -e "\033[32mTotal Pages: $total_pages\033[0m"
