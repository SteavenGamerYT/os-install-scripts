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
yay -Syu --noconfirm --needed $(cat core-packages.txt)
yay -Syu --noconfirm --needed $(cat printer-packages.txt)
yay -Syu --noconfirm --needed $(cat personal-packages.txt)
yay -Syu --noconfirm --needed $(cat i3-packages.txt)
yay -Syu --noconfirm --needed ttf-ms-win11-auto

# Flathub
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepove
sudo flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo

# Systemctl
sudo systemctl enable sddm
sudo systemctl enable --now cups
sudo systemctl enable --now cups-browsed

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
flatpak install -y flathub $(cat ../flathub-packages.txt)

# Games
# Install the packages using flatpak
flatpak install -y flathub $(cat ../flathub-games.txt)

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
# Install the packages using flatpak
flatpak install -y flathub-beta $(cat ../flathub-beta-packages.txt)

# appcenter (Elementery os)
# Install the packages using flatpak
flatpak install -y appcenter $(cat ../appcenter-packages.txt)

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

# Enable Kicksecure CPU mitigations + Kicksecure's CPU distrust script + Kicksecure's IOMMU patch (limits DMA)
find /boot/loader/entries -type f ! -name "*fallback*" -exec grep -q 'options' {} \; -exec  sudo sed -i "s/options.*/& spectre_v2=on spec_store_bypass_disable=on l1tf=full,force mds=full,nosmt tsx=off tsx_async_abort=full,nosmt kvm.nx_huge_pages=force nosmt=force l1d_flush=on mmio_stale_data=full,nosmt random.trust_cpu=off intel_iommu=on amd_iommu=on efi=disable_early_pci_dma iommu.passthrough=0 iommu.strict=1/" {} +

# Steaven Settings
cd ~
git clone https://github.com/SteavenGamerYT/SteavenSettings
cd SteavenSettings
./install.sh
cd ~

echo "The configuration is now complete."