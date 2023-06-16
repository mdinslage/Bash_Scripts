#!/bin/bash

# Log file
output_file="cpu_temperature.log"

# Function to log CPU temperature
log_cpu_temperature() {
    sensors | grep Tctl | awk '{print $2}' | tr -d '+°C' >> "$output_file"
}

# Main script
echo "Logging CPU temperature to $output_file..."
echo "Press Ctrl+C to stop."

# Loop and log CPU temperature every .1 second
while : ; do
    log_cpu_temperature
    sleep 0.1
done
