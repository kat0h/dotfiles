#!/bin/bash
set -e -x
cd $(dirname $0)

cd

export BLOCKDEVICE="/dev/sda"
export HOSTNAME="ueckoken-$(date "+%Y-%m-%d-%H-%M")"
export ROOTPASSWD="root"
export USERNAME="user"
export USERPASS="user"
export REGION="Asia/Tokyo"
export KEYMAP="jp106"

../create-partition.sh
../install-linux.sh
