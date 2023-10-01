#!/bin/sh
# Removing Gnome only Configs
sudo sed -i '/export QT_QPA_PLATFORMTHEME=qt5ct/d' /etc/environment
sudo systemctl disable gdm

# Removing Gnome and GTK apps
yay -Rns --noconfirm --needed gnome-autoar gnome-backgrounds gnome-backgrounds-macos gnome-bluetooth gnome-color-manager gnome-control-center gnome-desktop gnome-disk-utility gnome-keyring gnome-online-accounts gnome-session gnome-settings-daemon gnome-shell  gnome-software-git gnome-software-packagekit-plugin-git gnome-system-monitor gnome-terminal gnome-tweaks polkit-gnome xdg-desktop-portal-gnome adwaita-qt5-git adwaita-qt6-git qt5ct qt6ct adw-gtk-theme qt5ct qt6ct nautilus-image-converter nautilus nautilus-checksums nautilus-code system-config-printer
flatpak remove -y org.gnome.gitlab.cheywood.Iotas org.gnome.Loupe org.gnome.Calculator org.gnome.Calendar org.gnome.Characters org.gnome.SimpleScan org.gnome.Evince org.gnome.font-viewer org.gnome.Snapshot org.gnome.Epiphany org.gtk.Gtk3.theme.adw-gtk3 org.gtk.Gtk3.theme.adw-gtk3-dark 

# Installing KDE and QT apps
yay -Syu --noconfirm --needed plasma-wayland-session plasma-desktop maliit-keyboard konsole dolphin discover packagekit-qt5 plasma-systemmonitor partitionmanager plasma-disks sddm-git plasma-nm kde-gtk-config print-manager
flatpak install -y org.kde.kcalc org.qownnotes.QOwnNotes org.kde.gwenview org.kde.kamoso org.kde.okular org.kde.angelfish org.kde.haruna

# Kde Configs
sudo systemctl enable sddm