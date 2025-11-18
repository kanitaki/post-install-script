#!/bin/bash
# Fedora 43 Openbox Post-Install Script with Nord Aurora Theme
# Run as regular user with sudo privileges

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Starting Fedora 43 Openbox Setup...${NC}"

# Update system
echo -e "${YELLOW}Updating system...${NC}"
sudo dnf update -y

# Install base packages
echo -e "${YELLOW}Installing base packages...${NC}"
sudo dnf install -y \
    openbox \
    obconf \
    nitrogen \
    picom \
    rofi \
    alacritty \
    dunst \
    feh \
    scrot \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    network-manager-applet \
    pavucontrol \
    brightnessctl \
    lxappearance \
    papirus-icon-theme \
    fontawesome-fonts \
    powerline-fonts \
    google-noto-sans-fonts \
    git \
    curl \
    wget \
    vim \
    htop \
    ranger \
    mpv \
    vlc \
    
# Install Polybar (from Fedora repos or build from source)
echo -e "${YELLOW}Installing Polybar...${NC}"
if ! dnf list installed polybar &>/dev/null; then
    sudo dnf install -y \
        polybar \
        || (
            echo -e "${YELLOW}Building Polybar from source...${NC}"
            sudo dnf install -y \
                cmake \
                gcc-c++ \
                cairo-devel \
                xcb-proto \
                xcb-util-devel \
                xcb-util-wm-devel \
                xcb-util-image-devel \
                xcb-util-cursor-devel \
                alsa-lib-devel \
                pulseaudio-libs-devel \
                libmpdclient-devel \
                libnl3-devel \
                jsoncpp-devel \
                libcurl-devel
            
            cd /tmp
            git clone --recursive https://github.com/polybar/polybar.git
            cd polybar
            mkdir build && cd build
            cmake ..
            make -j$(nproc)
            sudo make install
            cd ~
        )
fi

# Create directory structure
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p ~/.config/{openbox,polybar,rofi,alacritty,dunst}
mkdir -p ~/.themes
mkdir -p ~/.local/share/fonts
mkdir -p ~/Pictures/Wallpapers

# Download Nord wallpaper
echo -e "${YELLOW}Downloading Nord wallpaper...${NC}"
wget -O ~/Pictures/Wallpapers/nord-mountain.png "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/nordic-mountain-range.png" 2>/dev/null || echo "Wallpaper download skipped"

# Create Nord Openbox theme
echo -e "${YELLOW}Creating Nord Openbox theme...${NC}"
mkdir -p ~/.themes/Nord/openbox-3
cat > ~/.themes/Nord/openbox-3/themerc << 'THEME_EOF'
# Nord Aurora Openbox Theme

# Window geometry
padding.width: 8
padding.height: 8
border.width: 2
window.client.padding.width: 0
window.client.padding.height: 0
window.handle.width: 0

# Menu geometry
menu.border.width: 2
menu.overlap.x: -8
menu.overlap.y: 0

# Border colors
window.active.border.color: #88C0D0
window.inactive.border.color: #3B4252
menu.border.color: #88C0D0
window.active.client.color: #2E3440
window.inactive.client.color: #2E3440

# Titlebar
window.active.title.bg: flat solid
window.active.title.bg.color: #2E3440
window.active.title.separator.color: #2E3440
window.inactive.title.bg: flat solid
window.inactive.title.bg.color: #2E3440
window.inactive.title.separator.color: #2E3440

# Titlebar text
window.label.text.justify: left
window.active.label.bg: parentrelative
window.active.label.text.color: #88C0D0
window.inactive.label.bg: parentrelative
window.inactive.label.text.color: #4C566A

# Window buttons
window.active.button.unpressed.bg: flat solid
window.active.button.unpressed.bg.color: #2E3440
window.active.button.unpressed.image.color: #88C0D0

window.active.button.pressed.bg: flat solid
window.active.button.pressed.bg.color: #3B4252
window.active.button.pressed.image.color: #8FBCBB

