#!/bin/bash

# Prompt for MAC address generation type
while true; do
    read -p "Do you want to generate (R)andom or (S)equential MAC addresses? (R/S): " choice
    case $choice in
        [Rr]* ) gen_type="random"; break;;
        [Ss]* ) gen_type="sequential"; break;;
        * ) echo "Please answer R for Random or S for Sequential.";;
    esac
done

# Prompt for number of interfaces
while true; do
    read -p "Enter the number of interfaces (1-4): " num_interfaces
    if [[ $num_interfaces =~ ^[1-4]$ ]]; then
        break
    else
        echo "Invalid input. Please enter a number between 1 and 4."
    fi
done

# Prompt for number of MAC addresses
while true; do
    read -p "Enter the number of MAC addresses to generate (1-63): " num_macs
    if [[ $num_macs =~ ^[1-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; then
        break
    else
        echo "Invalid input. Please enter a number between 1 and 63."
    fi
done

# Generate MAC addresses and format them
mac_addresses=()
if [[ $gen_type == "random" ]]; then
    for ((i=0; i<num_interfaces*num_macs; i++)); do
        prefix=$(printf '%02x:%02x:%02x:%02x:%02x:' $((RANDOM%128*2)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
        suffix=$(printf '%02x\n' $((i%256)))
        mac="$prefix$suffix"
        mac_addresses+=($mac)
    done
else
    prefix=$(printf '%02x:%02x:%02x:%02x:%02x:' $((RANDOM%128*2)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))
    for ((i=0; i<num_interfaces*num_macs; i++)); do
        sequential_suffix=$(printf '%02x\n' $((i%256)))
        mac="$prefix$sequential_suffix"
        mac_addresses+=($mac)
    done
fi

# Create set_mac_address.sh file
cat <<EOF > set_mac_address.sh
#!/bin/bash

EOF

for ((interface=0; interface<num_interfaces; interface++)); do
    cat <<EOF >> set_mac_address.sh
MACADDRESS$((interface+1))=(
EOF

    for ((i=interface*num_macs; i<(interface+1)*num_macs; i++)); do
        echo "${mac_addresses[i]}" >> set_mac_address.sh
    done

    cat <<EOF >> set_mac_address.sh
);

EOF
done

cat <<EOF >> set_mac_address.sh
SLOTS=({0..$((num_macs-1))});

EOF

for ((interface=0; interface<num_interfaces; interface++)); do
    cat <<EOF >> set_mac_address.sh
for i in "\${!MACADDRESS$((interface+1))[@]}" ; do
  ip link set eth$interface vf "\${SLOTS[i]}" mac "\${MACADDRESS$((interface+1))[i]}"
done

EOF
done

echo "set_mac_address.sh file created with $num_interfaces interfaces and $num_macs MAC addresses."

