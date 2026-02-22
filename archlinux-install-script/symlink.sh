#!/bin/bash
set -e -x
cd $(dirname $0)
cd ../config

# neovim
ln -sf $PWD/dot_config/nvim $HOME/.config/nvim
# git
ln -sf $PWD/dot_gitconfig   $HOME/.gitconfig
# tmux
ln -sf $PWD/dot_tmux.conf   $HOME/.tmux.conf