window.active.button.disabled.bg: flat solid
window.active.button.disabled.bg.color: #2E3440
window.active.button.disabled.image.color: #4C566A

window.active.button.hover.bg: flat solid
window.active.button.hover.bg.color: #3B4252
window.active.button.hover.image.color: #8FBCBB

window.active.button.toggled.unpressed.bg: flat solid
window.active.button.toggled.unpressed.bg.color: #2E3440
window.active.button.toggled.unpressed.image.color: #88C0D0

window.active.button.toggled.pressed.bg: flat solid
window.active.button.toggled.pressed.bg.color: #3B4252
window.active.button.toggled.pressed.image.color: #8FBCBB

window.active.button.toggled.hover.bg: flat solid
window.active.button.toggled.hover.bg.color: #3B4252
window.active.button.toggled.hover.image.color: #8FBCBB

window.inactive.button.unpressed.bg: flat solid
window.inactive.button.unpressed.bg.color: #2E3440
window.inactive.button.unpressed.image.color: #4C566A

window.inactive.button.pressed.bg: flat solid
window.inactive.button.pressed.bg.color: #3B4252
window.inactive.button.pressed.image.color: #4C566A

window.inactive.button.disabled.bg: flat solid
window.inactive.button.disabled.bg.color: #2E3440
window.inactive.button.disabled.image.color: #3B4252

window.inactive.button.hover.bg: flat solid
window.inactive.button.hover.bg.color: #3B4252
window.inactive.button.hover.image.color: #D8DEE9

window.inactive.button.toggled.unpressed.bg: flat solid
window.inactive.button.toggled.unpressed.bg.color: #2E3440
window.inactive.button.toggled.unpressed.image.color: #4C566A

window.inactive.button.toggled.pressed.bg: flat solid
window.inactive.button.toggled.pressed.bg.color: #3B4252
window.inactive.button.toggled.pressed.image.color: #4C566A

window.inactive.button.toggled.hover.bg: flat solid
window.inactive.button.toggled.hover.bg.color: #3B4252
window.inactive.button.toggled.hover.image.color: #D8DEE9

# Menu
menu.title.bg: flat solid
menu.title.bg.color: #2E3440
menu.title.text.color: #88C0D0
menu.title.text.justify: center

menu.items.bg: flat solid
menu.items.bg.color: #2E3440
menu.items.text.color: #D8DEE9
menu.items.disabled.text.color: #4C566A

menu.items.active.bg: flat solid
menu.items.active.bg.color: #88C0D0
menu.items.active.text.color: #2E3440

menu.separator.color: #3B4252
menu.separator.width: 1
menu.separator.padding.width: 6
menu.separator.padding.height: 3

# OSD
osd.border.width: 2
osd.border.color: #88C0D0

osd.bg: flat solid
osd.bg.color: #2E3440
osd.label.bg: flat solid
osd.label.bg.color: #2E3440
osd.label.text.color: #D8DEE9

osd.hilight.bg: flat solid
osd.hilight.bg.color: #88C0D0

osd.unhilight.bg: flat solid
osd.unhilight.bg.color: #3B4252

osd.button.unpressed.bg: flat border
osd.button.unpressed.bg.color: #2E3440
osd.button.unpressed.*.border.color: #3B4252
osd.button.unpressed.text.color: #D8DEE9

osd.button.pressed.bg: flat border
osd.button.pressed.bg.color: #88C0D0
osd.button.pressed.*.border.color: #88C0D0
osd.button.pressed.text.color: #2E3440
osd.button.pressed.box.color: #88C0D0

osd.button.focused.bg: flat solid border
osd.button.focused.bg.color: #2E3440
osd.button.focused.*.border.color: #88C0D0
osd.button.focused.text.color: #88C0D0
osd.button.focused.box.color: #88C0D0
THEME_EOF

