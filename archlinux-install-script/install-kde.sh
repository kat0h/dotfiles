#!/bin/bash
set -e -x

# don't exec this script as super user

sudo pacman -Syyu --noconfirm
pacman -S --noconfirm plasma dolphin firefox konsole noto-fonts-cjk cups system-config-printer ghostscript power-profiles-daemon kdegraphics-thumbnailers  packagekit-qt6 xdg-desktop-portal xdg-desktop-portal-kde
sudo systemctl enable --now cups
sudo systemctl enable --now bluetooth
sudo systemctl enable --now power-profiles-daemon
sudo systemctl disable systemd-networkd systemd-resolved iwd
sudo systemctl enable NetworkManager
sudo systemctl enable --now sddm

echo "systemctl start sddm"

echo "change sddm theme"
echo "change keyboard layout"
echo "key repeat delay 350ms rate 60 repeats/s"
echo "change trackpad scroll factor"
