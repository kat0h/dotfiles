cd ~/dotfiles/

while read filename
do
		echo "ln -sf `echo $filename | awk '{print "~/dotfiles/" $1 " ~/" $2}'`" | sh
	done <<END
tmux.conf .tmux.conf
vim .vim
vimrc ~/.config/nvim/init.vim
vimrc .vimrc
zshrc .zshrc
alacritty.yml ~/.config/alacritty.yml
emacs.d .emacs.d
youtube-dl .config/youtube-dl
END
