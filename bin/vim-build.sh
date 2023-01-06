#!/usr/bin/bash

BUILD_PATH=$HOME/.cache/build
mkdir -p $BUILD_PATH
MAKEFLAGS=-j`nproc`

sudo apt update && yes | sudo apt upgrade
yes | sudo apt install git gettext libtinfo-dev libacl1-dev libgpm-dev

if [ -e $BUILD_PATH/vim ]; then
  cd $BUILD_PATH && git pull
else
  cd $BUILD_PATH && git clone https://github.com/vim/vim
fi

make clean
cd $BUILD_PATH/vim && make $MAKEFLAGS && sudo make install
