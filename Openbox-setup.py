#!/usr/bin/env python3
"""
Fedora 43 Openbox Post-Install Script with Nord Aurora Theme
Run as regular user with sudo privileges
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path
from typing import List, Dict
import urllib.request

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    NC = '\033[0m'

def print_status(message: str, color: str = Colors.GREEN):
    """Print colored status message"""
    print(f"{color}{message}{Colors.NC}")

def run_command(cmd: List[str], check: bool = True, shell: bool = False) -> subprocess.CompletedProcess:
    """Run shell command with error handling"""
    try:
        if shell:
            result = subprocess.run(cmd, shell=True, check=check, capture_output=True, text=True)
        else:
            result = subprocess.run(cmd, check=check, capture_output=True, text=True)
        return result
    except subprocess.CalledProcessError as e:
        print_status(f"Error running command: {' '.join(cmd) if isinstance(cmd, list) else cmd}", Colors.RED)
        print_status(f"Error message: {e.stderr}", Colors.RED)
        if check:
            sys.exit(1)
        return e

def create_directory(path: Path):
    """Create directory if it doesn't exist"""
    path.mkdir(parents=True, exist_ok=True)
    print_status(f"Created directory: {path}", Colors.BLUE)

def write_file(path: Path, content: str):
    """Write content to file"""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    print_status(f"Created file: {path}", Colors.BLUE)

def download_file(url: str, destination: Path):
    """Download file from URL"""
    try:
        destination.parent.mkdir(parents=True, exist_ok=True)
        urllib.request.urlretrieve(url, destination)
        print_status(f"Downloaded: {destination}", Colors.GREEN)
        return True
    except Exception as e:
        print_status(f"Download failed: {e}", Colors.YELLOW)
        return False

def install_packages():
    """Install all required packages"""
    print_status("Updating system...", Colors.YELLOW)
    run_command(['sudo', 'dnf', 'update', '-y'])
    
    print_status("Installing base packages...", Colors.YELLOW)
    packages = [
        'openbox', 'obconf', 'nitrogen', 'picom',
        'rofi', 'alacritty', 'dunst', 'feh', 'scrot', 'thunar',
        'thunar-archive-plugin', 'thunar-volman', 'network-manager-applet',
        'pavucontrol', 'brightnessctl', 'lxappearance',
        'papirus-icon-theme', 'google-noto-sans-fonts', 'google-noto-sans-mono-fonts',
        'google-noto-emoji-fonts', 'git', 'curl', 'wget', 'vim', 'htop',
        'ranger', 'mpv', 'vlc', 'polkit-gnome',
        'xfce4-power-manager', 'clipit', 'volumeicon', 'gedit',
        'gnome-calculator', 'eog', 'file-roller'
    ]
    
    run_command(['sudo', 'dnf', 'install', '-y'] + packages)

def install_polybar():
    """Install Polybar"""
    print_status("Installing Polybar...", Colors.YELLOW)
    
    # Try to install from repos first
    result = run_command(['dnf', 'list', 'installed', 'polybar'], check=False)
    if result.returncode == 0:
        print_status("Polybar already installed", Colors.GREEN)
        return
    
    result = run_command(['sudo', 'dnf', 'install', '-y', 'polybar'], check=False)
    if result.returncode == 0:
        print_status("Polybar installed from repository", Colors.GREEN)
        return
    
    # Build from source if not in repos
    print_status("Building Polybar from source...", Colors.YELLOW)
    build_deps = [
        'cmake', 'gcc-c++', 'cairo-devel', 'xcb-proto', 'xcb-util-devel',
        'xcb-util-wm-devel', 'xcb-util-image-devel', 'xcb-util-cursor-devel',
        'alsa-lib-devel', 'pulseaudio-libs-devel', 'libmpdclient-devel',
        'libnl3-devel', 'jsoncpp-devel', 'libcurl-devel'
    ]
    run_command(['sudo', 'dnf', 'install', '-y'] + build_deps)
    
    tmp_dir = Path('/tmp/polybar')
    if tmp_dir.exists():
        shutil.rmtree(tmp_dir)
    
    run_command(['git', 'clone', '--recursive', 'https://github.com/polybar/polybar.git', str(tmp_dir)])
    build_dir = tmp_dir / 'build'
    build_dir.mkdir(exist_ok=True)
    
    os.chdir(build_dir)
    run_command(['cmake', '..'])
    run_command(['make', f'-j{os.cpu_count()}'])
    run_command(['sudo', 'make', 'install'])
    os.chdir(Path.home())

