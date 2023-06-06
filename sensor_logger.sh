#!/bin/bash

output_file="sensor_log.txt"

trap 'exit' INT # Exit on Ctrl+C

while true; do
  temperature=$(sensors | grep Tctl | awk '{print $2}' | tr -d + | tr -d '°C')
  echo "$(date): $temperature" >> "$output_file"
  sleep 1
done

