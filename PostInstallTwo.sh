#!/bin/bash
echo "Enable COPR Repos";
sudo dnf copr enable dturner/TOS -y;
sudo dnf copr enable atim/heroic-games-launcher -y;
sudo dnf copr enable rmnscnce/amdctl -y;
sudo dnf copr enable arrobbins/JDSP4Linux -y;
sudo dnf update --refresh -yq;
echo;
echo "Install the needed applications";
echo;
sudo dnf install xfce4-settings obmenu-generator dunst picom rofi network-manager-applet papirus-icon-theme kde-connect nitrogen xscreensaver tint2 vim gvim alacritty pcmanfm xbacklight arandr openbox obconf jgmenu dnfdragora jamesdsp blueberry bluez-tools gnome-keyring mpv pasystray android-tools duf flameshot vim-powerline bleachbit fontawesome5-fonts-web fontawesome5-free-fonts material-icons-fonts material-icons-fonts -y --skip-broken;
echo;
echo "Install browser";
echo;
sudo dnf install dnf-plugins-core -y && sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ && sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc && sudo dnf install brave-browser -y;
echo;
echo "Installing hblock";
echo;
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.3.2/hblock' && echo '864160641823734378b69da7aa28477771e125af66cf47d5f0f7c8233ef1837f  /tmp/hblock' | shasum -c   && sudo mv /tmp/hblock /usr/local/bin/hblock   && sudo chown 0:0 /usr/local/bin/hblock   && sudo chmod 755 /usr/local/bin/hblock && hblock;
echo;
echo "Install Sublime";
echo;
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y  && sudo dnf install sublime-text -y;
echo;
echo "Installing asusd services";
echo;
sudo dnf copr enable lukenukem/asus-linux -y && sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm  -yq && sudo dnf update -yq && sudo dnf install kernel-devel -yq && sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power -yq && sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service && sudo dnf install asusctl supergfxctl -yq && sudo dnf update --refresh -q && sudo systemctl enable supergfxd.service ;
echo;
echo "Install flapak programs";
echo;
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install notepadqq gpuviewer antimicrox firmware pupgui2 com.github.unrud.VideoDownloader net.veloren.airshipper org.gnome.World.PikaBackup -y;
echo;
echo "Fix wine dependency issues";
echo;
sudo dnf install alsa-plugins-pulseaudio.i686 glibc-devel.i686 glibc-devel libgcc.i686 libX11-devel.i686 freetype-devel.i686 libXcursor-devel.i686 libXi-devel.i686 libXext-devel.i686 libXxf86vm-devel.i686 libXrandr-devel.i686 libXinerama-devel.i686 mesa-libGLU-devel.i686 mesa-libOSMesa-devel.i686 libXrender-devel.i686 libpcap-devel.i686 ncurses-devel.i686 libzip-devel.i686 lcms2-devel.i686 zlib-devel.i686 libv4l-devel.i686 libgphoto2-devel.i686 cups-devel.i686 libxml2-devel.i686 openldap-devel.i686 libxslt-devel.i686 gnutls-devel.i686 libpng-devel.i686 flac-libs.i686 json-c.i686 libICE.i686 libSM.i686 libXtst.i686 libasyncns.i686 liberation-narrow-fonts.noarch libieee1284.i686 libogg.i686 libsndfile.i686 libuuid.i686 libva.i686 libvorbis.i686 libwayland-client.i686 libwayland-server.i686 llvm-libs.i686 mesa-dri-drivers.i686 mesa-filesystem.i686 mesa-libEGL.i686 mesa-libgbm.i686 nss-mdns.i686 ocl-icd.i686 pulseaudio-libs.i686 sane-backends-libs.i686 tcp_wrappers-libs.i686 unixODBC.i686 samba-common-tools.x86_64 samba-libs.x86_64 samba-winbind.x86_64 samba-winbind-clients.x86_64 samba-winbind-modules.x86_64 mesa-libGL-devel.i686 fontconfig-devel.i686 libXcomposite-devel.i686 libtiff-devel.i686 openal-soft-devel.i686 mesa-libOpenCL-devel.i686 opencl-utils-devel.i686 alsa-lib-devel.i686 gsm-devel.i686 libjpeg-turbo-devel.i686 pulseaudio-libs-devel.i686 pulseaudio-libs-devel gtk3-devel.i686 libattr-devel.i686 libva-devel.i686 libexif-devel.i686 libexif.i686 glib2-devel.i686 mpg123-devel.i686 mpg123-devel.x86_64 libcom_err-devel.i686 libcom_err-devel.x86_64 libFAudio-devel.i686 libFAudio-devel.x86_64 dxvk-native wine-dxvk vulkan-loader vulkan-loader.i686 -y;
echo;
echo "Install lightdm and slick greeter";
echo;
sudo dnf install slick-greeter lightdm lightdm-gtk-greeter-settings -yq;
echo;
echo "Enable all the things";
echo;
sudo systemctl set-default graphical.target && sudo systemctl enable lightdm;
echo;
echo "Be sure to run 'sudo grub2-mkconfig -o /etc/grub2.cfg' after removing the duplicates from /etc/default/grub.";
