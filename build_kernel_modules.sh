#!/bin/bash

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "run as root"
    exit 1
fi

#############################
# Rebuild SBo Packages
#############################

# Define an array of SBo packages to rebuild using sbopkg
sbopkg_packages=(
    "openrazer-kernel"
    "nvidia-kernel"
)

# Loop through each package and run the install command.
for pkg in "${sbopkg_packages[@]}"; do
    if [[ "$pkg" == "nvidia-kernel" ]]; then
        echo "Building $pkg with OPEN=yes flag..."
        # Pipe "S" to select saved options and then "P" to proceed.
        printf "S\nP\n" | OPEN=yes sbopkg -i "$pkg"
    else
        echo "Building $pkg..."
        # For packages that don’t prompt for build options, simply auto-confirm with "P".
        yes P | sbopkg -i "$pkg"
    fi
done

#############################
# Build & Install Local Package: virtualbox-kernel
#############################

# Variables for the VirtualBox package build
VBOX_BUILD_DIR="/home/daedra/Documents/virtualbox-7.1.x/virtualbox-kernel"
VBOX_PACKAGE_VERSION="7.1.6"
ARCH="x86_64"
REVISION="1"
KERNEL_VER=$(uname -r)
VBOX_PKG_FILE="/tmp/virtualbox-kernel-${VBOX_PACKAGE_VERSION}_${KERNEL_VER}-${ARCH}-${REVISION}.txz"

echo "Building local virtualbox kernel package..."
cd "$VBOX_BUILD_DIR" || { echo "Build directory not found: $VBOX_BUILD_DIR"; exit 1; }

# Run the SlackBuild script for virtualbox-kernel
bash virtualbox-kernel.SlackBuild

# Check if the package file was created and install it
if [[ -f "$VBOX_PKG_FILE" ]]; then
    echo "Installing local virtualbox kernel package..."
    upgradepkg --reinstall "$VBOX_PKG_FILE"
else
    echo "Package file not found: $VBOX_PKG_FILE"
    exit 1
fi
