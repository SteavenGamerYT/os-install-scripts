#!/bin/sh

# Configure dnf (In order: automatically select fastest mirror, parallel downloads, and disable telemetry)
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf
# Setup RPMFusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf groupupdate core -y

# Debloat
sudo dnf -y remove anaconda* abrt* anthy-unicode bluez-cups brasero-libs trousers boost-date-time yelp orca fedora-bookmarks fedora-chromium-config mailcap open-vm-tools samba-client unbound-libs mediawriter firefox thermald NetworkManager-ssh sos kpartx dos2unix sssd cyrus-sasl-plain geolite2* traceroute gnome-themes-extra ModemManager tcpdump mozilla-filesystem nmap-ncat spice-vdagent eog gnome-text-editor evince cheese gnome-classic-session baobab gnome-calculator gnome-characters gnome-font-viewer gnome-font-viewer simple-scan evince-djvu gnome-tour gnome-shell-extension* gnome-weather gnome-boxes gnome-clocks gnome-contacts gnome-tour gnome-logs gnome-remote-desktop totem gnome-calendar gnome-shell-extension-background-logo gnome-maps gnome-backgrounds gnome-connections gnome-user-docs gnome-color-manager perl-IO-Socket-SSL adcli mtr realmd teamd vpnc openconnect openvpn ppp pptp qgnomeplatform rsync xorg-x11-drv-vmware hyperv* virtualbox-guest-additions qemu-guest-agent 
sudo dnf autoremove -y

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

# Setup Flatpak and Snaps and third party packages
sudo fedora-third-party enable
sudo fedora-third-party refresh
sudo dnf install flatpak snapd -y
sudo ln -s /var/lib/snapd/snap /snap
flatpak remote-delete fedora
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak remote-add --if-not-exists appcenter https://flatpak.elementary.io/repo.flatpakrepo

# Install things I need, top is uncategorized
FLATHUB=$(cat flathub-packages.txt)

# Install the packages using flatpak
for PACKAGE in $FLATHUB; do
  flatpak install -y flathub $FLATHUB
done

# Games
flatpak install -y org.libretro.RetroArch net.rpcs3.RPCS3 org.ppsspp.PPSSPP org.duckstation.DuckStation org.citra_emu.citra net.kuribo64.melonDS app.xemu.xemu net.brinkervii.grapejuice com.moonlight_stream.Moonlight net.pcsx2.PCSX2 com.mojang.Minecraft io.mrarm.mcpelauncher com.parsecgaming.parsec info.cemu.Cemu org.supertuxproject.SuperTux io.itch.itch dev.lizardbyte.app.Sunshine com.vysp3r.ProtonPlus com.heroicgameslauncher.hgl com.valvesoftware.Steam runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/21.08 runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08 com.github.Matoking.protontricks net.lutris.Lutris org.DolphinEmu.dolphin-emu org.prismlauncher.PrismLauncher io.gitlab.jstest_gtk.jstest_gtk org.yuzu_emu.yuzu

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
FLATHUBBETA=$(cat flathub-beta-packages.txt)

# Install the packages using flatpak
for PACKAGE in $FLATHUBBETA; do
  flatpak install -y flathub-beta $FLATHUBBETA
done

# appcenter (Elementery os)
appcenter=$(cat appcenter-packages.txt)

# Install the packages using flatpak
for PACKAGE in $appcenter; do
  flatpak install -y appcenter $appcenter
done

# dnf
sudo dnf install -y distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli openssh-server adw-gtk3-theme gnome-tweaks ostree libappstream-glib hplip hplip-gui bleachbit baobab google-roboto-condensed-fonts google-roboto-mono-fonts google-roboto-slab-fonts google-roboto-fonts roboto-fontface-fonts google-noto-sans-arabic-fonts google-noto-naskh-arabic-fonts google-noto-naskh-arabic-ui-fonts google-noto-naskh-arabic-ui-vf-fonts google-noto-naskh-arabic-vf-fonts google-noto-sans-arabic-vf-fonts google-noto-cjk-fonts google-noto-emoji-fonts ubuntu-fonts
# Fedora Copr Repos for more apps
sudo dnf copr enable gombosg/better_fonts -y
sudo dnf install fontconfig-font-replacements fontconfig-enhanced-defaults -y
sudo dnf copr enable atim/starship -y
sudo dnf install starship -y

# Snaps
sudo snap install yt-dlp

# Fixing Flatpak permsision Issues
sudo flatpak override --filesystem=~/.themes
sudo flatpak override --filesystem=~/.icons
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
sudo flatpak override --filesystem=xdg-config/qt5ct:ro
sudo flatpak override --filesystem=xdg-config/qt6ct:ro
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --filesystem=xdg-config/fontconfig:ro
sudo flatpak override --env=XCURSOR_PATH=/run/host/user-share/icons:/run/host/share/icons

# Firewall
sudo dnf remove firewalld* -y
sudo dnf install ufw -y
sudo ufw allow ssh
sudo ufw allow 1714:1764/udp
sudo ufw allow 1714:1764/tcp
# cups
sudo ufw allow 631
# yuzu
sudo ufw allow 24872
# moonlight
sudo ufw allow 47984/tcp
sudo ufw allow 47989/tcp
sudo ufw allow 48010/tcp
sudo ufw allow 47998/udp
sudo ufw allow 48000/udp
sudo ufw allow 48002/udp
sudo ufw allow 48010/udp
sudo ufw reload
sudo ufw enable

# Enable Kicksecure CPU mitigations
sudo curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_cpu_mitigations.cfg -o /etc/grub.d/40_cpu_mitigations.cfg
# Kicksecure's CPU distrust script
sudo curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_distrust_cpu.cfg -o /etc/grub.d/40_distrust_cpu.cfg
# Enable Kicksecure's IOMMU patch (limits DMA)
sudo curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_enable_iommu.cfg -o /etc/grub.d/40_enable_iommu.cfg

# GrapheneOS's ssh limits
# caps the system usage of sshd
sudo mkdir -p /etc/systemd/system/sshd.service.d
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/systemd/system/sshd.service.d/local.conf -o /etc/systemd/system/sshd.service.d/local.conf

# NTS instead of NTP
# NTS is a more secured version of NTP
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf


# Arduino
echo "SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"" | sudo tee -a /etc/udev/rules.d/99-arduino.rules
sudo usermod -a -G dialout $USER

# Sunshine
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | \
sudo tee /etc/udev/rules.d/85-sunshine.rules

echo "The configuration is now complete."
