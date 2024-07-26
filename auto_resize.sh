#!/bin/bash

#XFce does not support auto resize of
#the guest window. This script will
#enable that feature.

# Check if the script is run as root
if [ "$(whoami)" != "root" ]; then
  echo "Please run as root"
  exit 1
fi

# Check if spice-vdagent is installed on Slackware
if [ -f /etc/slackware-version ]; then
  if ! ls /var/lib/pkgtools/packages/spice-vdagent* >/dev/null 2>&1; then
    echo "Please install spice-vdagent first"
    exit 1
  fi
fi

# Install spice-vdagent on Debian-based systems
if [ -f /etc/debian_version ]; then
  if ! dpkg -s spice-vdagent >/dev/null 2>&1; then
    echo "Installing spice-vdagent..."
    apt-get update && apt-get install -y spice-vdagent
  fi
fi

# Install spice-vdagent on RedHat-based systems
if [ -f /etc/redhat-release ]; then
  if ! rpm -q spice-vdagent >/dev/null 2>&1; then
    echo "Installing spice-vdagent..."
    yum install -y spice-vdagent
  fi
fi

# Find the active DRM device
card_device=$(ls /sys/class/drm/ | grep -E 'card[0-9]+' | head -n 1 | sed 's/@//')
if [ -z "$card_device" ]; then
  echo "No DRM device found. Exiting."
  exit 1
fi

# Create the udev rule file with the correct card device
echo "ACTION==\"change\", KERNEL==\"$card_device\", SUBSYSTEM==\"drm\", RUN+=\"/usr/local/bin/x-resize\"" > /etc/udev/rules.d/50-x-resize.rules

# Create the x-resize script
cat <<'EOF' > /usr/local/bin/x-resize
#!/bin/sh
PATH=/usr/bin
desktopuser=$(ps -ef | grep -oP "^\w+ (?=.*vdagent( |$))") || exit 0
export DISPLAY=:0
export XAUTHORITY=$(eval echo "~$desktopuser")/.Xauthority
xrandr --output $(xrandr | awk "/ connected/{print \$1; exit; }") --auto
EOF

# Make the x-resize script executable
chmod +x /usr/local/bin/x-resize

# Reload the udev rules
udevadm control --reload-rules

echo "Setup complete. A logout or reboot may be required."
