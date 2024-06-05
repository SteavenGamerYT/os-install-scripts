#!/bin/sh

# AUR HELPER PLS PLS PLS STOP USING PACMAN USE YAY
sudo pacman -Syu --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin/ && makepkg -si --noconfirm

# Swap 
sudo truncate -s 0 /swapfile
sudo chattr +C /swapfile
sudo fallocate -l 16G /swapfile
sudo chmod 0600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "# Swap" | sudo tee -a /etc/fstab
echo "/swapfile        none        swap        defaults      0 0" | sudo tee -a /etc/fstab

# Hibernation
find /boot/loader/entries -type f ! -name "*fallback*" -exec grep -q 'options' {} \; -exec  sudo sed -i "s/options.*/& resume_offset=$(sudo btrfs inspect-internal map-swapfile -r \/swapfile)/" {} +
diskuuid=$(eval $(lsblk -oMOUNTPOINT,UUID  -P -M | grep 'MOUNTPOINT="/"'); echo $UUID )
find /boot/loader/entries -type f ! -name "*fallback*" -exec grep -q 'options' {} \; -exec  sudo sed -i "s/options.*/& resume=UUID=$(echo $diskuuid)/" {} +
sudo sed -i 's/\(HOOKS=.*filesystems\) \(fsck.*\)/\1 resume \2/' /etc/mkinitcpio.conf
sudo mkinitcpio -P

# Packages
yay -Syu --noconfirm --needed pipewire lib32-pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack gnome-shell gnome-session gnome-control-center gdm gnome-tweaks xdg-desktop-portal xdg-desktop-portal-gnome gnome-keyring gnome-terminal adwaita-qt5-git adwaita-qt6-git qt5ct qt6ct adw-gtk-theme flatpak snapd cups foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds hplip hpuld hplip-plugin epson-inkjet-printer-escpr2 epson-inkjet-printer-escpr2 epson-inkjet-printer-escpr distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli nextcloud-client openssh hplip ufw nano iio-sensor-proxy dconf ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family noto-fonts-cjk noto-fonts-emoji noto-fonts xdg-user-dirs nautilus power-profiles-daemon starship shell-color-scripts ttf-meslo-nerd-font-powerlevel10k ttf-croscore ttf-fira-code ttf-firacode-nerd ttf-hack ttf-meslo ttf-meslo-nerd terminus-font ttf-ubuntu-mono-nerd gstreamer gst-libav gst-plugins-bad  gst-plugins-base gst-plugins-good  gst-plugins-ugly gst-plugins-ugly libde265 gst-plugin-openh264 nautilus-checksums nautilus-code webcord ttf-roboto-mono-nerd p7zip file-roller unrar unzip zip unace lrzip gnome-disk-utility gnome-system-monitor gparted dosfstools jfsutils f2fs-tools btrfs-progs exfatprogs ntfs-3g reiserfsprogs udftools xfsprogs nilfs-utils gpart mtools aic94xx-firmware linux-firmware-qlogic wd719x-firmware upd72020x-fw epson-printer-utility qt4-bin packagekit gnome-software-packagekit-plugin fwupd vlc-git touchegg kvantum-theme-libadwaita-git kvantum ffmpegthumbnailer gvfs-smb xf86-video-intel vulkan-intel lib32-vulkan-intel intel-media-driver wine-gecko wine-mono winetricks wine-staging goverlay mangohud gamemode lib32-gamemode qemu-desktop libvirt edk2-ovmf virt-manager dnsmasq usbutils speech-dispatcher wget jre17-openjdk jre8-openjdk bleachbit nautilus-image-converter popcorntime-bin hunspell-ar python-pyqt5 baobab vim neovim system-config-printer
yay -Syu --noconfirm --needed ttf-ms-win11-auto

# Flathub
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepove
sudo flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo

# Systemctl
sudo systemctl enable gdm
sudo systemctl enable --now cups
sudo systemctl enable --now cups-browsed
sudo systemctl enable --now ecbd.service
sudo systemctl enable --now touchegg

# Initialize virtualization
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf
sudo usermod -aG libvirt "$(whoami)"
sudo systemctl enable libvirtd --now
sudo virsh net-autostart default
sudo virsh net-start default


# Add user to some groups 
sudo usermod -a -G uucp,lp $USER

# Install things I need, top is uncategorized
# Install the packages using flatpak
flatpak install -y flathub $(cat flathub-packages.txt)

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

# Some Configs
# Locales
sudo sed -i 's/#ar_EG.UTF-8 UTF-8/ar_EG.UTF-8 UTF-8/' /etc/locale.gen
sudo sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

# Firewall
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

# gnome
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
echo "--enable-features=WaylandWindowDecorations" | tee -a ~/.config/electron25-flags.conf
echo "--ozone-platform-hint=auto" | tee -a ~/.config/electron25-flags.conf
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Shift><Super>S','Print']"

# Omar-Share
echo "# Omar-share" | sudo tee -a /etc/fstab
echo "//192.168.1.31/omar-share2 /media/omar-share2 cifs username=omarhanykasban,password=omargamer1234,rw,nounix,iocharset=utf8,file_mode=0777,dir_mode=0777,nofail 0 0" | sudo tee -a /etc/fstab
echo "//192.168.1.31/omar-share /media/omar-share cifs username=omarhanykasban,password=omargamer1234,rw,nounix,iocharset=utf8,file_mode=0777,dir_mode=0777,nofail 0 0" | sudo tee -a /etc/fstab

# Enable Kicksecure CPU mitigations + Kicksecure's CPU distrust script + Kicksecure's IOMMU patch (limits DMA)
find /boot/loader/entries -type f ! -name "*fallback*" -exec grep -q 'options' {} \; -exec  sudo sed -i "s/options.*/& spectre_v2=on spec_store_bypass_disable=on l1tf=full,force mds=full,nosmt tsx=off tsx_async_abort=full,nosmt kvm.nx_huge_pages=force nosmt=force l1d_flush=on mmio_stale_data=full,nosmt random.trust_cpu=off intel_iommu=on amd_iommu=on efi=disable_early_pci_dma iommu.passthrough=0 iommu.strict=1/" {} +

# GrapheneOS's ssh limits
# caps the system usage of sshd
sudo mkdir -p /etc/systemd/system/sshd.service.d
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/systemd/system/sshd.service.d/local.conf -o /etc/systemd/system/sshd.service.d/local.conf

# NTS instead of NTP
# NTS is a more secured version of NTP
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf


echo "The configuration is now complete."