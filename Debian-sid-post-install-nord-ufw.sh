#!/bin/bash

# Debian Unstable bspwm Complete Setup Script
# This script installs and configures bspwm, sxhkd, polybar, rofi and all system essentials

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root. Please run as a regular user with sudo privileges."
   exit 1
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    error "sudo is not installed. Please install sudo and add your user to the sudo group."
    exit 1
fi

log "Starting Debian Unstable bspwm setup..."

# Update system
log "Updating package lists and system..."
sudo apt update
sudo apt upgrade -y

# Install essential system packages
log "Installing essential system packages..."
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    dirmngr \
    build-essential \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    p7zip-full \
    rsync \
    tmux \
    screen \
    bash-completion \
    command-not-found \
    man-db \
    manpages-dev

# Install hardware support packages
log "Installing hardware support packages..."
sudo apt install -y \
    firmware-linux \
    firmware-linux-nonfree \
    firmware-misc-nonfree \
    firmware-realtek \
    firmware-atheros \
    firmware-brcm80211 \
    firmware-iwlwifi \
    intel-microcode \
    amd64-microcode \
    mesa-vulkan-drivers \
    vulkan-tools \
    vainfo \
    intel-media-va-driver \
    mesa-va-drivers \
    alsa-utils \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    acpi \
    acpi-support \
    laptop-mode-tools \
    thermald \
    cpufrequtils \
    powertop \
    tlp \
    tlp-rdw

# Install networking packages
log "Installing networking packages..."
sudo apt install -y \
    network-manager \
    network-manager-gnome \
    wpasupplicant \
    wireless-tools \
    rfkill \
    iw \
    iwd \
    dhcpcd5 \
    resolvconf \
    dnsutils \
    netcat-openbsd \
    nmap \
    traceroute \
    iptables \
    ufw \
    openssh-client \
    openssh-server

# Install Bluetooth support
log "Installing Bluetooth support..."
sudo apt install -y \
    bluetooth \
    bluez \
    bluez-tools \
    bluez-firmware \
    blueman \
    pulseaudio-module-bluetooth

# Install security packages
log "Installing security packages..."
sudo apt install -y \
    apparmor \
    apparmor-utils \
    apparmor-profiles \
    apparmor-profiles-extra \
    fail2ban \
    ufw \
    rkhunter \
    chkrootkit \
    clamav \
    clamav-daemon \
    lynis

# Install X11 and display manager
log "Installing X11 and display manager..."
sudo apt install -y \
    xorg \
    xserver-xorg \
    xinit \
    xauth \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings \
    xbacklight \
    redshift \
    redshift-gtk \
    compton \
    picom \
    feh \
    scrot \
    imagemagick \
    xclip \
    xsel \
    xdotool \
    wmctrl \
    arandr \
    lxrandr

# Install bspwm and sxhkd
log "Installing bspwm and sxhkd..."
sudo apt install -y \
    bspwm \
    sxhkd

# Install polybar dependencies and build tools
log "Installing polybar dependencies..."
sudo apt install -y \
    cmake \
    cmake-data \
    pkg-config \
    python3-sphinx \
    libcairo2-dev \
    libxcb1-dev \
    libxcb-util0-dev \
    libxcb-randr0-dev \
    libxcb-composite0-dev \
    python3-xcbgen \
    xcb-proto \
    libxcb-image0-dev \
    libxcb-ewmh-dev \
    libxcb-icccm4-dev \
    libxcb-xkb-dev \
    libxcb-xrm-dev \
    libxcb-cursor-dev \
    libasound2-dev \
    libpulse-dev \
    libjsoncpp-dev \
    libmpdclient-dev \
    libcurl4-openssl-dev \
    libnl-genl-3-dev

# Try to install polybar from repositories first
log "Attempting to install polybar from repositories..."
if sudo apt install -y polybar; then
    log "Polybar installed from repositories successfully"
else
    warn "Polybar not available in repositories, will build from source later"
fi

# Install rofi
log "Installing rofi..."
sudo apt install -y \
    rofi \
    rofi-dev

