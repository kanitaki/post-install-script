#!/bin/bash

# Debian Trixie BSPWM Desktop Environment Setup Script
# Sets up bspwm, sxhkd, polybar, rofi, nitrogen with Nord Polar Night theme

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Nord Polar Night Colors
NORD0="#2e3440"
NORD1="#3b4252"
NORD2="#434c5e"
NORD3="#4c566a"

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
   log_error "This script should not be run as root. Please run as a regular user."
   exit 1
fi

# Update system
log_info "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
log_info "Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install window manager and related packages
log_info "Installing bspwm, sxhkd, and related packages..."
sudo apt install -y \
    bspwm \
    sxhkd \
    polybar \
    rofi \
    nitrogen \
    picom \
    dunst \
    xorg \
    xinit \
    xserver-xorg \
    lightdm \
    lightdm-gtk-greeter \
    lightdm-gtk-greeter-settings

# Install fonts
log_info "Installing fonts..."
sudo apt install -y \
    fonts-font-awesome \
    fonts-noto \
    fonts-noto-color-emoji \
    fonts-hack \
    fonts-firacode

# Install networking and system utilities
log_info "Installing networking and system utilities..."
sudo apt install -y \
    network-manager \
    network-manager-gnome \
    bluez \
    bluez-tools \
    bluetooth \
    pulseaudio \
    pulseaudio-utils \
    pavucontrol \
    alsa-utils \
    apparmor \
    apparmor-profiles \
    apparmor-utils \
    systemd

# Install Brave browser
log_info "Installing Brave browser..."
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Install additional utilities
log_info "Installing additional utilities..."
sudo apt install -y \
    thunar \
    thunar-volman \
    thunar-archive-plugin \
    file-roller \
    gvfs \
    gvfs-backends \
    udisks2 \
    xfce4-terminal \
    scrot \
    feh \
    htop \
    neofetch \
    tree \
    unzip \
    zip \
    p7zip-full

# Create config directories
log_info "Creating configuration directories..."
mkdir -p ~/.config/{bspwm,sxhkd,polybar,rofi,dunst,picom}

# Create bspwm config
log_info "Creating bspwm configuration..."
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh

# Nord Polar Night Colors
export NORD0="#2e3440"
export NORD1="#3b4252"
export NORD2="#434c5e"
export NORD3="#4c566a"

# Monitor setup
bspc monitor -d 1 2 3 4 5 6 7 8 9 10

# Window settings
bspc config border_width         2
bspc config window_gap          12
bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

# Colors
bspc config normal_border_color   "$NORD1"
bspc config active_border_color   "$NORD2"
bspc config focused_border_color  "$NORD3"
bspc config presel_feedback_color "$NORD2"

# Mouse settings
bspc config pointer_modifier mod4
bspc config pointer_action1 move
bspc config pointer_action2 resize_side
bspc config pointer_action3 resize_corner

# Rules
bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Chromium desktop='^2'
bspc rule -a Brave-browser desktop='^2'
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off

# Autostart
~/.config/bspwm/autostart.sh &
EOF

# Create bspwm autostart script
cat > ~/.config/bspwm/autostart.sh << 'EOF'
#!/bin/bash

# Kill existing processes
killall -q polybar sxhkd picom dunst nitrogen

# Wait for processes to shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
while pgrep -u $UID -x sxhkd > /dev/null; do sleep 1; done
while pgrep -u $UID -x picom > /dev/null; do sleep 1; done
while pgrep -u $UID -x dunst > /dev/null; do sleep 1; done

# Start components
sxhkd &
polybar main &
picom &
dunst &
nitrogen --restore &

# Set cursor
xsetroot -cursor_name left_ptr

# Start NetworkManager applet
nm-applet &
EOF

# Make scripts executable
chmod +x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/bspwm/autostart.sh

# Create sxhkd config
log_info "Creating sxhkd configuration..."
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
# Terminal emulator
super + Return
    xfce4-terminal

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

# Expand a window by moving one of its sides outward
super + alt + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# Contract a window by moving one of its sides inward
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

# Brightness control (if available)
XF86MonBrightnessUp
    xbacklight -inc 10

XF86MonBrightnessDown
    xbacklight -dec 10

# Screenshot
Print
    scrot ~/Pictures/screenshot_%Y%m%d_%H%M%S.png

# File manager
super + e
    thunar

# Browser
super + shift + f
    brave-browser
EOF

# Create polybar config
log_info "Creating polybar configuration..."
cat > ~/.config/polybar/config.ini << 'EOF'
;==========================================================
;
;   Polybar Configuration - Nord Polar Night Theme
;
;==========================================================

[colors]
; Nord Polar Night
background = #2e3440
background-alt = #3b4252
foreground = #d8dee9
primary = #5e81ac
secondary = #81a1c1
alert = #bf616a
disabled = #4c566a

[bar/main]
width = 100%
height = 30pt
radius = 0

; dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3pt

border-size = 0pt
border-color = #00000000

padding-left = 1
padding-right = 1