# Configure Openbox
echo -e "${YELLOW}Configuring Openbox...${NC}"
cat > ~/.config/openbox/rc.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc" xmlns:xi="http://www.w3.org/2001/XInclude">
  <resistance>
    <strength>10</strength>
    <screen_edge_strength>20</screen_edge_strength>
  </resistance>
  <focus>
    <focusNew>yes</focusNew>
    <followMouse>no</followMouse>
  </focus>
  <placement>
    <policy>Smart</policy>
  </placement>
  <theme>
    <name>Nord</name>
    <titleLayout>NLIMC</titleLayout>
    <keepBorder>yes</keepBorder>
    <cornerRadius>8</cornerRadius>
    <font place="ActiveWindow">
      <name>Sans</name>
      <size>10</size>
      <weight>Bold</weight>
    </font>
  </theme>
  <desktops>
    <number>4</number>
    <firstdesk>1</firstdesk>
    <names>
      <name>1</name>
      <name>2</name>
      <name>3</name>
      <name>4</name>
    </names>
    <popupTime>0</popupTime>
  </desktops>
  <keyboard>
    <keybind key="W-Return">
      <action name="Execute">
        <command>alacritty</command>
      </action>
    </keybind>
    <keybind key="W-d">
      <action name="Execute">
        <command>rofi -show drun</command>
      </action>
    </keybind>
    <keybind key="W-Tab">
      <action name="Execute">
        <command>rofi -show window</command>
      </action>
    </keybind>
    <keybind key="W-p">
      <action name="Execute">
        <command>~/.config/rofi/powermenu.sh</command>
      </action>
    </keybind>
    <keybind key="W-n">
      <action name="Execute">
        <command>~/.config/rofi/network.sh</command>
      </action>
    </keybind>
    <keybind key="W-a">
      <action name="Execute">
        <command>~/.config/rofi/audio.sh</command>
      </action>
    </keybind>
    <keybind key="W-q">
      <action name="Close"/>
    </keybind>
    <keybind key="W-f">
      <action name="ToggleMaximize"/>
    </keybind>
    <keybind key="Print">
      <action name="Execute">
        <command>scrot ~/Pictures/screenshot_%Y-%m-%d_%H-%M-%S.png</command>
      </action>
    </keybind>
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
    <keybind key="W-1"><action name="GoToDesktop"><to>1</to></action></keybind>
    <keybind key="W-2"><action name="GoToDesktop"><to>2</to></action></keybind>
    <keybind key="W-3"><action name="GoToDesktop"><to>3</to></action></keybind>
    <keybind key="W-4"><action name="GoToDesktop"><to>4</to></action></keybind>
  </keyboard>
  <mouse>
    <dragThreshold>8</dragThreshold>
    <context name="Frame">
      <mousebind button="A-Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="A-Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      <mousebind button="A-Right" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="A-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>
    </context>
    <context name="Titlebar">
      <mousebind button="Left" action="DoubleClick">
        <action name="ToggleMaximize"/>
      </mousebind>
    </context>
  </mouse>
</openbox_config>
EOF

# Create Openbox autostart
cat > ~/.config/openbox/autostart << 'EOF'
#!/bin/bash

# Set wallpaper
if [ -f ~/Pictures/Wallpapers/nord-mountain.png ]; then
    nitrogen --set-zoom-fill ~/Pictures/Wallpapers/nord-mountain.png &
else
    nitrogen --restore &
fi

# Compositor for transparency and effects
picom -b --config ~/.config/picom/picom.conf &

# Notification daemon
dunst &

# Polybar
~/.config/polybar/launch.sh &

# Network manager applet
nm-applet &

# Volume icon in system tray (if available)
if command -v volumeicon &> /dev/null; then
    volumeicon &
fi

# Polkit authentication agent
/usr/libexec/polkit-gnome-authentication-agent-1 &

# Clipboard manager
if command -v clipit &> /dev/null; then
    clipit &
fi
EOF

