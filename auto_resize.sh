#!/bin/bash

# XFce does not support auto resize of 
#the guest window. this script will 
#enable that feature.

# Check if the user is root
if [ "$(whoami)" != "root" ]; then
  echo "Please run as root"
  exit 1
fi

# Check if the spice-vdagent file exists
if [ -f /etc/slackware-version ]; then
  if ! [ -e /var/lib/pkgtools/packages/spice-vdagent* ]; then
    echo "Please install spice-vdagent first"
    exit 1
  fi
fi

# Debian family system check
if [ -f /etc/debian_version ]; then
  if ! dpkg -s spice-vdagent >/dev/null 2>&1; then
    echo "Installing spice-vdagent..."
    apt-get update
    apt-get install -y spice-vdagent
  fi
fi

#RedHat famiy system check
if [ -f /etc/redhat-release ]; then
  if ! rpm -q spice-vdagent >/dev/null 2>&1; then
    echo "Installing spice-vdagent..."
    yum install -y spice-vdagent
  fi
fi

# Create the udev rule file
echo 'ACTION=="change",KERNEL=="card0",SUBSYSTEM=="drm",RUN+="/usr/local/bin/x-resize"' > /etc/udev/rules.d/50-x-resize.rules

# Create the x-resize script
echo '#! /bin/sh 
PATH=/usr/bin
desktopuser=$(/bin/ps -ef  | /bin/grep -oP "^\w+ (?=.*vdagent( |$))") || exit 0
export DISPLAY=:0
export XAUTHORITY=$(eval echo "~$desktopuser")/.Xauthority
xrandr --output $(xrandr | awk "/ connected/{print \$1; exit; }") --auto' > /usr/local/bin/x-resize

# Make file executable
chmod +x /usr/local/bin/x-resize

# Reload the udev rules
udevadm control --reload-rules

echo "Finished, logout or reboot may be required"


