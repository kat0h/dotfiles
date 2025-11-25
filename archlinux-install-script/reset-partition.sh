#!/bin/bash
set -e

BLOCKDEVICE="/dev/sda"

umount -R /mnt
wipefs -af "$BLOCKDEVICE"
swapoff "$BLOCKDEVICE"3

partprobe "$BLOCKDEVICE"

