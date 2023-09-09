#!/bin/sh

# Debloat
sudo apt purge libreoffice* eog network-manager-openvpn-gnome network-manager-openvpn openvpn gnome-calculator gnome-calendar gnome-characters cheese rhythmbox* remmina* transmission* shotwell* gnome-shell-extensions gnome-shell-extension-manager -y
sudo snap remove snap-store
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

# Install things I need, top is uncategorized
flatpak install -y flathub org.libreoffice.LibreOffice com.github.tchx84.Flatseal org.kde.krita org.mozilla.firefox com.brave.Browser  org.mozilla.Thunderbird com.vysp3r.ProtonPlus com.heroicgameslauncher.hgl com.valvesoftware.Steam org.gnome.Loupe org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/21.08 runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08 com.discordapp.Discord com.github.Matoking.protontricks com.ktechpit.whatsie  com.visualstudio.code im.riot.Riot io.github.shiftey.Desktop io.gitlab.jstest_gtk.jstest_gtk io.gitlab.news_flash.NewsFlash net.lutris.Lutris org.DolphinEmu.dolphin-emu org.atheme.audacious	 org.gnome.gitlab.cheywood.Iotas org.kde.kdenlive org.onlyoffice.desktopeditors org.prismlauncher.PrismLauncher org.qbittorrent.qBittorrent org.telegram.desktop org.videolan.VLC org.yuzu_emu.yuzu org.gnome.Calculator org.gnome.Calendar org.gnome.Characters org.gnome.Cheese cc.arduino.IDE2 com.mattjakeman.ExtensionManager

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
flatpak install -y flathub-beta org.gimp.GIMP

# APT
sudo apt install distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli nautilus-nextcloud nala ssh gnome-tweaks -y

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
sudo apt install ufw -y
sudo ufw allow ssh
sudo ufw enable 
echo "The configuration is now complete."