chmod +x ~/.config/openbox/autostart

# Configure picom (compositor)
echo -e "${YELLOW}Configuring picom compositor...${NC}"
mkdir -p ~/.config/picom
cat > ~/.config/picom/picom.conf << 'EOF'
# Nord-themed Picom Configuration

# Shadow
shadow = true;
shadow-radius = 12;
shadow-opacity = 0.75;
shadow-offset-x = -12;
shadow-offset-y = -12;
shadow-color = "#000000"

shadow-exclude = [
  "name = 'Notification'",
  "class_g = 'Conky'",
  "class_g ?= 'Notify-osd'",
  "class_g = 'Cairo-clock'",
  "_GTK_FRAME_EXTENTS@:c"
];

# Fading
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
fade-delta = 5;

# Transparency / Opacity
inactive-opacity = 0.95;
frame-opacity = 1.0;
inactive-opacity-override = false;
active-opacity = 1.0;

focus-exclude = [ "class_g = 'Cairo-clock'" ];

opacity-rule = [
  "100:class_g = 'Alacritty' && focused",
  "95:class_g = 'Alacritty' && !focused",
  "100:class_g = 'firefox'",
  "100:class_g = 'Thunar'"
];

# Background blurring
blur-method = "dual_kawase";
blur-strength = 5;
blur-background = true;
blur-background-frame = true;
blur-background-fixed = true;

blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "_GTK_FRAME_EXTENTS@:c"
];

# Corners
corner-radius = 8;
rounded-corners-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'"
];

# General Settings
backend = "glx";
vsync = true;
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
detect-transient = true;
glx-no-stencil = true;
glx-no-rebind-pixmap = true;
use-damage = true;
log-level = "warn";

wintypes:
{
  tooltip = { fade = true; shadow = true; opacity = 0.95; focus = true; full-shadow = false; };
  dock = { shadow = false; clip-shadow-above = true; }
  dnd = { shadow = false; }
  popup_menu = { opacity = 0.95; }
  dropdown_menu = { opacity = 0.95; }
};
EOF

# Configure Polybar with Nord Aurora
echo -e "${YELLOW}Configuring Polybar...${NC}"
cat > ~/.config/polybar/config.ini << 'EOF'
;==========================================================
;   Polybar Nord Aurora Theme Configuration
;==========================================================

[colors]
; Nord Aurora colors
nord0 = #2E3440
nord1 = #3B4252
nord2 = #434C5E
nord3 = #4C566A
nord4 = #D8DEE9
nord5 = #E5E9F0
nord6 = #ECEFF4
nord7 = #8FBCBB
nord8 = #88C0D0
nord9 = #81A1C1
nord10 = #5E81AC
nord11 = #BF616A
nord12 = #D08770
nord13 = #EBCB8B
nord14 = #A3BE8C
nord15 = #B48EAD

background = ${colors.nord0}
background-alt = ${colors.nord1}
foreground = ${colors.nord4}
primary = ${colors.nord8}
secondary = ${colors.nord13}
alert = ${colors.nord11}
success = ${colors.nord14}

[bar/main]
width = 100%
height = 28
radius = 0
fixed-center = true

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 2
line-color = ${colors.primary}

border-size = 0
border-color = ${colors.background}

padding-left = 1
padding-right = 1

module-margin-left = 1
module-margin-right = 1

font-0 = "Noto Sans:size=10;2"
font-1 = "Noto Sans:size=10:style=Bold;2"
font-2 = "Noto Emoji:scale=10;2"

modules-left = workspaces xwindow
modules-center = date
modules-right = pulseaudio memory cpu temperature network battery powermenu

tray-position = right
tray-padding = 2
tray-background = ${colors.background}

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

[module/workspaces]
type = internal/xworkspaces

label-active = %name%
label-active-background = ${colors.primary}
label-active-foreground = ${colors.nord0}
label-active-padding = 2

