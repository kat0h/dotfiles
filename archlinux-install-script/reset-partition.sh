#!/bin/bash
set -x
[ $BLOCKDEVICE ] || ( echo "ERR: BLOCKDEVICEを指定してください" ; exit 1 ;)

umount -R /mnt
wipefs -af "$BLOCKDEVICE"
swapoff "$BLOCKDEVICE"p3

partprobe "$BLOCKDEVICE"

