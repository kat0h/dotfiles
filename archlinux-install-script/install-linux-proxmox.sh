#!/bin/bash
set -e -x

# 事前条件: インターネットへの接続
# 64bit環境
[ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]  || ( echo "not 64bit UEFI"; exit 1)

REGION="Asia/Tokyo"
HOSTNAME="archlinux-$(date -I)"
ROOTPASSWD="root"
KEYMAP="jp106"

# squidのプロキシを使うなら、export http_proxy='http://your_squid_machine_ip:3128/'
(
  cd /etc/pacman.d/
  sed -i \
    -e 's/^Server/#Server/' \
    -e '/## Japan/,/## / s/^#\(Server = http:\)/\1/' \
    mirrorlist
)

loadkeys "$KEYMAP"
timedatectl status
mkdir /mnt/etc
echo "KEYMAP=$KEYMAP" | tee /mnt/etc/vconsole.conf

pacstrap -K /mnt base base-devel linux linux-firmware efibootmgr btrfs-progs
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt << CHROOT
ln -sf /usr/share/zoneinfo/$REGION /etc/localtime
hwclock --systohc
sed -i \
    -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
    -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
    /etc/locale.gen
echo "$HOSTNAME" > /etc/hostname
echo "$ROOTPASSWD" | passwd -s root
exit
CHROOT
ESP="/mnt/boot"
ROOTUUID="$(grep -oP '(?<=UUID=)[0-9a-fA-F-]+(?=.*subvol=/@)' /mnt/etc/fstab | head -n1)"
bootctl install --esp-path="$ESP"
tee "$ESP"/loader/loader.conf << LOADERCONF
default  arch.conf
timeout  4
console-mode auto
editor   no
LOADERCONF
tee "$ESP"/loader/entries/arch.conf << ARCHCONF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=$ROOTUUID rootflags=subvol=/@ rw
ARCHCONF