# Install fonts
log "Installing fonts..."
sudo apt install -y \
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    fonts-liberation \
    fonts-liberation2 \
    fonts-noto \
    fonts-noto-color-emoji \
    fonts-roboto \
    fonts-font-awesome \
    fonts-powerline \
    fonts-hack \
    fonts-firacode

# Install terminal emulators
log "Installing terminal emulators..."
sudo apt install -y \
    alacritty \
    kitty \
    rxvt-unicode \
    terminator

# Install file managers and system tools
log "Installing file managers and system tools..."
sudo apt install -y \
    thunar \
    thunar-volman \
    thunar-archive-plugin \
    thunar-media-tags-plugin \
    pcmanfm \
    ranger \
    mc \
    gvfs \
    gvfs-backends \
    udisks2 \
    udiskie \
    ntfs-3g \
    exfat-fuse \
    dosfstools \
    mtools

# Install media and graphics tools
log "Installing media and graphics tools..."
sudo apt install -y \
    mpv \
    vlc \
    gimp \
    inkscape \
    firefox-esr \
    chromium \
    libreoffice \
    evince \
    eog \
    shotwell \
    audacity \
    obs-studio

# Install development tools
log "Installing development tools..."
sudo apt install -y \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip \
    python3-venv \
    gcc \
    g++ \
    make \
    cmake \
    gdb \
    valgrind \
    strace \
    ltrace

# Install notification daemon
log "Installing notification daemon..."
sudo apt install -y \
    dunst \
    libnotify-bin

# Install system monitoring tools
log "Installing system monitoring tools..."
sudo apt install -y \
    htop \
    iotop \
    nethogs \
    iftop \
    atop \
    glances \
    neofetch \
    lm-sensors \
    hddtemp \
    smartmontools

# Configure services
log "Configuring system services..."

# Enable and start NetworkManager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# Enable and start Bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Enable and start SSH (but don't start it automatically for security)
sudo systemctl enable ssh

# Enable and start LightDM
sudo systemctl enable lightdm

# Enable and start AppArmor
sudo systemctl enable apparmor
sudo systemctl start apparmor

# Enable and start fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Enable and start UFW firewall
sudo ufw --force enable
sudo systemctl enable ufw

# Configure fail2ban
log "Configuring fail2ban..."
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Create basic fail2ban configuration
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
EOF

# Configure UFW firewall
log "Configuring UFW firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh

# Create user directories
log "Creating user directories..."
mkdir -p ~/.config/{bspwm,sxhkd,polybar,rofi,alacritty,dunst}
mkdir -p ~/.local/share/applications
mkdir -p ~/Pictures/Screenshots
mkdir -p ~/Documents
mkdir -p ~/Downloads

# Create bspwm configuration
log "Creating bspwm configuration..."
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/bash

# bspwm configuration

# Monitor setup
bspc monitor -d I II III IV V VI VII VIII IX X

# Window settings
bspc config border_width         2
bspc config window_gap          12
bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true
bspc config focus_follows_pointer true
bspc config pointer_follows_focus true

# Colors - Nord Polar Night
bspc config normal_border_color "#3b4252"
bspc config active_border_color "#81a1c1"
bspc config focused_border_color "#88c0d0"
bspc config presel_feedback_color "#4c566a"

# Rules
bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a Firefox desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

# Autostart
~/.config/bspwm/autostart &
EOF

chmod +x ~/.config/bspwm/bspwmrc

# Create bspwm autostart script
cat > ~/.config/bspwm/autostart << 'EOF'
#!/bin/bash

# Kill existing processes
killall -q polybar
killall -q sxhkd
killall -q picom
killall -q dunst

# Wait for processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
while pgrep -u $UID -x sxhkd >/dev/null; do sleep 1; done

# Start hotkey daemon
sxhkd &

# Start compositor
picom &

# Start notification daemon
dunst &

# Start polybar
polybar main &

# Set wallpaper
feh --bg-scale ~/.config/bspwm/wallpaper.jpg 2>/dev/null || feh --bg-fill /usr/share/pixmaps/debian-logo.png &

