#!/bin/bash
set -e -x

# 便利ツールをインストールくん
# 事前条件
#   一般ユーザでログインしていること
#   yayがインストールされていること

yay -S --noconfirm --needed github-cli btop vim neovim-nightly-bin lazygit tailscale-git openssh wget ttf-moralerspace impala btop dosfstools timeshift timeshift-systemd-timer zoxide fzf ghq deno
sudo systemctl enable --now tailscaled
sudo systemctl enable --now timeshift-hourly.timer

