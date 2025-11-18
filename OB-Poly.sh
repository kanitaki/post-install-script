#!/bin/bash
# Openbox Nord Aurora Theme Configuration Script
# Standalone script to configure Openbox with Nord theme

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Openbox Nord Aurora Theme Configuration      ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Create directory structure
echo -e "${YELLOW}Creating Openbox directories...${NC}"
mkdir -p ~/.config/openbox
mkdir -p ~/.themes/Nord/openbox-3
mkdir -p ~/.config/picom

# Create Nord Openbox Theme
echo -e "${YELLOW}Creating Nord Openbox theme...${NC}"
cat > ~/.themes/Nord/openbox-3/themerc << 'EOF'
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

# OSD (On-Screen Display)
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
EOF

echo -e "${GREEN}✓ Nord theme created${NC}"

# Create Openbox rc.xml configuration
echo -e "${YELLOW}Creating Openbox configuration (rc.xml)...${NC}"
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
    <raiseOnFocus>no</raiseOnFocus>
    <focusLast>yes</focusLast>
    <underMouse>no</underMouse>
  </focus>
  <placement>
    <policy>Smart</policy>
    <center>yes</center>
    <monitor>Primary</monitor>
    <primaryMonitor>1</primaryMonitor>
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
  <resize>
    <drawContents>yes</drawContents>
    <popupShow>Nonpixel</popupShow>
    <popupPosition>Center</popupPosition>
    <popupFixedPosition>
      <x>10</x>
      <y>10</y>
    </popupFixedPosition>
  </resize>
  <margins>
    <top>0</top>
    <bottom>0</bottom>
    <left>0</left>
    <right>0</right>
  </margins>
  <keyboard>
    <chainQuitKey>C-g</chainQuitKey>
    
    <!-- Terminal -->
    <keybind key="W-Return">
      <action name="Execute">
        <command>alacritty</command>
      </action>
    </keybind>
    
    <!-- Rofi Launchers -->
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
    
    <!-- Custom Rofi Menus -->
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
    
    <!-- Window Management -->
    <keybind key="W-q">
      <action name="Close"/>
    </keybind>
    
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
    
    <keybind key="W-f">
      <action name="ToggleMaximize"/>
    </keybind>
    
    <keybind key="W-h">
      <action name="ToggleShade"/>
    </keybind>
    
    <keybind key="W-m">
      <action name="Iconify"/>
    </keybind>
    
    <!-- Screenshot -->
    <keybind key="Print">
      <action name="Execute">
        <command>scrot ~/Pictures/screenshot_%Y-%m-%d_%H-%M-%S.png</command>
      </action>
    </keybind>
    
    <keybind key="S-Print">
      <action name="Execute">
        <command>scrot -s ~/Pictures/screenshot_%Y-%m-%d_%H-%M-%S.png</command>
      </action>
    </keybind>
    
    <!-- Workspace Navigation -->
    <keybind key="W-1">
      <action name="GoToDesktop">
        <to>1</to>
      </action>
    </keybind>
    <keybind key="W-2">
      <action name="GoToDesktop">
        <to>2</to>
      </action>
    </keybind>
    <keybind key="W-3">
      <action name="GoToDesktop">
        <to>3</to>
      </action>
    </keybind>
    <keybind key="W-4">
      <action name="GoToDesktop">
        <to>4</to>
      </action>
    </keybind>
    
    <!-- Send Window to Workspace -->
    <keybind key="W-S-1">
      <action name="SendToDesktop">
        <to>1</to>
      </action>
    </keybind>
    <keybind key="W-S-2">
      <action name="SendToDesktop">
        <to>2</to>
      </action>
    </keybind>
    <keybind key="W-S-3">
      <action name="SendToDesktop">
        <to>3</to>
      </action>
    </keybind>
    <keybind key="W-S-4">
      <action name="SendToDesktop">
        <to>4</to>
      </action>
    </keybind>
    
    <!-- Cycle Windows -->
    <keybind key="A-Tab">
      <action name="NextWindow">
        <finalactions>
          <action name="Focus"/>
          <action name="Raise"/>
          <action name="Unshade"/>
        </finalactions>
      </action>
    </keybind>
    
    <keybind key="A-S-Tab">
      <action name="PreviousWindow">
        <finalactions>
          <action name="Focus"/>
          <action name="Raise"/>
          <action name="Unshade"/>
        </finalactions>
      </action>
    </keybind>
  </keyboard>
  
  <mouse>
    <dragThreshold>8</dragThreshold>
    <doubleClickTime>200</doubleClickTime>
    <screenEdgeWarpTime>400</screenEdgeWarpTime>
    
    <context name="Frame">
      <mousebind button="A-Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="A-Left" action="Click">
        <action name="Unshade"/>
      </mousebind>
      <mousebind button="A-Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      
      <mousebind button="A-Right" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
        <action name="Unshade"/>
      </mousebind>
      <mousebind button="A-Right" action="Drag">
        <action name="Resize"/>
      </mousebind>
      
      <mousebind button="A-Middle" action="Press">
        <action name="Lower"/>
        <action name="FocusToBottom"/>
        <action name="Unfocus"/>
      </mousebind>
    </context>
    
    <context name="Titlebar">
      <mousebind button="Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
      </mousebind>
      <mousebind button="Left" action="Drag">
        <action name="Move"/>
      </mousebind>
      <mousebind button="Left" action="DoubleClick">
        <action name="ToggleMaximize"/>
      </mousebind>
      
      <mousebind button="Middle" action="Press">
        <action name="Lower"/>
        <action name="FocusToBottom"/>
        <action name="Unfocus"/>
      </mousebind>
      
      <mousebind button="Right" action="Press">
        <action name="ShowMenu">
          <menu>client-menu</menu>
        </action>
      </mousebind>
    </context>
    
    <context name="Top">
      <mousebind button="Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
        <action name="Unshade"/>
      </mousebind>
      <mousebind button="Left" action="Drag">
        <action name="Resize">
          <edge>top</edge>
        </action>
      </mousebind>
    </context>
    
    <context name="Icon">
      <mousebind button="Left" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
        <action name="Unshade"/>
        <action name="ShowMenu">
          <menu>client-menu</menu>
        </action>
      </mousebind>
      <mousebind button="Right" action="Press">
        <action name="Focus"/>
        <action name="Raise"/>
        <action name="ShowMenu">
          <menu>client-menu</menu>
        </action>
      </mousebind>
    </context>
    
    <context name="Desktop">
      <mousebind button="Right" action="Press">
        <action name="ShowMenu">
          <menu>root-menu</menu>
        </action>
      </mousebind>
    </context>
  </mouse>
  
  <menu>
    <file>menu.xml</file>
    <hideDelay>200</hideDelay>
    <middle>no</middle>
    <submenuShowDelay>100</submenuShowDelay>
    <applicationIcons>yes</applicationIcons>
    <manageDesktops>yes</manageDesktops>
  </menu>
  
  <applications>
    <!-- Example: Firefox always on workspace 2 -->
    <!--
    <application name="firefox">
      <desktop>2</desktop>
    </application>
    -->
  </applications>
