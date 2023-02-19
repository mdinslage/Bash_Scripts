#!/bin/bash

# The virtual function adapters have a randomly
# generated MAC Address that changes on each 
# reboot. This script will set the MAC Address
# to a static value.  Having a static MAC Address
# allows us to use DHCP reservation to ensure a 
# static local IP on each VM.

MACADDRESS1=(
f6:3d:19:e6:19:17
42:e5:d1:14:9f:b2
ea:51:1a:b1:a0:7b
82:c4:00:87:ec:30
62:db:16:e0:29:ab
8a:9e:8a:46:f7:b0
62:0e:12:97:ee:c1
);

MACADDRESS2=(
3a:97:74:b0:4e:fb
86:52:6b:50:af:2d
92:03:e3:08:8b:1f
92:18:0c:68:4d:a0
f2:e3:b4:3a:d1:94
8a:6c:34:17:b1:6c
9e:dd:16:2d:ab:5c
);

SLOTS=(0 1 2 3 4 5 6);

for i in "${!MACADDRESS1[@]}" ; do
  ip link set eth0 vf "${SLOTS[i]}" mac "${MACADDRESS1[i]}"
done

for i in "${!MACADDRESS2[@]}" ; do
  ip link set eth1 vf "${SLOTS[i]}" mac "${MACADDRESS2[i]}"
done