label-occupied = %name%
label-occupied-padding = 2

label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 2

label-empty = %name%
label-empty-foreground = ${colors.nord3}
label-empty-padding = 2

[module/xwindow]
type = internal/xwindow
label = %title:0:50:...%
label-foreground = ${colors.primary}

[module/date]
type = internal/date
interval = 1

date = %Y-%m-%d%
time = %H:%M:%S

label = %date% %time%
label-foreground = ${colors.secondary}

[module/pulseaudio]
type = internal/pulseaudio

format-volume = <ramp-volume> <label-volume>
label-volume = %percentage%%
label-volume-foreground = ${colors.foreground}

label-muted = 🔇 muted
label-muted-foreground = ${colors.nord3}

ramp-volume-0 = 🔈
ramp-volume-1 = 🔉
ramp-volume-2 = 🔊
ramp-volume-foreground = ${colors.primary}

click-right = pavucontrol

[module/memory]
type = internal/memory
interval = 3

format-prefix = "💾 "
format-prefix-foreground = ${colors.primary}
label = %percentage_used%%

[module/cpu]
type = internal/cpu
interval = 2

format-prefix = "⚡ "
format-prefix-foreground = ${colors.primary}
label = %percentage%%

[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 70

format = <ramp> <label>
format-warn = <ramp> <label-warn>

label = %temperature-c%
label-warn = %temperature-c%
label-warn-foreground = ${colors.alert}

ramp-0 = 🌡️
ramp-1 = 🌡️
ramp-2 = 🌡️
ramp-foreground = ${colors.primary}

[module/network]
type = internal/network
interface-type = wireless
interval = 3.0

format-connected = <label-connected>
format-disconnected = <label-disconnected>

label-connected = 📶 %essid%
label-connected-foreground = ${colors.success}

label-disconnected = 📡
label-disconnected-foreground = ${colors.alert}

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
full-at = 98

format-charging = <animation-charging> <label-charging>
format-discharging = <ramp-capacity> <label-discharging>
format-full = <ramp-capacity> <label-full>

label-charging = %percentage%%
label-discharging = %percentage%%
label-full = %percentage%%

ramp-capacity-0 = 🪫
ramp-capacity-1 = 🔋
ramp-capacity-2 = 🔋
ramp-capacity-3 = 🔋
ramp-capacity-4 = 🔋
ramp-capacity-foreground = ${colors.primary}

animation-charging-0 = 🔌
animation-charging-1 = 🔌
animation-charging-2 = 🔌
animation-charging-3 = 🔌
animation-charging-4 = 🔌
animation-charging-foreground = ${colors.success}
animation-charging-framerate = 750

[module/powermenu]
type = custom/text
content = ⏻
content-foreground = ${colors.alert}
click-left = ~/.config/rofi/powermenu.sh

[settings]
screenchange-reload = true

[global/wm]
margin-top = 0
margin-bottom = 0
EOF

# Create Polybar launch script
cat > ~/.config/polybar/launch.sh << 'EOF'
#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown
EOF

chmod +x ~/.config/polybar/launch.sh

# Configure Rofi with Nord Aurora
echo -e "${YELLOW}Configuring Rofi...${NC}"
cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun,run,window";
    font: "Noto Sans 11";
    show-icons: true;
    icon-theme: "Papirus";
    display-drun: "Applications";
    display-run: "Run";
    display-window: "Windows";
    drun-display-format: "{name}";
    terminal: "alacritty";
}

* {
    nord0: #2E3440;
    nord1: #3B4252;
    nord2: #434C5E;
    nord3: #4C566A;
    nord4: #D8DEE9;
    nord5: #E5E9F0;
    nord6: #ECEFF4;
    nord8: #88C0D0;
    nord9: #81A1C1;
    nord11: #BF616A;
    nord13: #EBCB8B;
    
    background-color: @nord0;
    text-color: @nord4;
    spacing: 0;
}

