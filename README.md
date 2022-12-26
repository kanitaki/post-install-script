# post-install-script
Install Fedora packages to stand up a base install.

This is specific to an Asus Zephyrus G14(2020).

Includes several configurations/packages/fixes found at asus-linux.org.

SETUP NEEDED BEFORE RUNNING SCRIPTS:

 1) Download Fedora(Current version is recommended), its recommended to use either the Server ISO or the Everything ISO.

 2) Begin the installation, complete each 'cog', with the exception of the 'Software Selection'.
 
 3) Once everything else has been configured, under 'Software Selection', choose 'Minimal Install' from the left side
 
 4) On the right side, it may be necessary to choose 'Common NetworkManager Submodules', mileage may vary. 
 
 5) Complete the installation.
 
 6) Following the reboot, login, and install git:
 
   -#sudo dnf install git -y
   
 7) Clone this repository:
 
   -#git clone https://github.com/kanitaki/post-install-script
   
 8) Add the necessary execute bit:
 
   -#chmod -R +x post-install-script/*
   
 9) Move into the directory and run PostInstallOne.sh:
 
   -#cd post-install-script && sudo ./PostInstallOne.sh
   
 10) Reboot
   
 11) After the reboot, run the second script:
 
   -#cd post-install-script && sudo ./PostInstallTwo.sh
   
 12) Edit the /etc/default/grub file as noted in guide provided by asus-linux.org:
 
 "Edit the file to look like below. Note that if disk encryption was enabled during installation, there will be additional configuration text in the GRUB_CMDLINE_LINUX line that must be preserved.

GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=0 rhgb quiet"
GRUB_DISABLE_RECOVERY="true"
GRUB_ENABLE_BLSCFG=true"

 13) Rebuild initramfs:

  -#sudo grub2-mkconfig -o /etc/grub2.cfg
  
 14) Edit .config/openbox/autostart to include:
 
killall -9 nitrogen compton dunst rofi plank xfsettingsd nm-applet mpd flameshot
sleep 1 && nitrogen --restore &
exec picom &
exec dunst &
exec gnome-keyring &
xscreensaver &
exec plank &
exec tint2 &
exec xfsettingsd &
exec nm-applet &
exec flameshot &
exec pasystray &

 15) Reboot.
 
You should be met with a GUI login and default to openbox with a tint2 bar. 

I will add dotfiles for easier configuration at a later date.
