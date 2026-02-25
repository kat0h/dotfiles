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


gecho() {
    echo -e "\033[0;32m${*}\033[0m"
}

# 64bit環境
[ "$(cat /sys/firmware/efi/fw_platform_size)" = "64" ]  || ( echo "not 64bit UEFI"; exit 1)

for v in REGION HOSTNAME ROOTPASSWD USERNAME USERPASS
do
  if [ -z "${!v}" ]
  then
    echo "$v が未定義"
    exit
  fi
done

read -p インストールを開始します\>

timedatectl status
mkdir -p /mnt/etc
[ -e /mnt/etc/vconsole.conf ] || echo "KEYMAP=$KEYMAP" | tee /mnt/etc/vconsole.conf

read -p 必須のパッケージをインストールします
if [ ! -e /mnt/etc/os-release ]; then
  pkglist="base base-devel linux linux-firmware efibootmgr btrfs-progs fastfetch pacman-contrib iwd sof-firmware bash bash-completion"
  [ -e /boot/intel-ucode.img ] && rm /boot/intel-ucode.img
  [ -n "$INTEL_UCODE" ] && pkglist="$pkglist intel-ucode"
  pacstrap -K /mnt $pkglist
else
  gecho /etc/os-release exist skip pacstrap
fi
genfstab -U /mnt > /mnt/etc/fstab

# execute user environment
# TODO: ネットワークの設定

CREATE_USER="(
  useradd -m -g wheel -G input $USERNAME
  echo $USERPASS|passwd -s $USERNAME
  sed -i -E 's/# (Defaults env_keep \+= \"HOME\"|%wheel ALL=\(ALL:ALL\) ALL)/\1/g' /etc/sudoers
)"

read -p arch-chrootします
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
  $CREATE_USER
  rm /root/.bash_history
CHROOT

ESP="/mnt/boot"
ROOTUUID="$(grep -oP '(?<=UUID=)[0-9a-fA-F-]+(?=.*subvol=/@)' /mnt/etc/fstab | head -n1)"
# Install Boot Loader
install_bootloader () {
  bootctl install --esp-path="$ESP"
  tee "$ESP"/loader/loader.conf <<- LOADERCONF
    default  arch.conf
    timeout  4
    console-mode auto
    editor   no
LOADERCONF
}
create_bootloader_conf () {
  tee "$ESP"/loader/entries/arch-$(date -I).conf <<- ARCHCONF
    title   Arch Linux $(date -I)
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    $( [ -n "$INTEL_UCODE" ] && printf "initrd  /intel-ucode.img\n" )
    options root=UUID=$ROOTUUID rootflags=subvol=/@ rw resume=UUID=$(swapon --show=UUID | tail -n 1)
ARCHCONF
}
if [ ! -e "$ESP"/loader/loader.conf ]; then
  install_bootloader
else
  gecho bootloader already installed skip...
fi
create_bootloader_conf

echo Install completed. Please setup some network daemon.
read
