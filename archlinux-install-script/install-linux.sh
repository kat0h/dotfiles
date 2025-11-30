#!/bin/bash
set -x

# 事前条件:
#   64bit EFI環境で起動している
#   インターネットへの接続
#   /mntにターゲットの/がマウントされている
#   REGION HOSTNAME ROOTPASSWD KEYMAPが定義されている
#   INTEL_UCODEが定義されている(Intel機)
#   USERNAME USERPASS

# 事後条件:
#   /mnt下にArchLinuxがインストールされる
#   systemd-networkdによってインターネットに接続できる
#

gecho() {
    echo -e "\033[0;32m${*}\033[0m"
}

# 64bit環境
[ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]  || ( echo "not 64bit UEFI"; exit 1)

for v in REGION HOSTNAME ROOTPASSWD KEYMAP USERNAME USERPASS
do
  [ -z "${!v}" ] && echo "$v が未定義"
done

loadkeys "$KEYMAP"
timedatectl status
mkdir -p /mnt/etc
[ -e /mnt/etc/vconsole.conf ] || echo "KEYMAP=$KEYMAP" | tee /mnt/etc/vconsole.conf

if [ ! -e /mnt/etc/os-release ]; then
  pkglist="base base-devel linux linux-firmware efibootmgr btrfs-progs fastfetch pacman-contrib iwd"
  [ -n "$INTEL_UCODE" ] && pkglist="$pkglist intel-ucode"
  pacstrap -K /mnt $pkglist
else
  gecho /etc/os-release exist skip pacstrap
fi
genfstab -U /mnt > /mnt/etc/fstab

# execute user environment
SETUP_NETWORK="(
  systemctl enable systemd-networkd systemd-resolved iwd
  umount /etc/resolv.conf
  ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
  mkdir /mnt/var/lib/iwd
  cp -r /var/lib/iwd/* /mnt/var/lib/iwd
)"
KILL_CAPSLOCK="(
  pacman -S keyd --noconfirm
  systemctl enable keyd
  tee /etc/keyd/default.conf <<- KEYD
    [ids]
    *

    [main]
    capslock = leftcontrol
KEYD
)"
cp /etc/systemd/network/* /mnt/etc/systemd/network
CREATE_USER="(
  useradd -m -g wheel -G input $USERNAME
  echo $USERPASS|passwd -s $USERNAME
  sed -i -E 's/# (Defaults env_keep \+= \"HOME\"|%wheel ALL=\(ALL:ALL\) ALL)/\1/g' /etc/sudoers
)"

arch-chroot /mnt <<- CHROOT
  ln -sf /usr/share/zoneinfo/$REGION /etc/localtime
  hwclock --systohc
  sed -i \
      -e 's/^#\(ja_JP.UTF-8 UTF-8\)/\1/' \
      -e 's/^#\(en_US.UTF-8 UTF-8\)/\1/' \
      /etc/locale.gen
  locale-gen
  echo "LANG=en_US.UTF-8" > /etc/locale.conf
  echo "$HOSTNAME" > /etc/hostname
  echo "$ROOTPASSWD" | passwd -s root
  sed -i \
    -e 's/^#\(ParallelDownloads\)/\1/' \
    -e 's/^#\(Color\)/\1/' \
    /etc/pacman.conf
  pacman -Syy
  $SETUP_NETWORK
  $KILL_CAPSLOCK
  $CREATE_USER
  rm /root/.bash_history
CHROOT

ESP="/mnt/boot"
# Install Boot Loader
install_bootloader () {
  ROOTUUID="$(grep -oP '(?<=UUID=)[0-9a-fA-F-]+(?=.*subvol=/@)' /mnt/etc/fstab | head -n1)"
  bootctl install --esp-path="$ESP"
  tee "$ESP"/loader/loader.conf <<- LOADERCONF
    default  arch.conf
    timeout  4
    console-mode auto
    editor   no
LOADERCONF

  tee "$ESP"/loader/entries/arch.conf <<- ARCHCONF
    title   Arch Linux
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    $( [ -n "$INTEL_UCODE" ] && printf "initrd  /intel-ucode.img\n" )
    options root=UUID=$ROOTUUID rootflags=subvol=/@ rw
ARCHCONF
}
if [ ! -e "$ESP"/loader/loader.conf ]; then
  install_bootloader
else
  gecho bootloader already installed skip...
fi
