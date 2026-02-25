#!/bin/bash
set -x

# https://x.com/McbeEringi/status/1780502324496212224?s=20 UECWireless周り

systemctl enable systemd-networkd systemd-resolved iwd systemd-timesyncd
umount /etc/resolv.conf
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
mkdir /mnt/var/lib/iwd # 動いてる？
cp -r /var/lib/iwd/* /mnt/var/lib/iwd/

