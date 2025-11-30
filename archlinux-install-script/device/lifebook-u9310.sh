#!/bin/bash
set -e
cd $(dirname $0)

# curlで直接実行されているなど、他のファイルが読めない環境の場合
git rev-parse --is-inside-work-tree > /dev/null 2>&1
if [ $? -ne 0 ]; then
  pacman -Sy
  pacman -S git
  cd
  git clone https://github.com/kat0h/dotfiles
  cd dotfiles
fi

# 事前条件
#   パーティションテーブルが空であること

export BLOCKDEVICE="/dev/nvme0n1"

read -p "HOSTNAME? > " HOSTNAME
export HOSTNAME
read -p "ROOTPASSWD? > " ROOTPASSWD
export ROOTPASSWD
read -p "USERNAME? > " USERNAME
export USERNAME
read -p "USERPASS? > " USERPASS
export USERPASS
export REGION="Asia/Tokyo"
export KEYMAP="jp106"
export INTEL_UCODE=1

../create-partition.sh
../install-linux.sh
