#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status,
# Treat unset variables as an error, and catch errors in pipelines.
set -euo pipefail

# Ensure the script is run with root/sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "[-] ERROR: This script must be run with sudo or as root." >&2
    exit 1
fi

echo "================================================================"
echo " Starting Niri + Noctalia Shell Installation on Fedora 44"
echo "================================================================"

# 1. Bootstrap the Terra Repository safely
echo "[+] Adding the Terra repository (required for Noctalia Shell)..."
dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

# 2. Install Niri, Noctalia, and curated quality-of-life dependencies
echo "[+] Installing components strictly from validated repositories..."
dnf install -y \
    niri \
    niri-settings \
    xdg-desktop-portal \
    xwayland-satellite \
    wdisplays \
    wlr-randr \
    noctalia-shell \
    brightnessctl \
    imagemagick \
    python3 \
    alacritty \
    fuzzel

# 3. Copy config from usr and set auto-start for necessary services in niri configuration

NIRI_CONF="$USER_HOME/.config/niri/config.kdl"

cp /usr/share/doc/niri/default-config.kdl $NIRI_CONF

echo "spawn-at-startup \"qs\" \"-c\" \"noctalia-shell\"" >>  >> "$NIRI_CONF"
echo "spawn-at-startup \"gsettings\" \"set\" \"org.gnome.desktop.interface\" \"scaling-factor\" \"1\""  >> "$NIRI_CONF"
echo "spawn-at-startup \"gsettings\" \"set\" \"org.gnome.desktop.interface\" \"text-scaling-factor\" \"1\"" >> "$NIRI_CONF"
echo "spawn-at-startup \"wlr-randr\" \"--output\" \"eDP-1\" \"--scale\" \"1\"" >> "$NIRI_CONF"
echo "spawn-at-startup \"xdg-desktop-portal\"" >> "$NIRI_CONF"
echo "spawn-at-startup \"xwayland-satellite\"" >> "$NIRI_CONF"

echo "================================================================"
echo "  Installation Completed Successfully! "
echo "================================================================"
