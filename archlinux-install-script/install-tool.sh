#!/bin/bash
set -e -x

# 事前条件
#   一般ユーザでログインしていること
#   yayがインストールされていること

yay -S --noconfirm --needed github-cli btop vim neovim-nightly-bin lazygit tailscale-git openssh wget
systemctl enable --now tailscaled
curl -fsSL https://deno.land/install.sh | sh
