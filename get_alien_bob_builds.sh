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
elif [ "$ARCH" = "x86_64" ]; then
  LIBDIRSUFFIX="64"
fi

while true; do
  read -rp "Download binary or source? Enter 'binary' or 'source': " USER_INPUT

  # Check user's input
  if [ "$USER_INPUT" = "binary" ]; then
    while true; do
      read -rp "Do you want packages for 15.0 or current? " VERSION

      # Set Slackware Version
      if [ "$VERSION" == "15.0" ]; then
        SLACKVER="15.0"
        break
      elif [ "$VERSION" == "current" ]; then
        SLACKVER="current"
        break
      else
        echo "Not a valid response. Please enter '15.0' or 'current'."
      fi
    done

    rm -rf /tmp/alien_bob/
    mkdir -p /tmp/alien_bob/"$SLACKVER"
    cd /tmp/alien_bob/"$SLACKVER" || exit

    # Prompt for a list of packages
    read -rp "Enter a space-separated list of packages: " user_packages
    IFS=' ' read -ra packages <<< "$user_packages"

    # Get the packages
    for i in "${packages[@]}"; do
      wget -r -np -nd -l1 --accept=*.t?z http://www.slackware.com/~alien/slackbuilds/"$i"/pkg$LIBDIRSUFFIX/"$SLACKVER"/
    done

    break
  elif [ "$USER_INPUT" = "source" ]; then
    rm -rf /tmp/alien_bob/
    mkdir -p /tmp/alien_bob/source
    cd /tmp/alien_bob/source || exit

    # Prompt for a list of packages for source
    read -rp "Enter a space-separated list of source packages: " user_source_packages
    IFS=' ' read -ra source_packages <<< "$user_source_packages"

    # Get the source
    for i in "${source_packages[@]}"; do
      lftp -c "open http://www.slackware.com/~alien/slackbuilds/$i/; mirror build"
      mv build "$i"
    done

    break
  else
    echo "Invalid choice. Please enter 'binary' or 'source'."
  fi
done
