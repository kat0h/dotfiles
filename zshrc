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
RPROMPT='${vcs_info_msg_0_}'

alias la="ls -la"
alias p="python3"
alias o="open"

# define open command if xdg-open is exsits
if type xdg-open > /dev/null; then
	alias open='xdg-open'
fi

# For Mac OS
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH=$PATH:/users/katokota/mybin
  # export GOPATH=/Users/katokota/.golang
  export PATH=$PATH:/Users/katokota/.golang/bin
  export PATH=$PATH:/Users/katokota/.nodebrew/current/bin
  export PATH=$PATH:/Users/katokota/.cargo/bin
  export PATH=$PATH:/usr/local/opt/llvm/bin/
  export PATH="/Users/katokota/.deno/bin:$PATH"
  export PATH="/usr/local/opt/llvm/bin:$PATH"
  export PATH="/usr/local/opt/ruby/bin:$PATH"
fi

if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