# Start system tray applications
nm-applet &
blueman-applet &
udiskie -t &
EOF

chmod +x ~/.config/bspwm/autostart

# Create sxhkd configuration
log "Creating sxhkd configuration..."
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
# Terminal emulator
super + Return
    alacritty

# Program launcher
super + d
    rofi -show drun

# Window switcher
super + Tab
    rofi -show window

# Make sxhkd reload its configuration files
super + Escape
    pkill -USR1 -x sxhkd

# Quit/restart bspwm
super + alt + {q,r}
    bspc {quit,wm -r}

# Close and kill
super + {_,shift + }w
    bspc node -{c,k}

# Alternate between the tiled and monocle layout
super + m
    bspc desktop -l next

# Send the newest marked node to the newest preselected node
super + y
    bspc node newest.marked.local -n newest.!automatic.local

# Swap the current node and the biggest window
super + g
    bspc node -s biggest.window

# Set the window state
super + {t,shift + t,s,f}
    bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# Set the node flags
super + ctrl + {m,x,y,z}
    bspc node -g {marked,locked,sticky,private}

# Focus the node in the given direction
super + {_,shift + }{h,j,k,l}
    bspc node -{f,s} {west,south,north,east}

# Focus the node for the given path jump
super + {p,b,comma,period}
    bspc node -f @{parent,brother,first,second}

# Focus the next/previous window in the current desktop
super + {_,shift + }c
    bspc node -f {next,prev}.local.!hidden.window

# Focus the next/previous desktop in the current monitor
super + bracket{left,right}
    bspc desktop -f {prev,next}.local

# Focus the last node/desktop
super + {grave,Tab}
    bspc {node,desktop} -f last

# Focus the older or newer node in the focus history
super + {o,i}
    bspc wm -h off; \
    bspc node {older,newer} -f; \
    bspc wm -h on

# Focus or send to the given desktop
super + {_,shift + }{1-9,0}
    bspc {desktop -f,node -d} '^{1-9,10}'

# Preselect the direction
super + ctrl + {h,j,k,l}
    bspc node -p {west,south,north,east}

# Preselect the ratio
super + ctrl + {1-9}
    bspc node -o 0.{1-9}

# Cancel the preselection for the focused node
super + ctrl + space
    bspc node -p cancel

# Cancel the preselection for the focused desktop
super + ctrl + shift + space
    bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

# Expand a window by moving one of its side outward
super + alt + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# Contract a window by moving one of its side inward
super + alt + shift + {h,j,k,l}
    bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# Move a floating window
super + {Left,Down,Up,Right}
    bspc node -v {-20 0,0 20,0 -20,20 0}

# Volume control
XF86AudioRaiseVolume
    pactl set-sink-volume @DEFAULT_SINK@ +5%

XF86AudioLowerVolume
    pactl set-sink-volume @DEFAULT_SINK@ -5%

XF86AudioMute
    pactl set-sink-mute @DEFAULT_SINK@ toggle

# Brightness control
XF86MonBrightnessUp
    xbacklight -inc 10

XF86MonBrightnessDown
    xbacklight -dec 10

# Screenshot
Print
    scrot ~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png

super + Print
    scrot -s ~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png

# File manager
super + e
    thunar

# Browser
super + shift + Return
    firefox
EOF

# Create basic polybar configuration
log "Creating polybar configuration..."
cat > ~/.config/polybar/config.ini << 'EOF'
[colors]
; Nord Polar Night palette
background = #2e3440
background-alt = #3b4252
foreground = #eceff4
primary = #88c0d0
secondary = #a3be8c
alert = #bf616a
disabled = #4c566a
frost1 = #8fbcbb
frost2 = #88c0d0
frost3 = #81a1c1
frost4 = #5e81ac

[bar/main]
width = 100%
height = 24pt
radius = 0

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3pt

border-size = 0pt
border-color = #00000000

padding-left = 0
padding-right = 1

module-margin = 1

separator = |
separator-foreground = ${colors.disabled}

font-0 = monospace;2