module-margin = 1

separator = |
separator-foreground = ${colors.disabled}

font-0 = Hack Nerd Font:size=10;2
font-1 = Font Awesome 6 Free:style=Solid:size=10;2
font-2 = Font Awesome 6 Brands:size=10;2

modules-left = bspwm xwindow
modules-center = date
modules-right = pulseaudio memory cpu wlan battery

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
interval = 3.0

format-connected = <ramp-signal> <label-connected>
label-connected = %essid% %local_ip%

format-disconnected = <label-disconnected>
label-disconnected = disconnected
label-disconnected-foreground = ${colors.disabled}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-foreground = ${colors.primary}

[module/battery]
type = internal/battery
battery = BAT0
adapter = ADP1
full-at = 98

format-charging = <animation-charging> <label-charging>
label-charging = %percentage%%

format-discharging = <ramp-capacity> <label-discharging>
label-discharging = %percentage%%

format-full-prefix = " "
format-full-prefix-foreground = ${colors.primary}

ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 
ramp-capacity-foreground = ${colors.primary}

animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
animation-charging-foreground = ${colors.primary}
animation-charging-framerate = 750

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

# Create rofi config
log_info "Creating rofi configuration..."
mkdir -p ~/.config/rofi
cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "window,run,ssh,drun";
    font: "Hack 12";
    show-icons: true;
    icon-theme: "Papirus";
    display-drun: "";
    display-run: "";
    display-window: "";
    drun-display-format: "{name}";
    disable-history: false;
    fullscreen: false;
    hide-scrollbar: true;
    sidebar-mode: false;
}

@theme "/dev/null"

* {
    bg: #2e3440;
    bg-alt: #3b4252;
    fg: #d8dee9;
    fg-alt: #4c566a;
    
    border: 0;
    margin: 0;
    padding: 0;
    spacing: 0;
}

window {
    width: 30%;
    background-color: @bg;
    border: 1px;
    border-color: @bg-alt;
    border-radius: 8px;
}

element {
    padding: 8 12;
    background-color: transparent;
    text-color: @fg;
}

element selected {
    text-color: @fg;
    background-color: @bg-alt;
}

element-text {
    background-color: transparent;
    text-color: inherit;
    vertical-align: 0.5;
}

element-icon {
    size: 18;
    padding: 0 8 0 0;
    background-color: transparent;
}

entry {
    padding: 12;
    background-color: @bg-alt;
    text-color: @fg;
}

inputbar {
    children: [prompt, entry];
    background-color: @bg;
}

listview {
    background-color: @bg;
    columns: 1;
    lines: 8;
}

mainbox {
    children: [inputbar, listview];
    background-color: @bg;
}

prompt {
    enabled: true;
    padding: 12 0 0 12;
    background-color: @bg-alt;
    text-color: @fg;
}
EOF

# Create picom config
log_info "Creating picom configuration..."
cat > ~/.config/picom/picom.conf << 'EOF'
# Backend
backend = "glx";
glx-no-stencil = true;
glx-copy-from-front = false;

# Opacity
active-opacity = 1.0;
inactive-opacity = 0.95;
frame-opacity = 1.0;
inactive-opacity-override = false;

# Fade
fading = true;
fade-delta = 4;
fade-in-step = 0.03;
fade-out-step = 0.03;
fade-exclude = [];

# Shadow
shadow = true;
shadow-radius = 12;
shadow-offset-x = -7;
shadow-offset-y = -7;
shadow-opacity = 0.6;
shadow-exclude = [
    "class_g ?= 'Notify-osd'",
    "class_g = 'Cairo-clock'",
    "_GTK_FRAME_EXTENTS@:c"
];

# Blur
blur-background = true;
blur-background-frame = true;
blur-method = "dual_kawase";
blur-strength = 3;
blur-background-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'",
    "_GTK_FRAME_EXTENTS@:c"
];

# Other
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
refresh-rate = 0;
vsync = true;
dbe = false;
unredir-if-possible = true;
focus-exclude = [ "class_g = 'Cairo-clock'" ];
detect-transient = true;
detect-client-leader = true;
invert-color-include = [ ];

# GLX backend
glx-no-rebind-pixmap = true;

