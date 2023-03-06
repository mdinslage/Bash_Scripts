#!/bin/bash

# The intel x540/x550 with SR-IOV support can
# generate up to 63 virtual function adapters.
# however the MAC addressess are randomly assigned.
# This means every reboot the MAC address changes
# which causes the router to assign a different IP 
# on the target VM each time the host is rebooted.
# this script will set the MAC addresses to a static
# value so that dhcp reservation can be used to 
# set a static local IP to your VM's

# To generate useable MAC addresses use this website
# https://macaddress.io/mac-address-generator
# Be sure to use the settings...
# Colon Format / Lowercase / 48 bit / Unicast / LLA

# You can assign up to 63 virtual function adapter 
# MAC addresses here
MACADDRESS1=(
32:ce:f0:1b:7f:7f
12:b8:02:a8:6d:35
3e:98:e0:bb:c5:0f
3e:19:86:ac:1e:ee
52:d3:09:a7:f1:8c
1e:c7:13:70:98:bb
82:56:fa:12:d1:81
5a:64:1a:d1:80:5f
ae:6d:a2:0e:24:c4
0a:53:61:05:ed:62
16:fb:cf:2c:97:ec
7a:09:b4:0e:3a:cc
c6:43:ed:58:c8:f6
42:15:72:e9:a4:e8
3a:aa:90:31:aa:6f
36:05:4f:ed:92:0a
4e:ae:65:e9:c6:78
a6:da:90:a5:dd:9e
8a:dd:07:84:ae:84
ee:31:ef:42:19:14
b2:f4:36:ff:3b:e9
62:92:35:71:23:9a
56:e0:d3:7c:6b:b7
c2:c2:19:6e:6f:1a
);

# Set this to match the number of Virtual Function 
# adapters you are using.
SLOTS=({0..23});

for i in "${!MACADDRESS1[@]}" ; do
  ip link set eth0 vf "${SLOTS[i]}" mac "${MACADDRESS1[i]}"
done
