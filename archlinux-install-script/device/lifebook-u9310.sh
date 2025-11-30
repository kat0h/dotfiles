#!/bin/bash
set -e
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

if ! command -v git; then
  pacman -Sy
  pacman -S --noconfirm git
fi

# curlで直接実行されているなど、他のファイルが読めない環境の場合
if ! git rev-parse --is-inside-work-tree; then
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