window {
    transparency: "real";
    background-color: @nord0;
    border: 2px;
    border-color: @nord8;
    border-radius: 10px;
    width: 600px;
    padding: 20px;
}

mainbox {
    children: [inputbar, listview];
    spacing: 10px;
}

inputbar {
    background-color: @nord1;
    border-radius: 5px;
    padding: 10px;
    children: [prompt, entry];
}

prompt {
    text-color: @nord8;
    padding: 0 10px 0 0;
}

entry {
    placeholder: "Search...";
    placeholder-color: @nord3;
}

listview {
    lines: 8;
    scrollbar: false;
    border: 0;
}

element {
    padding: 10px;
    border-radius: 5px;
}

element selected {
    background-color: @nord8;
    text-color: @nord0;
}

element-icon {
    size: 24px;
    padding: 0 10px 0 0;
}

element-text {
    vertical-align: 0.5;
}
EOF

# Create Rofi power menu
cat > ~/.config/rofi/powermenu.sh << 'EOF'
#!/bin/bash

options="⏻ Shutdown\n⟲ Reboot\n⏾ Suspend\n Lock\n Logout"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 300px;}')

case $chosen in
    *Shutdown)
        systemctl poweroff
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Lock)
        i3lock -c 2E3440
        ;;
    *Logout)
        openbox --exit
        ;;
esac
EOF

chmod +x ~/.config/rofi/powermenu.sh

# Create Rofi network menu
cat > ~/.config/rofi/network.sh << 'EOF'
#!/bin/bash

# Get network status
wifi_status=$(nmcli -t -f WIFI g)
active_conn=$(nmcli -t -f NAME c show --active | head -1)

if [ "$wifi_status" = "enabled" ]; then
    networks=$(nmcli -f SSID,SIGNAL,SECURITY d wifi list | tail -n +2)
    
    # Add disconnect option if connected
    if [ -n "$active_conn" ]; then
        options=" Disconnect from $active_conn\n$networks"
    else
        options="$networks"
    fi
    
    chosen=$(echo -e "$options" | rofi -dmenu -i -p "WiFi Networks")
    
    if echo "$chosen" | grep -q "Disconnect"; then
        nmcli c down "$active_conn"
        notify-send "Network" "Disconnected from $active_conn"
    elif [ -n "$chosen" ]; then
        ssid=$(echo "$chosen" | awk '{print $1}')
        
        # Check if network is secured
        if echo "$chosen" | grep -q "WPA"; then
            password=$(rofi -dmenu -password -p "Password for $ssid")
            if [ -n "$password" ]; then
                nmcli d wifi connect "$ssid" password "$password"
            fi
        else
            nmcli d wifi connect "$ssid"
        fi
    fi
else
    echo "WiFi is disabled" | rofi -dmenu -p "Network"
fi
EOF

chmod +x ~/.config/rofi/network.sh

# Create Rofi audio menu
cat > ~/.config/rofi/audio.sh << 'EOF'
#!/bin/bash

# Get current volume
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$mute_status" = "yes" ]; then
    mute_icon=" Unmute"
else
    mute_icon=" Mute"
fi

options="$mute_icon\n Volume Up\n Volume Down\n Open Mixer"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Audio ($volume%)")

case $chosen in
    *Mute|*Unmute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *"Volume Up")
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    *"Volume Down")
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    *Mixer)
        pavucontrol
        ;;
esac
EOF

chmod +x ~/.config/rofi/audio.sh

# Configure Alacritty with Nord Aurora
echo -e "${YELLOW}Configuring Alacritty...${NC}"
cat > ~/.config/alacritty/alacritty.toml << 'EOF'
[window]
opacity = 0.95
padding = { x = 10, y = 10 }
decorations = "full"

[font]
normal = { family = "Noto Sans Mono", style = "Regular" }
bold = { family = "Noto Sans Mono", style = "Bold" }
italic = { family = "Noto Sans Mono", style = "Italic" }
size = 11.0

