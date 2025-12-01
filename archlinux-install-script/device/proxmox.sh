#!/bin/bash
set -e -x
cd $(dirname $0)

# setup proxy (for dev)
# squidのプロキシを使うなら、export http_proxy='http://your_squid_machine_ip:3128/'
(
  cd /etc/pacman.d/
  if [ -z "$http_proxy" ]
  then
    sed -i \
      -e 's/^Server/#Server/' \
      -e '/## Japan/,/## / s/^#\(Server = https:\)/\1/' \
      mirrorlist
  else
    sed -i \
      -e 's/^Server/#Server/' \
      -e '/## Japan/,/## / s/^#\(Server = http:\)/\1/' \
      mirrorlist
  fi
)

pacman -Sy
pacman -S --noconfirm git
cd
git clone https://github.com/kat0h/dotfiles
cd dotfilesgarchlinux-install-script/device
export BLOCKDEVICE="/dev/nvme0n1"
export HOSTNAME="proxmox-$(date "+%Y-%m-%d-%H-%M")"
export ROOTPASSWD="root"
export USERNAME="user"
export USERPASS="user"
export REGION="Asia/Tokyo"
export KEYMAP="jp106"

../create-partition.sh
../install-linux.sh

