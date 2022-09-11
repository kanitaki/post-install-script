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
echo "Installing flatpak";
sudo dnf install flatpak -y;
echo;
echo "Run the second script after a reboot. Rebooting in 60 seconds."
sleep 60;
reboot;
