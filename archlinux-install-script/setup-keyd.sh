#!/bin/bash
set -x
cd $(dirname $0)

# pacman -S keyd --noconfirm
# systemctl enable keyd
install -Dm644 -t /etc/keyd ../etc/keyd/*.conf
