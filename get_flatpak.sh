#!/bin/bash

# Ask for Slackware verson
read -p "Do you want packages for 15.0 or current? " user_input

# Check user input and set SLACKVER variable
if [ "$user_input" == "15.0" ]; then
    SLACKVER="15.0"
elif [ "$user_input" == "current" ]; then
    SLACKVER="current"
else
    echo "Not a valid response. Script stopped."
    exit 1
fi

rm -rf /tmp/flatpak/
mkdir -p /tmp/flatpak/$SLACKVER
cd /tmp/flatpak/$SLACKVER

for i in flatpak appstream bubblewrap libostree xdg-dbus-proxy xdg-desktop-portal-gtk ; do
  wget -r -np -nd -l1 --accept=*.t?z http://www.slackware.com/~alien/slackbuilds/$i/pkg64/$SLACKVER/
done