def setup_directory_structure():
    """Create all necessary directories"""
    print_status("Creating directory structure...", Colors.YELLOW)
    
    home = Path.home()
    directories = [
        home / '.config' / 'openbox',
        home / '.config' / 'polybar',
        home / '.config' / 'rofi',
        home / '.config' / 'alacritty',
        home / '.config' / 'dunst',
        home / '.config' / 'picom',
        home / '.config' / 'gtk-3.0',
        home / '.config' / 'nitrogen',
        home / '.themes' / 'Nord' / 'openbox-3',
        home / '.local' / 'share' / 'fonts',
        home / 'Pictures' / 'Wallpapers'
    ]
    
    for directory in directories:
        create_directory(directory)

def download_wallpaper():
    """Download Nord wallpaper"""
    print_status("Downloading Nord wallpaper...", Colors.YELLOW)
    wallpaper_url = "https://raw.githubusercontent.com/linuxdotexe/nordic-wallpapers/master/wallpapers/nordic-mountain-range.png"
    wallpaper_path = Path.home() / 'Pictures' / 'Wallpapers' / 'nord-mountain.png'
    download_file(wallpaper_url, wallpaper_path)

def create_openbox_theme():
    """Create Nord Openbox theme"""
    print_status("Creating Nord Openbox theme...", Colors.YELLOW)
    
    theme_content = """# Nord Aurora Openbox Theme

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
"""
    
    theme_path = Path.home() / '.themes' / 'Nord' / 'openbox-3' / 'themerc'
    write_file(theme_path, theme_content)

def create_openbox_config():
    """Create Openbox configuration"""
    print_status("Configuring Openbox...", Colors.YELLOW)
    
    rc_xml = """<?xml version="1.0" encoding="UTF-8"?>
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
    <animateIconify>yes</animateIconify>
    <font place="ActiveWindow">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Bold</weight>
      <slant>Normal</slant>
    </font>
    <font place="InactiveWindow">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Normal</weight>
      <slant>Normal</slant>
    </font>
    <font place="MenuHeader">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Bold</weight>
      <slant>Normal</slant>
    </font>
    <font place="MenuItem">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Normal</weight>
      <slant>Normal</slant>
    </font>
    <font place="ActiveOnScreenDisplay">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Bold</weight>
      <slant>Normal</slant>
    </font>
    <font place="InactiveOnScreenDisplay">
      <name>Noto Sans</name>
      <size>10</size>
      <weight>Normal</weight>
      <slant>Normal</slant>
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
"""
    
    config_path = Path.home() / '.config' / 'openbox' / 'rc.xml'
    write_file(config_path, rc_xml)

def create_openbox_autostart():
    """Create Openbox autostart script"""
    print_status("Creating Openbox autostart...", Colors.YELLOW)
    
    wallpaper_path = Path.home() / 'Pictures' / 'Wallpapers' / 'nord-mountain.png'
    
    autostart = f"""#!/bin/bash

# Set wallpaper
if [ -f {wallpaper_path} ]; then
    nitrogen --set-zoom-fill {wallpaper_path} &
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
"""
    
    autostart_path = Path.home() / '.config' / 'openbox' / 'autostart'
    write_file(autostart_path, autostart)
    autostart_path.chmod(0o755)

def create_openbox_menu():
    """Create Openbox right-click menu"""
    print_status("Creating Openbox menu...", Colors.YELLOW)
    
    menu_xml = """<?xml version="1.0" encoding="UTF-8"?>
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
"""
    
    menu_path = Path.home() / '.config' / 'openbox' / 'menu.xml'
    write_file(menu_path, menu_xml)

def create_picom_config():
    """Create Picom compositor configuration"""
    print_status("Configuring picom compositor...", Colors.YELLOW)
    
    picom_config = """# Nord-themed Picom Configuration

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
"""
    
    picom_path = Path.home() / '.config' / 'picom' / 'picom.conf'
    write_file(picom_path, picom_config)

def create_polybar_config():
    """Create Polybar configuration"""
    print_status("Configuring Polybar...", Colors.YELLOW)
    
    polybar_config = """;==========================================================
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
"""
    
    polybar_path = Path.home() / '.config' / 'polybar' / 'config.ini'
    write_file(polybar_path, polybar_config)
    
    # Create launch script
    launch_script = """#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown
"""
    
    launch_path = Path.home() / '.config' / 'polybar' / 'launch.sh'
    write_file(launch_path, launch_script)
    launch_path.chmod(0o755)

