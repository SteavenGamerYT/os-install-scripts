#!/bin/sh

# AUR HELPER PLS PLS PLS STOP USING PACMAN USE YAY
sudo pacman -Syu --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin/ && makepkg -si --noconfirm


# Run Updates
# echo 'Make sure your system has been fully-updated by running "sudo apt update && sudo apt upgrade -y" and reboot it once.'
yay -Syu --noconfirm --needed
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates -y
sudo fwupdmgr update -y

# Setup Flatpak + Snaps
yay -S flatpak snapd
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

# Setup Gnome and GDM
yay -S gnome-shell gnome-session gnome-control-center gnome-tweaks
sudo systemctl enable gdm

# Setup Printer
yay -Syu --noconfirm --needed cups foomatic-db-engine foomatic-db foomatic-db-ppds foomatic-db-nonfree foomatic-db-nonfree-ppds gutenprint foomatic-db-gutenprint-ppds simple-scan hplip hpoj hpuld hplip-plugin epson-inkjet-printer-escpr2 epson-inkjet-printer-escpr2 epson-inkjet-printer-201601w
sudo systemctl enable cups --now
sudo systemctl enable cups-browsed --now

# Install things I need, top is uncategorized
flatpak install -y flathub org.libreoffice.LibreOffice com.github.tchx84.Flatseal org.kde.krita org.mozilla.firefox com.brave.Browser  org.mozilla.Thunderbird org.gnome.Loupe org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.OBSVkCapture com.obsproject.Studio com.discordapp.Discord com.ktechpit.whatsie  com.visualstudio.code im.riot.Riot io.github.shiftey.Desktop io.gitlab.jstest_gtk.jstest_gtk io.gitlab.news_flash.NewsFlash org.atheme.audacious org.gnome.gitlab.cheywood.Iotas org.kde.kdenlive org.onlyoffice.desktopeditors org.prismlauncher.PrismLauncher org.qbittorrent.qBittorrent org.telegram.desktop org.videolan.VLC org.yuzu_emu.yuzu org.gnome.Calculator org.gnome.Calendar org.gnome.Characters org.gnome.Cheese cc.arduino.IDE2 com.mattjakeman.ExtensionManager io.github.celluloid_player.Celluloid de.haeckerfelix.Shortwave io.github.seadve.Mousai org.gustavoperedo.FontDownloader com.github.huluti.Curtail org.gnome.gitlab.YaLTeR.Identity com.rafaelmardojai.Blanket fr.romainvigier.MetadataCleaner com.unity.UnityHub org.nickvision.tagger org.nickvision.tubeconverter io.github.Bavarder.Bavarder org.gnome.SimpleScan org.gnome.Evince com.notepadqq.Notepadqq org.gnome.baobab org.gnome.font-viewer

# Games
flatpak install -y org.libretro.RetroArch net.rpcs3.RPCS3 org.ppsspp.PPSSPP org.duckstation.DuckStation org.citra_emu.citra net.kuribo64.melonDS app.xemu.xemu net.brinkervii.grapejuice com.moonlight_stream.Moonlight net.pcsx2.PCSX2 com.mojang.Minecraft io.mrarm.mcpelauncher com.parsecgaming.parsec info.cemu.Cemu org.supertuxproject.SuperTux io.itch.itch dev.lizardbyte.app.Sunshine com.vysp3r.ProtonPlus com.heroicgameslauncher.hgl com.valvesoftware.Steam runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/21.08 runtime/org.freedesktop.Platform.VulkanLayer.MangoHud/x86_64/22.08 com.github.Matoking.protontricks net.lutris.Lutris org.DolphinEmu.dolphin-emu

# Install Beta version of GIMP. It performs better than the stable one, plus better Wayland support.
flatpak install -y flathub-beta org.gimp.GIMP

# Aur Pacakges
yay -Syu --noconfirm --needed distrobox podman yt-dlp zsh zsh-syntax-highlighting autojump zsh-autosuggestions neofetch xclip lolcat git trash-cli nautilus-nextcloud openssh-server hplip hplip-gui

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
sudo flatpak override --filesystem=xdg-config/MangoHud:ro

# Firewall
yay -Syu --noconfirm --needed ufw 
sudo ufw allow ssh
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