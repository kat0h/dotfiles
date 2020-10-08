#last Update 2019/05/06

# if [ $SHLVL -gt 1 ]; then
: "一般的な設定" && {
setopt correct # 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt nobeep # ビープを鳴らさない
setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる。
setopt auto_cd # ディレクトリ名を入力するだけでcdできるようにする
}
if [[ $(uname) -eq "Darwin" ]]; then
    # Setting PATH for Python 3.6
    # The original version is saved in .bash_profile.pysave
    PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
    export PATH
    # Setting PATH
    # Added 2018/5/11
    export PATH=$PATH:/Users/katokota/myBin
    # gopath
    export GOPATH=$HOME/.golang
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:/Users/katokota/.nodebrew/current/bin

fi

if [[ $(uname) -eq "Darwin" ]]; then
    alias tetris="bastet"
    alias rm="trash"

    # alias f="fzf | xargs -o -t "
    export FZF_DEFAULT_OPTS="--ansi --select-1 --exit-0 --reverse"
        export FZF_DEFAULT_COMMAND='find . -type f -name "*"'
    export FZF_DEFAULT_COMMAND='ag -l --hidden'

fi

alias cls="clear"
alias vi="vim"

alias la="ls -la"

alias gia="git add ."
alias gic="git commit"
alias gis="git status"
alias gil="git log"
alias gip="git push"

autoload -Uz colors
colors

#PROMPTが呼ばれる前に実行される
precmd () {}
# PROMPT="%{${bg[blue]%}%}%{${fg[black]}%} %n %{${bg[white]}%}%{${fg[blue]}%}%{${bg[white]}%}%{${fg[black]}%} %~ %{${reset_color}%}%{${fg[white]}%} %{${reset_color}%}"
# PROMPT="%{${bg[white]}%}%{${fg[black]}%}%~ %{${reset_color}%}%{${fg[white]}%}  %{${reset_color}%}"
PROMPT="%{${fg[blue]}%}%~%{${fg[yellow]}%} > %{${reset_color}%}"


#=============================
# source zsh-syntax-highlighting
#=============================
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
zstyle ':completion:*:default' menu select=2

function ranger() {
if [ -z "$RANGER_LEVEL" ]; then
/usr/local/bin/ranger $@
else
exit
fi
}
# zsh-completionsを利用する Github => zsh-completions
fpath=(~/.zsh-completions $fpath)
autoload -U compinit && compinit # 補完機能の強化
# fi

# for w3m
export WWW_HOME="http://google.com/"


# 初回シェル時のみ tmux実行
if [ $SHLVL = 1 ]; then
tmux
fi

