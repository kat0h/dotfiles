#!/bin/bash
set -e -x
# bashにzoxideとghqを導入します

BASHRC="${HOME}/.bashrc"

# TODO: https://blog.atusy.net/2025/05/09/zoxide-with-ghq/
# ghqとzoxideを連携させる設定を導入したい
#
# function ghql() {
#   local selected_file=$(ghq list --full-path | fzf)
#   if [ -n ${selected_file} ]; then
#     if [ -t 1 ]; then
#       echo ${selected_file}
#       z ${selected_file}
#       pwd
#       zle accept-line
#     fi
#   fi
#   zle -R -c
# }
# zle -N ghql
# bindkey '^g' ghql

tee -a "${BASHRC}" << BASHRC_EOL
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \w]\$ '
export EDITOR=nvim
BASHRC_EOL

sudo pacman -S zoxide ghq

# ghq/zoxide用の設定が記述されていなければ追記
if grep -q "selected_file" "${BASHRC}"
then
  echo "bashrcにはghq/zoxide用の設定が記述されているため、変更されませんでした。"
else
  tee -a "${BASHRC}" << BASHRC_EOL
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
