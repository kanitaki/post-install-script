#!/bin/bash

################################################################################
# Cinnamon Desktop + Linux Mint Themes Installation Script for Arch Linux
# This script installs Cinnamon desktop environment with all required
# dependencies and pulls official Linux Mint themes from GitHub
#***Created with the assistance of Claude AI***
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root. Run as normal user with sudo privileges."
   exit 1
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    log_error "sudo is required but not installed. Please install sudo first."
    exit 1
fi

log_info "Starting Cinnamon Desktop Environment installation for Arch Linux"
echo "================================================================"

# Update system
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install Xorg display server and related packages
log_info "Installing Xorg display server..."
XORG_PACKAGES=(
    xorg-server
    xorg-xinit
    xorg-apps
    xorg-xrandr
    xorg-xsetroot
    xf86-input-libinput
)
sudo pacman -S --needed --noconfirm "${XORG_PACKAGES[@]}"
log_success "Xorg installed"

# Install Cinnamon desktop and core components
log_info "Installing Cinnamon desktop environment..."
CINNAMON_PACKAGES=(
    cinnamon                    # Main desktop environment
    cinnamon-translations       # Translation files
    nemo                        # File manager
    nemo-fileroller            # Archive support for Nemo
    nemo-preview               # File preview support
    nemo-share                 # File sharing support
)
sudo pacman -S --needed --noconfirm "${CINNAMON_PACKAGES[@]}"
log_success "Cinnamon desktop installed"

# Install display manager (LightDM recommended for Cinnamon)
log_info "Installing LightDM display manager..."
DISPLAY_MANAGER_PACKAGES=(
    lightdm
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings
)
sudo pacman -S --needed --noconfirm "${DISPLAY_MANAGER_PACKAGES[@]}"
log_success "LightDM installed"

# Enable LightDM service
log_info "Enabling LightDM service..."
sudo systemctl enable lightdm.service
log_success "LightDM service enabled"

# Install essential system utilities
log_info "Installing essential system utilities..."
SYSTEM_UTILITIES=(
    gnome-terminal             # Terminal emulator
    gnome-system-monitor       # System monitor
    gnome-screenshot           # Screenshot utility
    gnome-calculator           # Calculator
    gnome-disk-utility         # Disk management
    file-roller                # Archive manager
    evince                     # PDF viewer
    eog                        # Image viewer
    gedit                      # Text editor
)
sudo pacman -S --needed --noconfirm "${SYSTEM_UTILITIES[@]}"
log_success "System utilities installed"

# Install audio support
log_info "Installing audio support..."
AUDIO_PACKAGES=(
    pulseaudio
    pulseaudio-alsa
    pavucontrol
    alsa-utils
)
sudo pacman -S --needed --noconfirm "${AUDIO_PACKAGES[@]}"
log_success "Audio support installed"

# Install network management
log_info "Installing NetworkManager..."
sudo pacman -S --needed --noconfirm networkmanager network-manager-applet
sudo systemctl enable NetworkManager.service
log_success "NetworkManager installed and enabled"

# Install Bluetooth support
log_info "Installing Bluetooth support..."
BLUETOOTH_PACKAGES=(
    bluez
    bluez-utils
    blueberry
)
sudo pacman -S --needed --noconfirm "${BLUETOOTH_PACKAGES[@]}"
sudo systemctl enable bluetooth.service
log_success "Bluetooth support installed"

# Install printer support
log_info "Installing printer support..."
PRINTER_PACKAGES=(
    cups
    system-config-printer
)
sudo pacman -S --needed --noconfirm "${PRINTER_PACKAGES[@]}"
sudo systemctl enable cups.service
log_success "Printer support installed"

# Install fonts
log_info "Installing fonts..."
FONT_PACKAGES=(
    ttf-dejavu
    ttf-liberation
    ttf-droid
    noto-fonts
    noto-fonts-emoji
)
sudo pacman -S --needed --noconfirm "${FONT_PACKAGES[@]}"
log_success "Fonts installed"

# Install Git for cloning themes
log_info "Installing Git..."
sudo pacman -S --needed --noconfirm git
log_success "Git installed"

# Create themes and icons directories
log_info "Creating themes and icons directories..."
THEMES_DIR="$HOME/.themes"
ICONS_DIR="$HOME/.icons"
mkdir -p "$THEMES_DIR"
mkdir -p "$ICONS_DIR"
log_success "Directories created"

# Clone and install Linux Mint themes
log_info "Cloning Linux Mint themes from official GitHub..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

