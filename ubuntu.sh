#!/bin/sh

# Debloat
# Remove the packages using apt and snap
sudo apt purge -y $(cat ubuntu-deblot.txt)
sudo snap remove snap-store
sudo snap remove firefox
sudo apt autoremove --purge -y

# Run Updates
# echo 'Make sure your system has been fully-updated by running "sudo apt update && sudo apt upgrade -y" and reboot it once.'
sudo apt update
sudo apt upgrade -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

# Setup Flathub
sudo apt install flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo

# Install things I need, top is uncategorized
FLATHUB=$(cat flathub-packages.txt)

# Install the packages using flatpak
flatpak install -y flathub $FLATHUB

# Games
# Install the packages using flatpak
flatpak install -y flathub $(cat flathub-games.txt)

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
# Install the packages using flatpak
flatpak install -y flathub-beta $(cat flathub-beta-packages.txt)

# appcenter (Elementery os)
# Install the packages using flatpak
flatpak install -y appcenter $(cat appcenter-packages.txt)

# Install things I need using apt, top is uncategorized
# Install the packages using apt
sudo apt install -y $(cat ubuntu-packages.txt)

sudo systemctl enable --now syncthing@$(whoami)

# Firewall
sudo apt install ufw -y
sudo ufw disable
sudo ufw allow ssh comment 'ssh'
sudo ufw allow 1714:1764/udp comment 'kde connect'
sudo ufw allow 1714:1764/tcp comment 'kde connect'
sudo ufw allow 631 comment 'cups'
sudo ufw allow 24872 comment 'suyu'
sudo ufw allow 47984/tcp comment 'moonlight'
sudo ufw allow 47989/tcp comment 'moonlight'
sudo ufw allow 48010/tcp comment 'moonlight'
sudo ufw allow 47998/udp comment 'moonlight'
sudo ufw allow 48000/udp comment 'moonlight'
sudo ufw allow 48002/udp comment 'moonlight'
sudo ufw allow 48010/udp comment 'moonlight'
sudo ufw allow 8384 comment "syncthing"
sudo ufw allow 137/udp comment "samba"
sudo ufw allow 138/udp comment "samba"
sudo ufw allow 139/tcp comment "samba"
sudo ufw allow 445/tcp comment "samba"
sudo ufw allow 27015/tcp comment "portal 1"
sudo ufw allow 27015/udp comment "portal 1"
sudo ufw allow 27040/tcp comment "steam network transfer" 
sudo ufw allow 27031/udp comment "steam client discovery"
sudo ufw allow 27032/udp comment "steam client discovery"
sudo ufw allow 27033/udp comment "steam client discovery"
sudo ufw allow 27034/udp comment "steam client discovery"
sudo ufw allow 27035/udp comment "steam client discovery"
sudo ufw allow 27036/udp comment "steam client discovery"
sudo ufw reload
sudo ufw enable

# Steaven Settings
cd ~
git clone https://github.com/SteavenGamerYT/SteavenSettings
cd SteavenSettings
./install.sh
cd ~

echo "The configuration is now complete."