def create_rofi_config():
    """Create Rofi configuration and menus"""
    print_status("Configuring Rofi...", Colors.YELLOW)
    
    # Main Rofi config
    rofi_config = """configuration {
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
"""
    
    rofi_config_path = Path.home() / '.config' / 'rofi' / 'config.rasi'
    write_file(rofi_config_path, rofi_config)
    
    # Power menu script
    powermenu_script = """#!/bin/bash

options="⏻ Shutdown\\n⟲ Reboot\\n⏾ Suspend\\n Lock\\n Logout"

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
"""
    
    powermenu_path = Path.home() / '.config' / 'rofi' / 'powermenu.sh'
    write_file(powermenu_path, powermenu_script)
    powermenu_path.chmod(0o755)
    
    # Network menu script
    network_script = """#!/bin/bash

# Get network status
wifi_status=$(nmcli -t -f WIFI g)
active_conn=$(nmcli -t -f NAME c show --active | head -1)

if [ "$wifi_status" = "enabled" ]; then
    networks=$(nmcli -f SSID,SIGNAL,SECURITY d wifi list | tail -n +2)
    
    # Add disconnect option if connected
    if [ -n "$active_conn" ]; then
        options=" Disconnect from $active_conn\\n$networks"
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
"""
    
    network_path = Path.home() / '.config' / 'rofi' / 'network.sh'
    write_file(network_path, network_script)
    network_path.chmod(0o755)
    
    # Audio menu script
    audio_script = """#!/bin/bash

# Get current volume
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\\d+(?=%)' | head -1)
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

if [ "$mute_status" = "yes" ]; then
    mute_icon=" Unmute"
else
    mute_icon=" Mute"
fi

options="$mute_icon\\n Volume Up\\n Volume Down\\n Open Mixer"

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
"""
    
    audio_path = Path.home() / '.config' / 'rofi' / 'audio.sh'
    write_file(audio_path, audio_script)
    audio_path.chmod(0o755)

def create_alacritty_config():
    """Create Alacritty configuration"""
    print_status("Configuring Alacritty...", Colors.YELLOW)
    
    alacritty_config = """[window]
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
"""
    
    alacritty_path = Path.home() / '.config' / 'alacritty' / 'alacritty.toml'
    write_file(alacritty_path, alacritty_config)

def create_dunst_config():
    """Create Dunst notification daemon configuration"""
    print_status("Configuring Dunst...", Colors.YELLOW)
    
    dunst_config = """[global]
    font = Noto Sans 10
    markup = yes
    format = "<b>%s</b>\\n%b"
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
"""
    
    dunst_path = Path.home() / '.config' / 'dunst' / 'dunstrc'
    write_file(dunst_path, dunst_config)

def create_gtk_config():
    """Configure GTK theme settings"""
    print_status("Configuring GTK theme...", Colors.YELLOW)
    
    gtk3_settings = """[Settings]
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
"""
    
    gtk3_path = Path.home() / '.config' / 'gtk-3.0' / 'settings.ini'
    write_file(gtk3_path, gtk3_settings)
    
    gtk2_settings = """gtk-theme-name="Adwaita-dark"
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
"""
    
    gtk2_path = Path.home() / '.gtkrc-2.0'
    write_file(gtk2_path, gtk2_settings)

def create_nitrogen_config():
    """Configure nitrogen wallpaper manager"""
    print_status("Configuring nitrogen...", Colors.YELLOW)
    
    wallpaper_path = Path.home() / 'Pictures' / 'Wallpapers' / 'nord-mountain.png'
    wallpaper_dir = Path.home() / 'Pictures' / 'Wallpapers'
    
    bg_saved = f"""[xin_-1]
file={wallpaper_path}
mode=5
bgcolor=#2e3440
"""
    
    nitrogen_cfg = f"""[geometry]
posx=450
posy=200
sizex=600
sizey=500

[nitrogen]
view=icon
recurse=true
sort=alpha
icon_caps=false
dirs={wallpaper_dir};
"""
    
    bg_saved_path = Path.home() / '.config' / 'nitrogen' / 'bg-saved.cfg'
    nitrogen_cfg_path = Path.home() / '.config' / 'nitrogen' / 'nitrogen.cfg'
    
    write_file(bg_saved_path, bg_saved)
    write_file(nitrogen_cfg_path, nitrogen_cfg)

