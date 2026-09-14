#!/bin/bash
set -e -x
cd $(dirname $0)
cd ../config

# neovim
ln -sf $PWD/dot_config/nvim $HOME/.config/nvim
# hyprland
ln -sf $PWD/dot_config/hypr/hyprland.lua $HOME/.config/hypr/hyprland.lua
# xdg-desktop-portal
ln -sf $PWD/dot_config/xdg-desktop-portal/hyprland-portals.conf $HOME/.config/xdg-desktop-portal/hyprland-portals.conf
# git
ln -sf $PWD/dot_gitconfig   $HOME/.gitconfig
# tmux
ln -sf $PWD/dot_tmux.conf   $HOME/.tmux.conf
