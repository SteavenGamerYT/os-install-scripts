#!/bin/sh

# Configure dnf (In order: automatically select fastest mirror, parallel downloads, and disable telemetry)
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
echo "fastestmirror=1" | sudo tee -a /etc/dnf/dnf.conf
# Setup RPMFusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
sudo dnf groupupdate core -y

# Debloat
sudo dnf remove -y anaconda* abrt* anthy-unicode avahi bluez-cups brasero-libs trousers boost-date-time yelp orca fedora-bookmarks fedora-chromium-config mailcap open-vm-tools samba-client unbound-libs yajl mediawriter firefox sane* perl* thermald NetworkManager-ssh sos kpartx dos2unix sssd cyrus-sasl-plain geolite2* traceroute gnome-themes-extra ModemManager tcpdump mozilla-filesystem nmap-ncat spice-vdagent eog gnome-text-editorevince cheese gnome-classic-session baobab gnome-calculator gnome-characters gnome-system-monitor gnome-font-viewer gnome-font-viewer simple-scan evince-djvu gnome-tour gnome-shell-extension* gnome-weather gnome-boxes gnome-clocks gnome-contacts gnome-tour gnome-logs gnome-remote-desktop totem gnome-calendar gnome-shell-extension-background-logo gnome-maps gnome-backgrounds gnome-software gnome-connections gnome-user-docs gnome-color-manager perl-IO-Socket-SSL adcli mtr realmd teamd vpnc openconnect openvpn ppp pptp qgnomeplatform rsync xorg-x11-drv-vmware hyperv* virtualbox-guest-additions qemu-guest-agent 
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

# Setup Flathub beta and third party packages
sudo fedora-third-party enable
sudo fedora-third-party refresh
flatpak remote-delete fedora
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Install things I need, top is uncategorized
flatpak install -y flathub org.libreoffice.LibreOffice com.github.tchx84.Flatseal org.kde.krita org.mozilla.firefox com.brave.Browser  org.mozilla.Thunderbird com.vysp3r.ProtonPlus com.heroicgameslauncher.hgl com.valvesoftware.Steam org.gnome.Loupe org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/21.08 runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08 com.discordapp.Discord com.github.Matoking.protontricks com.ktechpit.whatsie  com.visualstudio.code im.riot.Riot io.github.shiftey.Desktop io.gitlab.jstest_gtk.jstest_gtk io.gitlab.news_flash.NewsFlash net.lutris.Lutris org.DolphinEmu.dolphin-emu org.atheme.audacious	 org.gnome.gitlab.cheywood.Iotas org.kde.kdenlive org.onlyoffice.desktopeditors org.prismlauncher.PrismLauncher org.qbittorrent.qBittorrent org.telegram.desktop org.videolan.VLC org.yuzu_emu.yuzu org.gnome.Calculator org.gnome.Calendar org.gnome.Characters org.gnome.Cheese cc.arduino.IDE2 com.mattjakeman.ExtensionManager

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
flatpak install -y flathub-beta org.gimp.GIMP

# dnf
sudo dnf install distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli nextcloud-client openssh-server adw-gtk3-theme gnome-tweaks ostree libappstream-glib -y
# Fedora Copr Repos for more apps
sudo dnf copr enable gombosg/better_fonts -y
sudo dnf install fontconfig-font-replacements fontconfig-enhanced-defaults -y
sudo dnf copr enable atim/starship -y
sudo dnf install starship -y

# Fixing Flatpak permsision Issues
sudo flatpak override --filesystem=~/.themes
sudo flatpak override --filesystem=~/.icons
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
sudo flatpak override --filesystem=xdg-config/qt5ct:ro
sudo flatpak override --filesystem=xdg-config/qt6ct:ro
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --filesystem=xdg-config/fontconfig:ro
sudo flatpak override --filesystem=xdg-config/MangoHud:ro

# Firewall
sudo dnf remove firewalld* -y
sudo dnf install ufw -y
sudo ufw allow ssh
sudo ufw enable 

# Arduino
echo "SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"" | sudo tee -a /etc/udev/rules.d/99-arduino.rules
sudo usermod -a -G dialout $USER

echo "The configuration is now complete."

