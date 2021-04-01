cd ~/dotfiles/

while read filename
do
	echo "ln -sf `echo $filename | awk '{print "~/dotfiles/" $1 " ~/" $2}'`" | sh
done <<END
tmux.conf .tmux.conf
vim .vim
vimrc .vimrc
vimrc .config/nvim/init.vim
zshrc .zshrc
alacritty.yml .alacritty.yml
emacs.d .emacs.d
END