# Window type settings
wintypes:
{
    tooltip = { fade = true; shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
    dock = { shadow = false; };
    dnd = { shadow = false; };
    popup_menu = { opacity = 0.9; };
    dropdown_menu = { opacity = 0.9; };
};
EOF

# Create dunst config
log_info "Creating dunst configuration..."
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    monitor = 0
    follow = none
    width = 300
    height = 300
    origin = top-right
    offset = 10x50
    scale = 0
    notification_limit = 0

    progress_bar = true
    progress_bar_height = 10
    progress_bar_frame_width = 1
    progress_bar_min_width = 150
    progress_bar_max_width = 300

    indicate_hidden = yes
    transparency = 0
    notification_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    text_icon_padding = 0
    frame_width = 2
    frame_color = "#3b4252"
    separator_color = frame
    sort = yes
    idle_threshold = 120

    font = Hack 10
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes

    icon_position = left
    min_icon_size = 0
    max_icon_size = 32
    icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

    sticky_history = yes
    history_length = 20
    dmenu = /usr/bin/rofi -dmenu -p dunst:
    browser = /usr/bin/brave-browser
    always_run_script = true
    title = Dunst
    class = Dunst
    corner_radius = 8
    ignore_dbusclose = false
    force_xwayland = false
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[experimental]
    per_monitor_dpi = false

[urgency_low]
    background = "#2e3440"
    foreground = "#d8dee9"
    timeout = 10

[urgency_normal]
    background = "#2e3440"
    foreground = "#d8dee9"
    timeout = 10

[urgency_critical]
    background = "#2e3440"
    foreground = "#bf616a"
    frame_color = "#bf616a"
    timeout = 0
EOF

# Create xinitrc
log_info "Creating .xinitrc..."
cat > ~/.xinitrc << 'EOF'
#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec bspwm
EOF

chmod +x ~/.xinitrc

# Create Xresources for Nord theme
log_info "Creating .Xresources with Nord theme..."
cat > ~/.Xresources << 'EOF'
! Nord Color Scheme
*.foreground: #d8dee9
*.background: #2e3440
*.cursorColor: #d8dee9

! Black
*.color0: #3b4252
*.color8: #4c566a

! Red
*.color1: #bf616a
*.color9: #bf616a

! Green
*.color2: #a3be8c
*.color10: #a3be8c

! Yellow
*.color3: #ebcb8b
*.color11: #ebcb8b

! Blue
*.color4: #81a1c1
*.color12: #81a1c1

! Magenta
*.color5: #b48ead
*.color13: #b48ead

! Cyan
*.color6: #88c0d0
*.color14: #8fbcbb

! White
*.color7: #e5e9f0
*.color15: #eceff4

! XTerm settings
XTerm*faceName: Hack
XTerm*faceSize: 11
XTerm*renderFont: true
XTerm*background: #2e3440
XTerm*foreground: #d8dee9
XTerm*cursorColor: #d8dee9
XTerm*selectToClipboard: true
EOF

# Enable services
log_info "Enabling system services..."
sudo systemctl enable lightdm
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable apparmor

# Configure LightDM
log_info "Configuring LightDM..."
sudo tee -a /etc/lightdm/lightdm.conf > /dev/null << 'EOF'

[Seat:*]
session-wrapper=/etc/X11/Xsession
autologin-user-timeout=0
EOF

# Create Pictures directory for screenshots
mkdir -p ~/Pictures

# Create desktop entry for bspwm
log_info "Creating desktop entry for bspwm..."
sudo tee /usr/share/xsessions/bspwm.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=bspwm
Comment=Binary space partitioning window manager
Exec=bspwm
Type=Application
Keywords=wm;tiling
EOF

# Set up wallpaper directory
log_info "Setting up wallpaper directory..."
mkdir -p ~/Pictures/wallpapers
# Create a simple Nord-themed wallpaper
convert -size 1920x1080 xc:"#2e3440" ~/Pictures/wallpapers/nord_solid.png 2>/dev/null || {
    log_warning "ImageMagick not available, skipping wallpaper creation"
}

# Final system configuration
log_info "Applying final configurations..."
xrdb -merge ~/.Xresources 2>/dev/null || log_warning "Could not merge .Xresources (X server not running)"

# Set nitrogen to use the wallpaper
if [ -f ~/Pictures/wallpapers/nord_solid.png ]; then
    nitrogen --set-zoom-fill ~/Pictures/wallpapers/nord_solid.png 2>/dev/null || log_warning "Could not set wallpaper (X server not running)"
fi

# Create a simple startup script
log_info "Creating startup script..."
cat > ~/.profile << 'EOF'
# Start bspwm on login if not already running
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec startx
fi
EOF

# Final message
log_success "Installation complete!"
echo
echo "=== Post-installation steps ==="
echo "1. Reboot your system: sudo reboot"
echo "2. Log in through LightDM (should start automatically)"
echo "3. Or manually start X with: startx"
echo
echo "=== Key bindings ==="
echo "Super + Enter     - Terminal"
echo "Super + d         - Application launcher (rofi)"
echo "Super + Tab       - Window switcher"
echo "Super + w         - Close window"
echo "Super + f         - Toggle fullscreen"
echo "Super + 1-9       - Switch workspaces"
echo "Super + e         - File manager"
echo "Super + Shift + f - Brave browser"
echo
echo "=== Troubleshooting ==="
echo "- If polybar doesn't start, check: ~/.config/polybar/config.ini"
echo "- If shortcuts don't work, check: ~/.config/sxhkd/sxhkdrc"
echo "- To restart bspwm: Super + Alt + r"
echo "- To reload sxhkd: Super + Escape"
echo
log_success "Enjoy your new bspwm desktop environment with Nord Polar Night theme!"
EOF
