#!/bin/bash
set -e -x

yay -S networkmanager-l2tp strongswan xl2tpd --needed
systemctl enable --now strongswan-starter xl2tpd

# KDEの設定から、L2TPの設定をして接続すればOK
