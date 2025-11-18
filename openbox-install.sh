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
nitrogen --restore &

# Compositor for transparency
picom -b &

# Notification daemon
dunst &

# Polybar
~/.config/polybar/launch.sh &

# Network manager applet
nm-applet &

# System tray volume control
volumeicon &

# Power management
xfce4-power-manager &
EOF

chmod +x ~/.config/openbox/autostart

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
font-1 = "Font Awesome 6 Free:style=Solid:size=10;2"
font-2 = "Font Awesome 6 Brands:size=10;2"

modules-left = workspaces xwindow
modules-center = date
modules-right = pulseaudio memory cpu temperature network battery powermenu

cursor-click = pointer
cursor-scroll = ns-resize

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

label-muted =  muted
label-muted-foreground = ${colors.nord3}

ramp-volume-0 = 
ramp-volume-1 = 
ramp-volume-2 = 
ramp-volume-foreground = ${colors.primary}

click-right = pavucontrol

[module/memory]
type = internal/memory
interval = 3

format-prefix = " "
format-prefix-foreground = ${colors.primary}
label = %percentage_used%%

[module/cpu]
type = internal/cpu
interval = 2

format-prefix = " "
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

ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-foreground = ${colors.primary}

[module/network]
type = internal/network
interface-type = wireless
interval = 3.0

format-connected = <label-connected>
format-disconnected = <label-disconnected>

label-connected =  %essid%
label-connected-foreground = ${colors.success}

label-disconnected = 
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
animation-charging-foreground = ${colors.success}
animation-charging-framerate = 750

[module/powermenu]
type = custom/text
content = 
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

echo -e "${GREEN}Installation complete!${NC}"
echo -e "${YELLOW}Keybindings:${NC}"
echo "  Super + Enter    : Open Alacritty terminal"
echo "  Super + D        : Application launcher"
echo "  Super + Tab      : Window switcher"
echo "  Super + P        : Power menu"
echo "  Super + N        : Network menu"
echo "  Super + A        : Audio menu"
echo "  Super + Q        : Close window"
echo "  Super + F        : Toggle fullscreen"
echo "  Print            : Take screenshot"
echo "  Super + 1-4      : Switch workspaces"
echo ""
echo -e "${YELLOW}To start Openbox:${NC}"
echo "  - From login screen: Select 'Openbox' session"
echo "  - From terminal: Run 'startx' (if no display manager)"
echo ""
echo -e "${GREEN}Please reboot or logout and select Openbox session!${NC}"
