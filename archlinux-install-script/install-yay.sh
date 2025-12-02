#!/bin/bash
set -e -x

# 事前条件
#   一般ユーザでログインしている
#   ユーザがsudoersに入っている

install () {
  (
    sudo pacman -S --needed git fakeroot binutils make gcc --noconfirm
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
  )
}
which yay || install
