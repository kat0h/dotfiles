#!/bin/bash
set -x

pacman -S keyd --noconfirm
systemctl enable keyd
tee /etc/keyd/default.conf <<- KEYD
[ids]
*

[main]
capslock = leftcontrol
muhenkan = leftcontrol
hangeul = leftcontrol
hanja = leftcontrol
KEYD

