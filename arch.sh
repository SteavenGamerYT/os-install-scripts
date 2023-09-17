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
yay -Syu --noconfirm --needed pipewire lib32-pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack gnome-shell gnome-session gnome-control-center gdm gnome-tweaks xdg-desktop-portal xdg-desktop-portal-gnome gnome-keyrring gnome-terminal adwaita-qt5-git adwaita-qt6-git qt5ct qt6ct adw-gtk-theme flatpak snapd cups foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds simple-scan hplip hpoj hpuld hplip-plugin epson-inkjet-printer-escpr2 epson-inkjet-printer-escpr2 epson-inkjet-printer-201601w distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli nextcloud-client openssh hplip hplip-gui ufw nano iio-sensor-proxy dconf ttf-roboto ttf-roboto-mono ttf-ubuntu-font-family noto-fonts-cjk noto-fonts-emoji noto-fonts xdg-user-dirs nautilus power-profiles-daemon starship shell-color-scripts ttf-meslo-nerd-font-powerlevel10k ttf-croscore ttf-fira-code ttf-firacode-nerd ttf-hack ttf-meslo ttf-meslo-nerd terminus-font ttf-ubuntu-mono-nerd gstreamer gst-libav gst-plugins-bad  gst-plugins-base gst-plugins-good  gst-plugins-ugly gst-plugins-ugly libde265 gst-plugin-openh264 nautilus-checksums nautilus-code nautilus-columns
yay -Syu --noconfirm --needed ttf-ms-win11-auto

# Flathub
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo

# Systemctl
sudo systemctl enable gdm
sudo systemctl enable --now snapd.socket
sudo systemctl enable cups --now
sudo systemctl enable cups-browsed --now

# LN
sudo ln -s /var/lib/snapd/snap /snap

# echo
echo "export QT_QPA_PLATFORMTHEME=qt5ct" | sudo tee -a /etc/environment
echo "SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", GROUP="plugdev", MODE="0666"" | sudo tee -a /etc/udev/rules.d/99-arduino.rules
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | \
sudo tee /etc/udev/rules.d/85-sunshine.rules

# Add user to some groups 
sudo usermod -a -G uucp,lp $USER
# Flatpak and snaps
flatpak install -y flathub org.libreoffice.LibreOffice com.github.tchx84.Flatseal org.kde.krita org.mozilla.firefox com.brave.Browser  org.mozilla.Thunderbird org.gnome.Loupe org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio com.discordapp.Discord com.ktechpit.whatsie  com.visualstudio.code im.riot.Riot io.github.shiftey.Desktop  io.gitlab.news_flash.NewsFlash org.atheme.audacious org.gnome.gitlab.cheywood.Iotas org.kde.kdenlive org.onlyoffice.desktopeditors org.qbittorrent.qBittorrent org.telegram.desktop org.videolan.VLC org.gnome.Calculator org.gnome.Calendar org.gnome.Characters org.gnome.Cheese cc.arduino.IDE2 com.mattjakeman.ExtensionManager io.github.celluloid_player.Celluloid de.haeckerfelix.Shortwave io.github.seadve.Mousai org.gustavoperedo.FontDownloader com.github.huluti.Curtail org.gnome.gitlab.YaLTeR.Identity com.rafaelmardojai.Blanket fr.romainvigier.MetadataCleaner com.unity.UnityHub org.nickvision.tagger org.nickvision.tubeconverter io.github.Bavarder.Bavarder org.gnome.SimpleScan org.gnome.Evince com.notepadqq.Notepadqq org.gnome.baobab org.gnome.font-viewer
flatpak install -y org.libretro.RetroArch net.rpcs3.RPCS3 org.ppsspp.PPSSPP org.duckstation.DuckStation org.citra_emu.citra net.kuribo64.melonDS app.xemu.xemu net.brinkervii.grapejuice com.moonlight_stream.Moonlight net.pcsx2.PCSX2 com.mojang.Minecraft io.mrarm.mcpelauncher com.parsecgaming.parsec info.cemu.Cemu org.supertuxproject.SuperTux io.itch.itch dev.lizardbyte.app.Sunshine com.vysp3r.ProtonPlus com.heroicgameslauncher.hgl com.valvesoftware.Steam runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/21.08 runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08 com.github.Matoking.protontricks net.lutris.Lutris org.DolphinEmu.dolphin-emu org.prismlauncher.PrismLauncher io.gitlab.jstest_gtk.jstest_gtk org.yuzu_emu.yuzu
flatpak install -y flathub-beta org.gimp.GIMP
sudo snap install yt-dlp

# Some Configs
sudo flatpak override --filesystem=~/.themes
sudo flatpak override --filesystem=~/.icons
sudo flatpak override --filesystem=xdg-config/gtk-3.0:ro
sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro
sudo flatpak override --filesystem=xdg-config/qt5ct:ro
sudo flatpak override --filesystem=xdg-config/qt6ct:ro
sudo flatpak override --filesystem=xdg-config/Kvantum:ro
sudo flatpak override --filesystem=xdg-config/fontconfig:ro
sudo flatpak override --filesystem=xdg-config/MangoHud:ro
sudo ufw allow ssh
sudo ufw enable 
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

# GrapheneOS's ssh limits
# caps the system usage of sshd
sudo mkdir -p /etc/systemd/system/sshd.service.d
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/systemd/system/sshd.service.d/local.conf -o /etc/systemd/system/sshd.service.d/local.conf

# NTS instead of NTP
# NTS is a more secured version of NTP
sudo curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf -o /etc/chrony.conf


echo "The configuration is now complete."