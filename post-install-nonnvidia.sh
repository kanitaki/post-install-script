#!/bin/bash
echo;
echo "Set fastest mirror for DNF";
echo;
echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf && echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf && echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf && sudo dnf update -yq && sudo dnf autoremove -yq ;
echo;
echo "Installing needed groups...";
echo;
sudo dnf group install "base-x" "Common NetworkManager Submodules" "Standard" "Printing Support" "Core" "Fonts" "Hardware Support" "System Tools" "C Development Tools and Libraries" "Development Tools" "Sound and Video" -yq;
echo;
echo "Install the needed applications";
echo;
sudo dnf install slick-greeter xfce4-settings flatpak lightdm lightdm-gtk-greeter-settings cantata dunst picom rofi network-manager-applet papirus-icon-theme kde-connect nitrogen xscreensaver synapse polybar vim gvim tilix pcmanfm xbacklight xrandr openbox obconf dnfdragora -y --skip-broken;
echo;
echo "Install browser";
echo;
sudo dnf install dnf-plugins-core -y && sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/ && sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc && sudo dnf install brave-browser-beta -y;
echo;
echo "Installing hblock";
echo;
curl -o /tmp/hblock 'https://raw.githubusercontent.com/hectorm/hblock/v3.3.2/hblock' && echo '864160641823734378b69da7aa28477771e125af66cf47d5f0f7c8233ef1837f  /tmp/hblock' | shasum -c   && sudo mv /tmp/hblock /usr/local/bin/hblock   && sudo chown 0:0 /usr/local/bin/hblock   && sudo chmod 755 /usr/local/bin/hblock && hblock;
echo;
echo "Install Sublime";
echo;
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y  && sudo dnf install sublime-text -y;
echo;
"Install polybar themes";
echo;
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git && cd polybar-themes && chmod +x setup.sh && ./setup.sh && cd .. && rm -rf polybar-themes;
echo;
echo "Install flapak programs";
echo;
flatpak update && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install com.mojang.Minecraft com.notepadqq.Notepadqq com.visualstudio.code io.lmms.LMMS org.musescore.MuseScore com.obsproject.Studio com.uploadedlobster.peek org.kde.minuet net.xmind.XMind org.darktable.Darktable org.kde.krita libresprite pixelorama foliate pdfarranger gpuviewer antimicrox firmware pupgui2 wonderwall com.github.unrud.VideoDownloader Komikku rosegarden io.github.muse_sequencer.Muse -y;
echo;
echo "Install Heroic launcher";
echo;
sudo dnf copr enable atim/heroic-games-launcher -y && sudo dnf install heroic-games-launcher-bin -yq;
echo;
echo "Fix wine dependency issues";
sudo dnf install alsa-plugins-pulseaudio.i686 glibc-devel.i686 glibc-devel libgcc.i686 libX11-devel.i686 freetype-devel.i686 libXcursor-devel.i686 libXi-devel.i686 libXext-devel.i686 libXxf86vm-devel.i686 libXrandr-devel.i686 libXinerama-devel.i686 mesa-libGLU-devel.i686 mesa-libOSMesa-devel.i686 libXrender-devel.i686 libpcap-devel.i686 ncurses-devel.i686 libzip-devel.i686 lcms2-devel.i686 zlib-devel.i686 libv4l-devel.i686 libgphoto2-devel.i686 cups-devel.i686 libxml2-devel.i686 openldap-devel.i686 libxslt-devel.i686 gnutls-devel.i686 libpng-devel.i686 flac-libs.i686 json-c.i686 libICE.i686 libSM.i686 libXtst.i686 libasyncns.i686 liberation-narrow-fonts.noarch libieee1284.i686 libogg.i686 libsndfile.i686 libuuid.i686 libva.i686 libvorbis.i686 libwayland-client.i686 libwayland-server.i686 llvm-libs.i686 mesa-dri-drivers.i686 mesa-filesystem.i686 mesa-libEGL.i686 mesa-libgbm.i686 nss-mdns.i686 ocl-icd.i686 pulseaudio-libs.i686 sane-backends-libs.i686 tcp_wrappers-libs.i686 unixODBC.i686 samba-common-tools.x86_64 samba-libs.x86_64 samba-winbind.x86_64 samba-winbind-clients.x86_64 samba-winbind-modules.x86_64 mesa-libGL-devel.i686 fontconfig-devel.i686 libXcomposite-devel.i686 libtiff-devel.i686 openal-soft-devel.i686 mesa-libOpenCL-devel.i686 opencl-utils-devel.i686 alsa-lib-devel.i686 gsm-devel.i686 libjpeg-turbo-devel.i686 pulseaudio-libs-devel.i686 pulseaudio-libs-devel gtk3-devel.i686 libattr-devel.i686 libva-devel.i686 libexif-devel.i686 libexif.i686 glib2-devel.i686 mpg123-devel.i686 mpg123-devel.x86_64 libcom_err-devel.i686 libcom_err-devel.x86_64 libFAudio-devel.i686 libFAudio-devel.x86_64 dxvk-native wine-dxvk vulkan-loader vulkan-loader.i686 -yq --skip-broken;
echo;
echo "Add all the needed lines to the Openbox autostart file";
echo;
sudo mkdir ~/.config/openbox && touch ~/.config/openbox/autostart && echo "sleep 1 && nitrogen --restore &" >> ~/.config/openbox/autostart && echo "exec dunst &" >> ~/.config/openbox/autostart && echo "exec synapse &" >> ~/.config/openbox/autostart && echo "bash ~/.config/polybar/launch.sh --forest &" >> ~/.config/openbox/autostart && echo "xfsettingsd &" >> ~/.config/openbox/autostart && echo "xscreensaver &" >> ~/.config/openbox/autostart;
echo;
echo "Enable all the things";
echo;
sudo systemctl set-default graphical.target && sudo systemctl enable lightdm;
echo;
