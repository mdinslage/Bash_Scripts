#!/bin/bash

# Prompt the user for the number of MAC addresses to generate
read -p "Enter the number of MAC addresses to generate: " count

# Generate the specified number of MAC addresses
for ((i=1; i<=$count; i++))
do
  # Generate a random unicast MAC address in the format XX:XX:XX:XX:XX:XX
  mac=$(od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/')

  # Output the generated MAC address
  echo $mac
done

