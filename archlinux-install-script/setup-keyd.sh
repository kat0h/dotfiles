#!/bin/bash
set -x

pacman -S keyd --noconfirm
systemctl enable keyd
tee /etc/keyd/default.conf <<- KEYD
[ids]
*

[main]
henkan = overload(control, hangeul)
muhenkan = overload(control, hanja)
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

tee /etc/keyd/hhkb.conf <<- KEYD2
[ids]
04fe:0020

[main]
henkan = overload(control, hangeul)
muhenkan = overload(control, hanja)
rightalt = leftmeta
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
KEYD2

