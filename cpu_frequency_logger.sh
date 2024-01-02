#!/bin/bash

# Log file
output_file="cpu_frequency.log"

# Function to log CPU frequency
log_cpu_frequency() {
    cat /proc/cpuinfo | grep "MHz" | cut -d" " -f3 >> "$output_file"
}

# Main script
echo "Logging CPU frequency to $output_file..."
echo "Press Ctrl+C to stop."

# Loop and log CPU frequency every .1 second
while : ; do
    log_cpu_frequency
    sleep 0.1
done