</openbox_config>
EOF

echo -e "${GREEN}✓ Openbox configuration created${NC}"

# Create Openbox menu
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

echo -e "${GREEN}✓ Openbox menu created${NC}"

# Create Openbox autostart
echo -e "${YELLOW}Creating Openbox autostart script...${NC}"
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

# Volume icon in system tray
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
echo -e "${GREEN}✓ Openbox autostart script created${NC}"

# Create Picom configuration
echo -e "${YELLOW}Creating Picom compositor configuration...${NC}"
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

echo -e "${GREEN}✓ Picom configuration created${NC}"

# Reconfigure Openbox if it's running
if pgrep -x "openbox" > /dev/null; then
    echo -e "${YELLOW}Reconfiguring Openbox...${NC}"
    openbox --reconfigure
    echo -e "${GREEN}✓ Openbox reconfigured${NC}"
fi

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          Configuration Complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Created files:${NC}"
echo "  • ~/.themes/Nord/openbox-3/themerc"
echo "  • ~/.config/openbox/rc.xml"
echo "  • ~/.config/openbox/menu.xml"
echo "  • ~/.config/openbox/autostart"
echo "  • ~/.config/picom/picom.conf"
echo ""
echo -e "${YELLOW}To apply changes:${NC}"
echo "  • If Openbox is running: Already reconfigured!"
echo "  • If not running: Start Openbox session"
echo "  • Or run: ${GREEN}openbox --reconfigure${NC}"
echo ""
