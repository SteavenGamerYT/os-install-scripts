#!/bin/sh

# Configure dnf (In order: automatically select fastest mirror, parallel downloads, and disable telemetry)
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf
# Setup RPMFusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf groupupdate core -y

# Debloat
# Remove the packages using dnf
sudo dnf remove -y $(cat fedora-deblot.txt)

# Run Updates
# echo 'Make sure your system has been fully-updated by running "sudo dnf upgrade -y" and reboot it once.'
sudo dnf upgrade -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

# Configure GNOME
sudo mkdir -p /etc/dconf/profile
sudo mkdir -p /etc/dconf/db/local.d
sudo mkdir -p /etc/dconf/db/locks
echo "user-db:user" | sudo tee -a /etc/dconf/profile/user
echo "system-db:local" | sudo tee -a /etc/dconf/profile/user
echo "[org/gnome/mutter]" | sudo tee -a /etc/dconf/db/local.d/00-hidpi
echo "experimental-features=['scale-monitor-framebuffer']" | sudo tee -a /etc/dconf/db/local.d/00-hidpi
echo "/org/gnome/mutter/experimental-features" | sudo tee -a /etc/dconf/db/locks/hidpi
sudo dconf update
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true

# Setup Flatpak and Snaps and third party packages
sudo fedora-third-party enable
sudo fedora-third-party refresh
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

# Install things I need using dnf, top is uncategorized
# Install the packages using dnf
sudo dnf install -y $(cat fedora-packages.txt)


# Fedora Copr Repos for more apps
sudo dnf copr enable gombosg/better_fonts -y
sudo dnf install fontconfig-font-replacements fontconfig-enhanced-defaults -y
sudo dnf copr enable atim/starship -y
sudo dnf install starship -y

sudo systemctl enable --now syncthing@$(whoami)

# Firewall
sudo dnf remove firewalld* -y
sudo dnf install ufw -y
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