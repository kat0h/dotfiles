#!/bin/bash
set -x

pacman -S keyd --noconfirm
systemctl enable keyd
tee /etc/keyd/default.conf <<- KEYD
[ids]
*

[main]
muhenkan = layer(control)
hangeul = overload(control, hangeul)
hanja = overload(control, hanja)
leftcontrol = layer(recontrol)
capslock = layer(recontrol)

[recontrol:C]
p = up
n = down
f = right
b = left
h = backspace
e = end
a = home
i = tab

KEYD