[colors.primary]
background = "#2E3440"
foreground = "#D8DEE9"
dim_foreground = "#A5ABB6"

[colors.cursor]
text = "#2E3440"
cursor = "#D8DEE9"

[colors.normal]
black = "#3B4252"
red = "#BF616A"
green = "#A3BE8C"
yellow = "#EBCB8B"
blue = "#81A1C1"
magenta = "#B48EAD"
cyan = "#88C0D0"
white = "#E5E9F0"

[colors.bright]
black = "#4C566A"
red = "#BF616A"
green = "#A3BE8C"
yellow = "#EBCB8B"
blue = "#81A1C1"
magenta = "#B48EAD"
cyan = "#8FBCBB"
white = "#ECEFF4"
EOF

# Configure Dunst (notification daemon)
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    font = Noto Sans 10
    markup = yes
    format = "<b>%s</b>\n%b"
    sort = yes
    indicate_hidden = yes
    alignment = left
    bounce_freq = 0
    show_age_threshold = 60
    word_wrap = yes
    ignore_newline = no
    geometry = "300x5-30+50"
    transparency = 10
    idle_threshold = 120
    monitor = 0
    follow = mouse
    sticky_history = yes
    line_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    separator_color = frame
    startup_notification = false
    corner_radius = 8

[urgency_low]
    background = "#2E3440"
    foreground = "#D8DEE9"
    timeout = 5

[urgency_normal]
    background = "#2E3440"
    foreground = "#88C0D0"
    timeout = 10

[urgency_critical]
    background = "#2E3440"
    foreground = "#BF616A"
    timeout = 0
EOF

# Set Openbox as default session
echo -e "${YELLOW}Setting up Openbox session...${NC}"
if [ ! -f ~/.xinitrc ]; then
    echo "exec openbox-session" > ~/.xinitrc
fi

# Create desktop entry for display manager
sudo tee /usr/share/xsessions/openbox.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Openbox
Comment=Openbox Window Manager
Exec=openbox-session
Type=Application
EOF

# Configure GTK theme settings
echo -e "${YELLOW}Configuring GTK theme...${NC}"
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
EOF

cat > ~/.gtkrc-2.0 << 'EOF'
gtk-theme-name="Adwaita-dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="Noto Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintslight"
gtk-xft-rgba="rgb"
EOF

# Set up nitrogen config for wallpaper
echo -e "${YELLOW}Configuring nitrogen...${NC}"
mkdir -p ~/.config/nitrogen
cat > ~/.config/nitrogen/bg-saved.cfg << 'EOF'
[xin_-1]
file=PLACEHOLDER_WALLPAPER
mode=5
bgcolor=#2e3440
EOF

# Replace placeholder with actual wallpaper path
if [ -f ~/Pictures/Wallpapers/nord-mountain.png ]; then
    sed -i "s|PLACEHOLDER_WALLPAPER|$HOME/Pictures/Wallpapers/nord-mountain.png|" ~/.config/nitrogen/bg-saved.cfg
fi

cat > ~/.config/nitrogen/nitrogen.cfg << 'EOF'
[geometry]
posx=450
posy=200
sizex=600
sizey=500

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs=PLACEHOLDER_WALLPAPER_DIR;
EOF

sed -i "s|PLACEHOLDER_WALLPAPER_DIR|$HOME/Pictures/Wallpapers|" ~/.config/nitrogen/nitrogen.cfg

