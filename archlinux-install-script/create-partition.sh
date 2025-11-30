#!/bin/bash
set -e -x

# 事前条件: $BLOCKDEVICEのサイズがEFI+SWAPSIZE+ROOTよりも小さいこと
# $BLOCKDEVICEにパーティションテーブルが存在していないこと

gecho() {
    echo -e "\033[0;32m${*}\033[0m"
}

[ "$BLOCKDEVICE" ] || ( echo "ERR: BLOCKDEVICEを指定してください" ; exit 1 ;)
EFIUUID=$(uuidgen)
ROOTUUID=$(uuidgen)
SWAPUUID=$(uuidgen)

# swap
SWAPSIZE=$(free -m | grep -oP 'Mem:\s+\K\d+' | awk '{printf "%.0f", $1 * 1.5}')

gecho パーティションテーブルを作成
sgdisk --new=1::+1G                   \
       --typecode=1:ef00              \
       --partition-guid=1:"$EFIUUID"  \
       --new=2::-"$SWAPSIZE"M         \
       --typecode=2:8300              \
       --partition-guid=2:"$ROOTUUID" \
       --new=3::                      \
       --typecode=3:8200              \
       --partition-guid=3:"$SWAPUUID" \
       "$BLOCKDEVICE"

while [ ! -e /dev/disk/by-partuuid/"$EFIUUID" ]; do sleep 0.1; done

gecho パーティションを作成
mkfs.fat -F32 /dev/disk/by-partuuid/"$EFIUUID"
mkfs.btrfs -f -L root /dev/disk/by-partuuid/"$ROOTUUID"
mkswap /dev/disk/by-partuuid/"$SWAPUUID"

gecho パーティションをマウント
mount /dev/disk/by-partuuid/"$ROOTUUID" /mnt
(
  cd /mnt
  btrfs subvolume create {@,@home,@var_log,@var_cache,@snapshots,@home_snapshots}
)
umount /mnt
mount -o defaults,noatime,space_cache=v2,ssd,compress-force=zstd:1,commit=120,subvol=@ \
      /dev/disk/by-partuuid/"$ROOTUUID" /mnt
mount --mkdir -o subvol=@home           /dev/disk/by-partuuid/"$ROOTUUID" /mnt/home
mount --mkdir -o subvol=@var_log        /dev/disk/by-partuuid/"$ROOTUUID" /mnt/var/log
mount --mkdir -o subvol=@var_cache      /dev/disk/by-partuuid/"$ROOTUUID" /mnt/var/cache
mount --mkdir -o subvol=@snapshots      /dev/disk/by-partuuid/"$ROOTUUID" /mnt/.snapshots
mount --mkdir -o subvol=@home_snapshots /dev/disk/by-partuuid/"$ROOTUUID" /mnt/home/.snapshots
# logとcacheについてはCoWを無効にする
chattr +C /mnt/var/log
chattr +C /mnt/var/cache
mount --mkdir /dev/disk/by-partuuid/"$EFIUUID" /mnt/boot
swapon /dev/disk/by-partuuid/"$SWAPUUID"