modules-left = bspwm xwindow
modules-right = filesystem pulseaudio memory cpu wlan eth date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

[module/bspwm]
type = internal/bspwm

label-focused = %index%
label-focused-background = ${colors.background-alt}
label-focused-underline= ${colors.primary}
label-focused-padding = 1

label-occupied = %index%
label-occupied-padding = 1

label-urgent = %index%!
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

label-empty = %index%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

label-mounted = %{F#a3be8c}%mountpoint%%{F-} %percentage_used%%

label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio

format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>

label-volume = %percentage%%

label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[module/wlan]
type = internal/network
interface-type = wireless
interval = 5.0

format-connected = <ramp-signal> <label-connected>
label-connected = %essid% %local_ip%

format-disconnected = <label-disconnected>
label-disconnected = %ifname% disconnected
label-disconnected-foreground = ${colors.disabled}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-5 = 
ramp-signal-foreground = ${colors.primary}

[module/eth]
type = internal/network
interface-type = wired
interval = 5.0

format-connected-prefix = "ETH "
format-connected-prefix-foreground = ${colors.primary}
label-connected = %local_ip%

format-disconnected = <label-disconnected>
label-disconnected = %ifname% disconnected
label-disconnected-foreground = ${colors.disabled}

[module/date]
type = internal/date
interval = 1

date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S

label = %date%
label-foreground = ${colors.primary}

[settings]
screenchange-reload = true
pseudo-transparency = true
EOF

# Create rofi configuration
log "Creating rofi configuration..."
mkdir -p ~/.config/rofi
cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "window,run,ssh,drun";
    font: "hack 10";
    show-icons: true;
    terminal: "alacritty";
    drun-display-format: "{icon} {name}";
    location: 0;
    disable-history: false;
    hide-scrollbar: true;
    display-drun: "   Apps ";
    display-run: "   Run ";
    display-window: " 﩯  Window";
    display-Network: " 󰤨  Network";
    sidebar-mode: true;
}

@theme "nord"
EOF

# Create alacritty configuration
log "Creating alacritty configuration..."
cat > ~/.config/alacritty/alacritty.yml << 'EOF'
window:
  padding:
    x: 10
    y: 10
  dynamic_padding: false
  decorations: full
  startup_mode: Windowed

scrolling:
  history: 5000
  multiplier: 3

font:
  normal:
    family: "Hack"
    style: Regular
  bold:
    family: "Hack"
    style: Bold
  italic:
    family: "Hack"
    style: Italic
  size: 11.0

# Nord Polar Night color scheme
colors:
  primary:
    background: '#2e3440'
    foreground: '#eceff4'
    dim_foreground: '#a5aaad'
  cursor:
    text: '#2e3440'
    cursor: '#eceff4'
  vi_mode_cursor:
    text: '#2e3440'
    cursor: '#eceff4'
  selection:
    text: CellForeground
    background: '#4c566a'
  search:
    matches:
      foreground: '#2e3440'
      background: '#88c0d0'
    focused_match:
      foreground: '#2e3440'
      background: '#a3be8c'
    bar:
      background: '#434c5e'
      foreground: '#eceff4'
  normal:
    black: '#3b4252'
    red: '#bf616a'
    green: '#a3be8c'
    yellow: '#ebcb8b'
    blue: '#81a1c1'
    magenta: '#b48ead'
    cyan: '#88c0d0'
    white: '#e5e9f0'
  bright:
    black: '#4c566a'
    red: '#bf616a'
    green: '#a3be8c'
    yellow: '#ebcb8b'
    blue: '#81a1c1'
    magenta: '#b48ead'
    cyan: '#8fbcbb'
    white: '#eceff4'
  dim:
    black: '#373e4d'
    red: '#94545d'
    green: '#809575'
    yellow: '#b29e75'
    blue: '#68809a'
    magenta: '#8c738c'
    cyan: '#6d96a5'
    white: '#aeb3bb'

cursor:
  style: Block
  unfocused_hollow: true

mouse:
  hide_when_typing: false

