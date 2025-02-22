#!/bin/bash
set -e

# Define color codes
GREEN='\033[1;32m'
NC='\033[0m'  # No color (reset)

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${GREEN}run as root${NC}"
    exit 1
fi

#############################
# Update the Package Database
#############################

echo -e "${GREEN}Updating the package database...${NC}"
sbopkg -r

#############################
# Rebuild SBo Packages
#############################

sbopkg_packages=(
    "osinfo-db-tools"
    "osinfo-db"
    "libosinfo"
    "yajl"
    "numactl"
    "libvirt"
    "libvirt-glib"
    "libvirt-python"
    "gtk-vnc"
    "spice-protocol"
    "spice"
    "usbredir"
    "spice-gtk"
    "device-tree-compiler"
    "libnfs"
    "snappy"
    "vde2"
    "virglrenderer"
    "libslirp"
    "qemu"
    "virt-manager"
    "python3-PyQtWebEngine"
    "python-colour"
    "colorama"
    "openrazer-kernel"
    "python-daemonize"
    "python3-pyproject-metadata"
    "python3-mesonpy"
    "python3-numpy"
    "python3-pyudev"
    "setproctitle"
    "openrazer-daemon"
    "polychromatic"
    "snes9x"
    "libminizip"
    "fceux"
    "qt5ct"
    "qt5-styleplugins"
    "qt6ct"
    "qt6gtk2"
    "rss-glx"
    "nvtop"
    "ufw"
    "unetbootin"
    "iperf3"
    "FontAwesome"
    "x264"
    "x265"
    "HandBrake"
    "aria2"
    "bitwarden-desktop"
    "JetBrainsMono"
    "lua"
    "imlib2"
    "libxnvctrl"
    "libzen"
    "tinyxml2"
    "libmediainfo"
    "mediainfo"
    "gsoap"
    "acpica"
    "stress-ng"
    "unrar"
    "vscode-bin"
    "sbo-create"
    "sbo-maintainer-tools"
    "mupen64plus"
    "mupen64plus-video-gliden64"
    "m64py"
    "dosbox-x"
    "eawpats"
    "TiMidity++"
    "gst-plugins-bad-nonfree"
    "gst-plugins-ugly"
    "libdvdcss"
    "libfdk-aac"
    "svt-av1"
    "kvazaar"
    "rav1e"
    "libde265"
    "libheif"
    "p7zip"
    "feh"
    "ttf-dark-courier"
    "ttf-roboto"
    "RenameMyTVSeries"
    "yt-dlp"
    "faac"
    "faad2"
    "btop"
    "alacritty"
    "unigine-heaven-benchmark"
    "unigine-superposition-benchmark"
    "unigine-valley-benchmark"
    "fusion-icon"
    "cmatrix"
    "gsmartcontrol"
)

for pkg in "${sbopkg_packages[@]}"; do
    echo -e "${GREEN}Building $pkg...${NC}"
    sbopkg -e ask -i "$pkg" -B
done

