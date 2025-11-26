#!/bin/bash
set -e

[ $BLOCKDEVICE ] || ( echo "ERR: BLOCKDEVICEを指定してください" ; exit 1 ;)

umount -R /mnt
wipefs -af "$BLOCKDEVICE"
swapoff "$BLOCKDEVICE"3

partprobe "$BLOCKDEVICE"

