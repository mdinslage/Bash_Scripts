#!/bin/sh

SCHEDULER="shodan.home.local"

cat << EOF | nc $SCHEDULER 8766 | grep jobs= | cut -f 3 -d = | cut -f 2 -d / | cut -f 1 -d ' ' | paste -sd+ - | bc
listcs
exit
EOF
