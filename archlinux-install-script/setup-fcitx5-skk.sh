#!/bin/bash
set -e -x
sudo pacman -S --noconfirm --needed fcitx5-skk fcitx5-breeze fcitx5-configtool

ln -sf $PWD/dot_config/libskk $HOME/.config/libskk
echo "please enable fcitx5 virtual keyboard"
