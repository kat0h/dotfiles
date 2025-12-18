#!/bin/bash
set -e -x
cd $(dirname $0)

cd
if ! git rev-parse --is-inside-work-tree; then
  cd
  git clone https://github.com/kat0h/dotfiles
  cd dotfiles/archlinux-install-script/device
  echo re run
  exit
fi

export BLOCKDEVICE="/dev/nvme0n1"
export HOSTNAME="ueckoken-$(date "+%Y-%m-%d-%H-%M")"
export ROOTPASSWD="root"
export USERNAME="user"
export USERPASS="user"
export REGION="Asia/Tokyo"
export KEYMAP="jp106"

../create-partition.sh
../install-linux.sh
