# Option
# export LANG=ja_JP.UTF-8
bindkey -e
setopt correct
setopt no_tify
setopt auto_cd

# Prompt
autoload -Uz colors
colors
PROMPT="%{${fg[blue]}%}%~%{${fg[yellow]}%} > %{${reset_color}%}"
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats "%{${fg[yellow]}%}< %{${fg[blue]}%}%b%{${reset_color}%}"
zstyle ':vcs_info:*' actionformats "%{${fg[yellow]}%}< %{${fg[blue]}%}%b|%a%{${reset_color}%}"
precmd () { vcs_info }
setopt prompt_subst
RPROMPT='${vcs_info_msg_0_}'"%{${fg[yellow]}%} < %{${fg[blue]}%}%D{%F %T}%{${reset_color}%}"

autoload -U compinit
compinit

alias la="ls -la"
alias p="python3"
alias o="open"
alias n="nvim"

alias ghrepo='cd $(ghq list --full-path | fzf)'
alias open='xdg-open'

# define open command if xdg-open is exsits
if type xdg-open > /dev/null; then
	alias open='xdg-open'
fi

# For Mac OS
if [[ "$(uname)" == "Darwin" ]]; then
  # llvm
  function llvm (){
    export PATH="/usr/local/opt/llvm/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/llvm/lib"
    export CPPFLAGS="-I/usr/local/opt/llvm/include"
    unset -f llvm
  }
fi

if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
export PATH="/usr/local/sbin:$PATH"

export PATH="$HOME/dotfiles/bin:$PATH"

source "$HOME/.cache/env"

# eval "$(nodenv init -)"
# source $HOME/.cargo/env

# if [[ ! -n $TMUX ]]; then
#   tmux new-session
# fi

# bun completions
[ -s "/home/kat0h/.bun/_bun" ] && source "/home/kat0h/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# asdf
. /opt/asdf-vm/asdf.sh

export HISTFILE="$HOME/.zsh_history"
setopt share_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups
# 余分な空白は詰めて記録
setopt hist_reduce_blanks
