#!/bin/bash

# Update system and install base packages
apt update && apt full-upgrade -y
apt install -y sudo curl wget git

# Add user to sudoers (replace 'username' with your actual username)
usermod -aG sudo username

# Install essential packages
apt install -y \
  bspwm sxhkd polybar rofi \
  lightdm lightdm-gtk-greeter \
  network-manager network-manager-gnome bluetooth bluez \
  pulseaudio pavucontrol \
  firewalld fail2ban apparmor apparmor-utils \
  xorg xserver-xorg xinit \
  feh dunst scrot \
  thunar thunar-archive-plugin file-roller \
  neovim ranger htop neofetch \
  fonts-noto fonts-font-awesome fonts-roboto \
  lxappearance qt5ct kvantum \
  nitrogen picom jq

# Install development tools
apt install -y \
  build-essential cmake make pkg-config \
  python3 python3-pip python3-venv \
  meson ninja-build

# Install Nord theme
mkdir -p ~/.themes ~/.icons
wget https://github.com/arcticicestudio/nord/releases/download/v0.2.0/nord-polar-night.xresources
wget https://github.com/arcticicestudio/nord-gtk/releases/download/v1.0.0/nordic-darker.tar.xz
tar -xvf nordic-darker.tar.xz -C ~/.themes/
wget https://github.com/arcticicestudio/nordic/releases/download/v2.1.0/Nordic-darker.tar.xz
tar -xvf Nordic-darker.tar.xz -C ~/.icons/

# Configure Xresources
cat nord-polar-night.xresources >> ~/.Xresources
xrdb -merge ~/.Xresources

# Create config directories
mkdir -p ~/.config/{bspwm,sxhkd,polybar,rofi,dunst,picom}

# Configure bspwm
cat > ~/.config/bspwm/bspwmrc <<'EOF'
#!/bin/sh
pgrep -x sxhkd > /dev/null || sxhkd &
picom -b --config ~/.config/picom/picom.conf &
nitrogen --restore &
~/.config/polybar/launch.sh &
dunst -config ~/.config/dunst/dunstrc &
EOF
chmod +x ~/.config/bspwm/bspwmrc

# Configure sxhkd
cat > ~/.config/sxhkd/sxhkdrc <<'EOF'
# Terminal emulator
super + Return
    alacritty

# Program launcher
super + d
    rofi -show drun -theme ~/.config/rofi/launcher.rasi

# Window operations
super + {_,shift + }q
    bspc node -{c,k}

# State/flags
super + {t,shift + t,s,f}
    bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# Focus/swap
super + {_,shift + }{h,j,k,l}
    bspc node -{f,s} {west,south,north,east}

# Preselect
super + ctrl + {h,j,k,l}
    bspc node -p {west,south,north,east}

# Move/resize
super + alt + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# Workspaces
super + {1-9,0}
    bspc desktop -f {1-9,10}

# Move window to workspace
super + shift + {1-9,0}
    bspc node -d {1-9,10}

# Quit/restart bspwm
super + alt + {q,r}
    bspc {quit,wm -r}
EOF

# Configure polybar
mkdir -p ~/.config/polybar/scripts
cat > ~/.config/polybar/config.ini <<'EOF'
[colors]
background = #2E3440
background-alt = #3B4252
foreground = #D8DEE9
foreground-alt = #4C566A
primary = #81A1C1
secondary = #5E81AC
alert = #BF616A

[bar/main]
monitor = ${env:MONITOR:eDP1}
width = 100%
height = 24
offset-x = 0
offset-y = 0
radius = 0.0
fixed-center = true
background = ${colors.background}
foreground = ${colors.foreground}
line-size = 2
line-color = ${colors.primary}
border-size = 0
border-color = #00000000
padding-left = 0
padding-right = 0
module-margin-left = 1
module-margin-right = 1
font-0 = "Roboto:size=10;3"
font-1 = "Font Awesome 6 Free:style=Solid:size=10;3"
font-2 = "Font Awesome 6 Brands:size=10;3"
modules-left = bspwm xwindow
modules-center = date
modules-right = memory cpu temperature pulseaudio battery wlan eth

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
label-empty-foreground = ${colors.foreground-alt}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:50:...%