selection:
  semantic_escape_chars: ",│`|:\"' ()[]{}<>"
  save_to_clipboard: false

shell:
  program: /bin/bash
EOF

# Create dunst configuration
log "Creating dunst configuration..."
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    monitor = 0
    follow = keyboard
    geometry = "300x5-30+20"
    indicate_hidden = yes
    shrink = no
    transparency = 0
    notification_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    frame_width = 3
    frame_color = "#4c566a"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    font = Hack 10
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = left
    max_icon_size = 32
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/firefox
    always_run_script = true
    title = Dunst
    class = Dunst
    startup_notification = false
    verbosity = mesg
    corner_radius = 0
    mouse_left_click = close_current
    mouse_middle_click = do_action
    mouse_right_click = close_all

[experimental]
    per_monitor_dpi = false

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "#2e3440"
    foreground = "#eceff4"
    frame_color = "#3b4252"
    timeout = 10

[urgency_normal]
    background = "#2e3440"
    foreground = "#eceff4"
    frame_color = "#4c566a"
    timeout = 10

[urgency_critical]
    background = "#bf616a"
    foreground = "#eceff4"
    frame_color = "#bf616a"
    timeout = 0
EOF

# Build polybar from source if not installed
if ! command -v polybar &> /dev/null; then
    log "Building polybar from source..."
    cd /tmp
    git clone --recursive https://github.com/polybar/polybar
    cd polybar
    mkdir build
    cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    cd ~
fi

# Create .xinitrc
log "Creating .xinitrc..."
cat > ~/.xinitrc << 'EOF'
#!/bin/bash

# Load X resources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Set keyboard layout
setxkbmap us

# Start window manager
exec bspwm
EOF

chmod +x ~/.xinitrc

# Create .Xresources
cat > ~/.Xresources << 'EOF'
! URxvt settings - Nord Polar Night theme
URxvt.font: xft:Hack:size=11
URxvt.background: #2e3440
URxvt.foreground: #eceff4
URxvt.scrollBar: false
URxvt.cursorBlink: true

! Nord colors for URxvt
URxvt.color0: #3b4252
URxvt.color1: #bf616a
URxvt.color2: #a3be8c
URxvt.color3: #ebcb8b
URxvt.color4: #81a1c1
URxvt.color5: #b48ead
URxvt.color6: #88c0d0
URxvt.color7: #e5e9f0
URxvt.color8: #4c566a
URxvt.color9: #bf616a
URxvt.color10: #a3be8c
URxvt.color11: #ebcb8b
URxvt.color12: #81a1c1
URxvt.color13: #b48ead
URxvt.color14: #8fbcbb
URxvt.color15: #eceff4

! Rofi settings
rofi.theme: nord
EOF

# Set up systemd user services
log "Setting up systemd user services..."
mkdir -p ~/.config/systemd/user

# Enable user lingering to allow user services to run without login
sudo loginctl enable-linger $USER

# Final system update
log "Performing final system update..."
sudo apt update && sudo apt upgrade -y

# Clean up
log "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

# Create a simple post-install script
log "Creating post-install script..."
cat > ~/post-install.sh << 'EOF'
#!/bin/bash

echo "Post-installation tasks:"
echo "1. Reboot your system"
echo "2. Log in through LightDM"
echo "3. Select bspwm as your session"
echo "4. Configure your WiFi using nm-applet"
echo "5. Install additional applications as needed"
echo ""
echo "Key bindings:"
echo "Super + Return: Terminal"
echo "Super + d: Application launcher"
echo "Super + w: Close window"
echo "Super + f: Toggle fullscreen"
echo "Super + 1-9: Switch desktops"
echo "Super + Shift + 1-9: Move window to desktop"
echo ""
echo "Configuration files are in ~/.config/"
echo "Edit them to customize your setup!"
EOF

chmod +x ~/post-install.sh

log "Installation completed successfully!"
log "Please run ~/post-install.sh for final instructions"
warn "It is recommended to reboot your system now"

# Optional: Ask if user wants to reboot
read -p "Would you like to reboot now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo reboot
fi
