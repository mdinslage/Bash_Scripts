#!/bin/bash

# Prompt for number of MAC addresses to generate
read -p "Enter the number of MAC addresses to generate: " num_macs

# Generate MAC addresses and format them
mac_addresses=()
for ((i=1; i<=num_macs; i++)); do
    mac=$(od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/')
    mac_addresses+=($mac)
done

formatted_macs=$(printf "\t%s\n" "${mac_addresses[@]}")

# Create set_mac_address.sh file
cat <<EOF > set_mac_address.sh
#!/bin/bash

MACADDRESS1=(
${formatted_macs}
);

SLOTS=({0..$((num_macs-1))});

for i in "\${!MACADDRESS1[@]}" ; do
  ip link set eth0 vf "\${SLOTS[i]}" mac "\${MACADDRESS1[i]}"
done
EOF

echo "set_mac_address.sh file created with $num_macs MAC addresses."

