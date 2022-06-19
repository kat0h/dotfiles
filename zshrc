# Option
export LANG=ja_JP.UTF-8
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

alias la="ls -la"
alias p="python3"
alias o="open"

# define open command if xdg-open is exsits
if type xdg-open > /dev/null; then
	alias open='xdg-open'
fi

# For Mac OS
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH=$PATH:$HOME/mybin
  # deno
  export PATH="$HOME/.deno/bin:$PATH"
  # ruby
  export PATH="/usr/local/opt/ruby/bin:$PATH"
  # llvm
  function llvm (){
    export PATH="/usr/local/opt/llvm/bin:$PATH"
    export LDFLAGS="-L/usr/local/opt/llvm/lib"
    export CPPFLAGS="-I/usr/local/opt/llvm/include"
    unset -f llvm
  }
# other os
else
  export DENO_INSTALL="$deno_install"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
export PATH="/usr/local/sbin:$PATH"