[module/memory]
type = internal/memory
interval = 2
label = RAM %percentage_used%%
format-prefix = " "
format-prefix-foreground = ${colors.primary}

[module/cpu]
type = internal/cpu
interval = 2
label = CPU %percentage%%
format-prefix = " "
format-prefix-foreground = ${colors.primary}

[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 70
label = TEMP %temperature-c%°
format-prefix = " "
format-prefix-foreground = ${colors.primary}

[module/pulseaudio]
type = internal/pulseaudio
format-volume = <label-volume> <bar-volume>
label-volume = VOL %percentage%%
label-volume-foreground = ${colors.foreground}
label-muted = 🔇 muted
label-muted-foreground = ${colors.foreground-alt}
bar-volume-width = 6
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-fill = |
bar-volume-empty = |
bar-volume-empty-foreground = ${colors.foreground-alt}

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
full-at = 98
poll-interval = 5
label-charging = CHG %percentage%%
label-discharging = BAT %percentage%%
label-full = FULL
format-charging = <ramp-capacity> <label-charging>
format-discharging = <ramp-capacity> <label-discharging>
format-full = <ramp-capacity> <label-full>
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 

[module/wlan]
type = internal/network
interface = wlp3s0
interval = 3.0
format-connected = <label-connected>
label-connected = %essid% %local_ip%
format-connected-prefix = " "
format-connected-prefix-foreground = ${colors.primary}
format-disconnected = <label-disconnected>
label-disconnected = disconnected
label-disconnected-foreground = ${colors.foreground-alt}

[module/eth]
type = internal/network
interface = enp0s25
interval = 3.0
format-connected = <label-connected>
label-connected = %local_ip%
format-connected-prefix = " "
format-connected-prefix-foreground = ${colors.primary}
format-disconnected = <label-disconnected>
label-disconnected = disconnected
label-disconnected-foreground = ${colors.foreground-alt}

[module/date]
type = internal/date
interval = 1
date = %a %b %d
time = %H:%M
label = %date% %time%
format-prefix = " "
format-prefix-foreground = ${colors.primary}

[settings]
screenchange-reload = true
EOF

# Polybar launch script
cat > ~/.config/polybar/launch.sh <<'EOF'
#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar main &

echo "Polybar launched..."
EOF
chmod +x ~/.config/polybar/launch.sh

# Rofi configuration
mkdir -p ~/.config/rofi
cat > ~/.config/rofi/launcher.rasi <<'EOF'
configuration {
  modi: "drun,run,window";
  show-icons: true;
  icon-theme: "Nordic-darker";
  display-drun: "";
  drun-display-format: "{name}";
  sidebar-mode: false;
}

* {
  background: #2E3440;
  background-alt: #3B4252;
  foreground: #D8DEE9;
  selected: #81A1C1;
  active: #5E81AC;
  urgent: #BF616A;
}

window {
  transparency: "real";
  location: center;
  anchor: center;
  fullscreen: false;
  width: 800px;
  x-offset: 0px;
  y-offset: 0px;
  enabled: true;
  border: 0;
  border-radius: 8px;
  border-color: @active;
  background-color: @background;
  padding: 5px;
}

mainbox {
  enabled: true;
  spacing: 0;
  background-color: transparent;
  children: [inputbar, listview];
}

inputbar {
  enabled: true;
  spacing: 5px;
  padding: 5px;
  background-color: @background-alt;
  text-color: @foreground;
  children: [prompt, entry];
}

prompt {
  enabled: true;
  background-color: inherit;
  text-color: inherit;
}

entry {
  enabled: true;
  background-color: inherit;
  text-color: inherit;
  placeholder: "Search...";
  placeholder-color: @foreground;
}

listview {
  enabled: true;
  columns: 1;
  lines: 8;
  cycle: true;
  dynamic: true;
  scrollbar: false;
  layout: vertical;
  reverse: false;
  fixed-height: true;
  fixed-columns: true;
  spacing: 5px;
  background-color: transparent;
  padding: 5px;
}

element {
  enabled: true;
  spacing: 5px;
  padding: 5px;
  background-color: transparent;
  text-color: @foreground;
}

element selected.normal {
  background-color: @selected;
  text-color: @background;
}

element-text {
  background-color: inherit;
  text-color: inherit;
}

element-icon {
  size: 24px;
  background-color: inherit;
}
EOF

# Configure dunst
cat > ~/.config/dunst/dunstrc <<'EOF'
[global]
    monitor = 0
    follow = keyboard
    width = 300
    height = 100
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
    shrink = no
    transparency = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    frame_width = 1
    frame_color = "#3B4252"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    font = Roboto 10
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
    max_icon_size = 32
    sticky_history = yes
    history_length = 20
    always_run_script = true
    title = Dunst
    class = Dunst
    startup_notification = false
    verbosity = mesg
    corner_radius = 0
    ignore_dbusclose = false
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "#3B4252"
    foreground = "#D8DEE9"
    timeout = 4

[urgency_normal]
    background = "#3B4252"
    foreground = "#D8DEE9"
    timeout = 6

[urgency_critical]
    background = "#BF616A"
    foreground = "#D8DEE9"
    timeout = 0
EOF

# Configure picom
cat > ~/.config/picom/picom.conf <<'EOF'
backend = "glx";
vsync = true;

# Shadows
shadow = true;
shadow-radius = 12;
shadow-opacity = 0.22;
shadow-offset-x = -12;
shadow-offset-y = -12;
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
fade-exclude = [ ];

# Other
inactive-opacity = 0.8;
frame-opacity = 0.7;
inactive-opacity-override = false;
focus-exclude = [ "class_g = 'Cairo-clock'" ];
opacity-rule = [
    "90:class_g = 'Alacritty'",
    "90:class_g = 'FloaTerm'"
];

# Blur
blur: {
    method = "dual_kawase";
    strength = 5;
    background = false;
    background-frame = false;
    background-fixed = false;
}

# Corners
corner-radius = 10;
rounded-corners-exclude = [
    "window_type = 'dock'",
    "window_type = 'desktop'"
];
EOF

# Configure lightdm
cat > /etc/lightdm/lightdm-gtk-greeter.conf <<'EOF'
[greeter]
background = /usr/share/backgrounds/default.png
theme-name = Nordic-darker
icon-theme-name = Nordic-darker
font-name = Roboto 10
xft-antialias = true
xft-dpi = 96
xft-hintstyle = hintslight
xft-rgba = rgb
indicators = ~host;~spacer;~clock;~spacer;~language;~session;~power
EOF

# Configure firewalld
systemctl enable --now firewalld
firewall-cmd --set-default-zone=home
firewall-cmd --reload

# Configure fail2ban
systemctl enable --now fail2ban

# Configure apparmor
systemctl enable --now apparmor
aa-enforce /etc/apparmor.d/*

# Set Nord theme system-wide
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini <<'EOF'
[Settings]
gtk-theme-name=Nordic-darker
gtk-icon-theme-name=Nordic-darker
gtk-font-name=Roboto 10
gtk-cursor-theme-name=Adwaita
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
EOF

# Configure Qt applications
mkdir -p ~/.config/qt5ct
cat > ~/.config/qt5ct/qt5ct.conf <<'EOF'
[Appearance]
color_scheme=Nordic.conf
custom_palette=true
icon_theme=Nordic-darker
standard_dialogs=gtk3
style=kvantum
EOF

# Configure Kvantum
mkdir -p ~/.config/Kvantum
git clone https://github.com/tsujan/Kvantum.git ~/.config/Kvantum
kvantummanager --set Nordic-darker

# Clean up
apt autoremove -y
apt clean

echo "Installation complete! Reboot your system to start using bspwm."
