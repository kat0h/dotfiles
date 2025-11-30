#!/bin/bash
set -e
cd $(dirname $0)

# 事前条件
#   パーティションテーブルが空であること

export BLOCKDEVICE="/dev/nvme0n1"
../create-partition.sh

read -p "HOSTNAME? > " HOSTNAME
export HOSTNAME
read -p "ROOTPASSWD? > " ROOTPASSWD
export ROOTPASSWD
export REGION="Asia/Tokyo"
export KEYMAP="jp106"
export INTEL_UCODE=1
../install-linux.sh
