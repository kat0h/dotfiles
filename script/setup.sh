cd ~/dotfiles/

while read filename
do
	ln -fs `echo $filename | awk '{print $1 " ~/" $2}'`
done <<END
tmux.conf .tmux.conf
vim .vim
vimrc .vimrc
zshrc .zshrc
END
