#!/bin/bash
set -e -x
cd $(dirname $0)
cd ../config

# Link $HOME/<path> to config/<path>.
link() {
    if [ -d "$HOME/$1" ] && [ ! -L "$HOME/$1" ]; then
        echo "$HOME/$1 is a real directory; move it away first" >&2
        return 1
    fi
    mkdir -p "$(dirname "$HOME/$1")"
    ln -sfn "$PWD/$1" "$HOME/$1"
}

# Whole directories
link .config/nvim
link .config/alacritty
link .config/libskk
# Single files: these directories also hold generated or machine-specific files
link .config/hypr/hyprland.lua
link .config/umbriel/config.toml
link .config/xdg-desktop-portal/hyprland-portals.conf
link .config/xdg-desktop-portal/umbriel-portals.conf
link .config/autostart/imsettings-start.desktop
link .config/autostart/org.kde.xwaylandvideobridge.desktop
link .gitconfig
link .tmux.conf