log_info "Downloading mint-themes..."
if git clone https://github.com/linuxmint/mint-themes.git; then
    cd mint-themes
    
    # Check if generate-themes.py exists
    if [ -f "generate-themes.py" ]; then
        log_info "Generating Mint themes..."
        python generate-themes.py
        
        # Copy generated themes
        if [ -d "usr/share/themes" ]; then
            log_info "Installing Mint-Y and Mint-X themes..."
            cp -r usr/share/themes/* "$THEMES_DIR/"
            log_success "Mint themes installed to $THEMES_DIR"
        fi
    else
        # If generation script doesn't exist, copy directly
        log_info "Copying pre-built themes..."
        if [ -d "usr/share/themes" ]; then
            cp -r usr/share/themes/* "$THEMES_DIR/"
            log_success "Mint themes installed to $THEMES_DIR"
        else
            log_warning "Theme directory structure not found in repository"
        fi
    fi
    
    cd "$TEMP_DIR"
else
    log_error "Failed to clone mint-themes repository"
fi

# Clone and install Linux Mint icons
log_info "Cloning Linux Mint Mint-Y icons from official GitHub..."
if git clone https://github.com/linuxmint/mint-y-icons.git; then
    cd mint-y-icons
    
    # Copy icon themes
    if [ -d "usr/share/icons" ]; then
        log_info "Installing Mint-Y icon themes..."
        cp -r usr/share/icons/* "$ICONS_DIR/"
        log_success "Mint-Y icons installed to $ICONS_DIR"
    else
        log_warning "Icons directory structure not found in repository"
    fi
    
    cd "$TEMP_DIR"
else
    log_error "Failed to clone mint-y-icons repository"
fi

# Clone and install Mint-X icons
log_info "Cloning Linux Mint Mint-X icons from official GitHub..."
if git clone https://github.com/linuxmint/mint-x-icons.git; then
    cd mint-x-icons
    
    # Copy icon themes
    if [ -d "usr/share/icons" ]; then
        log_info "Installing Mint-X icon themes..."
        cp -r usr/share/icons/* "$ICONS_DIR/"
        log_success "Mint-X icons installed to $ICONS_DIR"
    else
        log_warning "Icons directory structure not found in repository"
    fi
else
    log_error "Failed to clone mint-x-icons repository"
fi

# Update icon cache
log_info "Updating icon cache..."
for icon_dir in "$ICONS_DIR"/*; do
    if [ -d "$icon_dir" ]; then
        gtk-update-icon-cache -f "$icon_dir" 2>/dev/null || true
    fi
done
log_success "Icon cache updated"

# Clean up temp directory
log_info "Cleaning up temporary files..."
cd "$HOME"
rm -rf "$TEMP_DIR"
log_success "Cleanup complete"

# Add user to necessary groups
log_info "Adding user to required groups..."
GROUPS=(rfkill)
for group in "${GROUPS[@]}"; do
    if getent group "$group" > /dev/null 2>&1; then
        sudo usermod -aG "$group" "$USER"
        log_info "Added $USER to $group group"
    fi
done

# Display installation summary
echo ""
echo "================================================================"
log_success "Cinnamon Desktop Environment installation complete!"
echo "================================================================"
echo ""
log_info "Installation Summary:"
echo "  ✓ Cinnamon Desktop Environment"
echo "  ✓ LightDM Display Manager"
echo "  ✓ Linux Mint Themes (Mint-Y, Mint-X)"
echo "  ✓ Linux Mint Icons (Mint-Y, Mint-X)"
echo "  ✓ System Utilities and Applications"
echo "  ✓ Audio Support (PulseAudio)"
echo "  ✓ Network Management (NetworkManager)"
echo "  ✓ Bluetooth Support"
echo "  ✓ Printer Support (CUPS)"
echo ""
log_info "Themes installed to: $THEMES_DIR"
log_info "Icons installed to: $ICONS_DIR"
echo ""
log_warning "IMPORTANT: Please reboot your system to start using Cinnamon"
echo ""
log_info "After reboot:"
echo "  1. Select 'Cinnamon' session at login screen"
echo "  2. Open Themes settings to apply Mint themes:"
echo "     Menu > Preferences > Themes"
echo "  3. Select desired Mint-Y or Mint-X variations"
echo ""
log_info "Optional: Install additional applications using:"
echo "  sudo pacman -S firefox vlc gimp libreoffice-fresh"
echo ""
read -p "Would you like to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Rebooting system..."
    sudo reboot
else
    log_info "Please reboot manually when ready"
fi
