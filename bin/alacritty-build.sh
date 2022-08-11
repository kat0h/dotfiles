#!/usr/bin/bash

sudo apt-get update && yes | sudo apt upgrade
yes | sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 cargo

cargo install alacritty