# Create right-click menu configuration
echo -e "${YELLOW}Creating Openbox menu...${NC}"
cat > ~/.config/openbox/menu.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu xmlns="http://openbox.org/3.4/menu">
    <menu id="root-menu" label="Openbox">
        <item label="Terminal">
            <action name="Execute">
                <command>alacritty</command>
            </action>
        </item>
        <item label="Web Browser">
            <action name="Execute">
                <command>firefox</command>
            </action>
        </item>
        <item label="File Manager">
            <action name="Execute">
                <command>thunar</command>
            </action>
        </item>
        <item label="Text Editor">
            <action name="Execute">
                <command>gedit</command>
            </action>
        </item>
        <separator />
        <menu id="applications-menu" label="Applications">
            <item label="Calculator">
                <action name="Execute">
                    <command>gnome-calculator</command>
                </action>
            </item>
            <item label="Image Viewer">
                <action name="Execute">
                    <command>eog</command>
                </action>
            </item>
            <item label="Video Player">
                <action name="Execute">
                    <command>mpv</command>
                </action>
            </item>
            <item label="Archive Manager">
                <action name="Execute">
                    <command>file-roller</command>
                </action>
            </item>
        </menu>
        <separator />
        <menu id="settings-menu" label="Settings">
            <item label="Openbox Configuration">
                <action name="Execute">
                    <command>obconf</command>
                </action>
            </item>
            <item label="GTK Theme Settings">
                <action name="Execute">
                    <command>lxappearance</command>
                </action>
            </item>
            <item label="Wallpaper">
                <action name="Execute">
                    <command>nitrogen</command>
                </action>
            </item>
            <item label="Audio Settings">
                <action name="Execute">
                    <command>pavucontrol</command>
                </action>
            </item>
            <item label="Power Management">
                <action name="Execute">
                    <command>xfce4-power-manager-settings</command>
                </action>
            </item>
        </menu>
        <separator />
        <item label="Reconfigure">
            <action name="Reconfigure" />
        </item>
        <item label="Exit">
            <action name="Exit">
                <prompt>yes</prompt>
            </action>
        </item>
    </menu>
</openbox_menu>
EOF

echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}         Nord Aurora Openbox Setup Complete!${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Keybindings:${NC}"
echo "  ${GREEN}Super + Enter${NC}    : Open Alacritty terminal"
echo "  ${GREEN}Super + D${NC}        : Application launcher (Rofi)"
echo "  ${GREEN}Super + Tab${NC}      : Window switcher"
echo "  ${GREEN}Super + P${NC}        : Power menu"
echo "  ${GREEN}Super + N${NC}        : Network menu"
echo "  ${GREEN}Super + A${NC}        : Audio menu"
echo "  ${GREEN}Super + Q${NC}        : Close window"
echo "  ${GREEN}Super + F${NC}        : Toggle fullscreen"
echo "  ${GREEN}Print${NC}            : Take screenshot"
echo "  ${GREEN}Super + 1-4${NC}      : Switch workspaces"
echo "  ${GREEN}Alt + F4${NC}         : Close window"
echo "  ${GREEN}Right Click${NC}      : Context menu"
echo ""
echo -e "${YELLOW}Installed Features:${NC}"
echo "  • ${GREEN}Window Manager:${NC} Openbox with Nord theme"
echo "  • ${GREEN}Status Bar:${NC} Polybar with system monitoring"
echo "  • ${GREEN}Application Launcher:${NC} Rofi with Nord Aurora colors"
echo "  • ${GREEN}Terminal:${NC} Alacritty with Nord color scheme"
echo "  • ${GREEN}Compositor:${NC} Picom (transparency, shadows, blur)"
echo "  • ${GREEN}File Manager:${NC} Thunar"
echo "  • ${GREEN}Notifications:${NC} Dunst"
echo "  • ${GREEN}Wallpaper:${NC} Nitrogen (Nord wallpaper included)"
echo ""
echo -e "${YELLOW}To start Openbox:${NC}"
echo "  1. ${GREEN}Logout${NC} from your current session"
echo "  2. At the login screen, select ${GREEN}'Openbox'${NC} from session menu"
echo "  3. Login with your credentials"
echo ""
echo -e "${YELLOW}Or from terminal:${NC}"
echo "  Run ${GREEN}'startx'${NC} (if no display manager is running)"
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Enjoy your new Nord-themed Openbox environment!${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