def create_xinitrc():
    """Create .xinitrc for startx"""
    print_status("Setting up Openbox session...", Colors.YELLOW)
    
    xinitrc_path = Path.home() / '.xinitrc'
    if not xinitrc_path.exists():
        write_file(xinitrc_path, "exec openbox-session\n")

def create_desktop_entry():
    """Create desktop entry for display manager"""
    print_status("Creating desktop entry...", Colors.YELLOW)
    
    desktop_entry = """[Desktop Entry]
Name=Openbox
Comment=Openbox Window Manager
Exec=openbox-session
Type=Application
"""
    
    desktop_entry_path = Path('/usr/share/xsessions/openbox.desktop')
    tmp_path = Path('/tmp/openbox.desktop')
    write_file(tmp_path, desktop_entry)
    run_command(['sudo', 'mv', str(tmp_path), str(desktop_entry_path)])

def print_summary():
    """Print installation summary"""
    print()
    print_status("━" * 60, Colors.YELLOW)
    print_status("         Nord Aurora Openbox Setup Complete!", Colors.GREEN)
    print_status("━" * 60, Colors.YELLOW)
    print()
    print_status("Keybindings:", Colors.YELLOW)
    keybindings = {
        "Super + Enter": "Open Alacritty terminal",
        "Super + D": "Application launcher (Rofi)",
        "Super + Tab": "Window switcher",
        "Super + P": "Power menu",
        "Super + N": "Network menu",
        "Super + A": "Audio menu",
        "Super + Q": "Close window",
        "Super + F": "Toggle fullscreen",
        "Print": "Take screenshot",
        "Super + 1-4": "Switch workspaces",
        "Alt + F4": "Close window",
        "Right Click": "Context menu"
    }
    
    for key, desc in keybindings.items():
        print(f"  {Colors.GREEN}{key:20}{Colors.NC} : {desc}")
    
    print()
    print_status("Installed Features:", Colors.YELLOW)
    features = [
        ("Window Manager", "Openbox with Nord theme"),
        ("Status Bar", "Polybar with system monitoring"),
        ("Application Launcher", "Rofi with Nord Aurora colors"),
        ("Terminal", "Alacritty with Nord color scheme"),
        ("Compositor", "Picom (transparency, shadows, blur)"),
        ("File Manager", "Thunar"),
        ("Notifications", "Dunst"),
        ("Wallpaper", "Nitrogen (Nord wallpaper included)")
    ]
    
    for name, desc in features:
        print(f"  • {Colors.GREEN}{name}:{Colors.NC} {desc}")
    
    print()
    print_status("To start Openbox:", Colors.YELLOW)
    print(f"  1. {Colors.GREEN}Logout{Colors.NC} from your current session")
    print(f"  2. At the login screen, select {Colors.GREEN}'Openbox'{Colors.NC} from session menu")
    print(f"  3. Login with your credentials")
    print()
    print_status("Or from terminal:", Colors.YELLOW)
    print(f"  Run {Colors.GREEN}'startx'{Colors.NC} (if no display manager is running)")
    print()
    print_status("━" * 60, Colors.YELLOW)
    print_status("Enjoy your new Nord-themed Openbox environment!", Colors.GREEN)
    print_status("━" * 60, Colors.YELLOW)
    print()

def main():
    """Main installation function"""
    print_status("Starting Fedora 43 Openbox Setup...", Colors.GREEN)
    print()
    
    # Check if running as root
    if os.geteuid() == 0:
        print_status("Please run this script as a regular user with sudo privileges, not as root!", Colors.RED)
        sys.exit(1)
    
    try:
        # Installation steps
        install_packages()
        install_polybar()
        setup_directory_structure()
        download_wallpaper()
        create_openbox_theme()
        create_openbox_config()
        create_openbox_autostart()
        create_openbox_menu()
        create_picom_config()
        create_polybar_config()
        create_rofi_config()
        create_alacritty_config()
        create_dunst_config()
        create_gtk_config()
        create_nitrogen_config()
        create_xinitrc()
        create_desktop_entry()
        
        # Print summary
        print_summary()
        
    except KeyboardInterrupt:
        print()
        print_status("Installation interrupted by user!", Colors.RED)
        sys.exit(1)
    except Exception as e:
        print_status(f"An error occurred: {e}", Colors.RED)
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()
