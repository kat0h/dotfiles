#!/bin/bash
set -e -x

# don't exec this script as super user

sudo pacman -Syyu --noconfirm
pacman -S noconfirm plasma dolphin firefox konsole noto-fonts-cjk cups system-config-printer ghostscript power-profiles-daemon kdegraphics-thumbnailers  packagekit-qt6 xdg-desktop-portal xdg-desktop-portal-kde
systemctl enable --now sddm
systemctl enable --now cups
systemctl enable --now bluetooth
systemctl enable --now power-profiles-daemon
systemctl disable systemd-networkd systemd-resolved iwd
systemctl enable NetworkManager

echo "systemctl start sddm"

echo "change sddm theme"
echo "change keyboard layout"
echo "key repeat delay 350ms rate 60 repeats/s"
echo "change trackpad scroll factor"
