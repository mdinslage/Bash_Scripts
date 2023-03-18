#!/bin/sh
ROOTFSTYPE=$(mount | grep "on / type" | cut -f 5 -d ' ')
if lsmod | grep -q "^$ROOTFSTYPE " ; then
  echo "You are running a generic kernel."
else
  echo "You are running a huge kernel."
fi
