#!/bin/bash
set -e -x

yay -S xl2tpd libreswan ppp --needed --noconfirm
systemctl start ipsec

# https://libreswan.org/wiki/VPN_server_for_remote_clients_using_IKEv1_with_L2TP
# /etc/ipsec.secrets
