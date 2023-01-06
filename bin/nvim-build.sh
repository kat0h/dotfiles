#!/usr/bin/bash

BUILD_PATH=$HOME/.cache/build
mkdir -p $BUILD_PATH
MAKEFLAGS=-j`nproc`

sudo apt update -y && yes | sudo apt upgrade
yes | sudo apt install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen git

if [ -e $BUILD_PATH/neovim ]; then
  cd $BUILD_PATH && git pull
else
  cd $BUILD_PATH && git clone https://github.com/neovim/neovim
fi

cd $BUILD_PATH/neovim && sudo make CMAKE_BUILD_TYPE=RelWithDebInfo $MAKEFLAGS && sudo make install
