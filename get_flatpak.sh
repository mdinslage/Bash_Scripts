#!/bin/bash

if [ -z "$ARCH" ]; then
  case "$( uname -m )" in
    i?86) ARCH=i586 ;;
    arm*) ARCH=arm ;;
       *) ARCH=$( uname -m ) ;;
  esac
fi

# Check architecture
if [ "$ARCH" = "i586" ]; then
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "i686" ]; then
  LIBDIRSUFFIX=""
else [ "$ARCH" = "x86_64" ] 
  LIBDIRSUFFIX="64"
fi

# Ask for Slackware version
while true; do
  read -rp "Do you want packages for 15.0 or current? " user_input

  # Check user input and set SLACKVER variable
  if [ "$user_input" == "15.0" ]; then
      SLACKVER="15.0"
      break
  elif [ "$user_input" == "current" ]; then
      SLACKVER="current"
      break
  else
      echo "Not a valid response. Please enter '15.0' or 'current'."
  fi
done

rm -rf /tmp/flatpak/
mkdir -p /tmp/flatpak/"$SLACKVER"
cd /tmp/flatpak/"$SLACKVER" || exit

# Flatpak package and dependencies
packages=(
  "flatpak"
  "appstream"
  "bubblewrap"
  "libostree"
  "xdg-dbus-proxy"
  "xdg-desktop-portal-gtk"
)

# Get the packages
for i in "${packages[@]}"; do
  wget -r -np -nd -l1 --accept=*.t?z http://www.slackware.com/~alien/slackbuilds/"$i"/pkg$LIBDIRSUFFIX/"$SLACKVER"/
done