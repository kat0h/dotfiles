#!/bin/bash
set -e -x
# bashにzoxideとghqを導入します

BASHRC="${HOME}/.bashrc"

# TODO: https://blog.atusy.net/2025/05/09/zoxide-with-ghq/
# ghqとzoxideを連携させる設定を導入したい

sudo pacman -S zoxide ghq

# ghq/zoxide用の設定が記述されていなければ追記
if grep -q "selected_file" "${BASHRC}"
then
  echo "bashrcにはghq/zoxide用の設定が記述されているため、変更されませんでした。"
else
  tee -a "/tmp/.bashrc" << BASHRC_EOL
eval "\$(zoxide init bash)"

function ghql() {
  local selected_file=\$(ghq list --full-path | fzf)
  if [ -n \${selected_file} ]; then
    if [ -t 1 ]; then
      echo \${selected_file}
      z \${selected_file}
      pwd
    fi
  fi
}
bind -x '"\201": ghql'
bind '"\C-g":"\201\C-m"'
BASHRC_EOL
fi
