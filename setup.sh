self_dir=$(cd $(dirname $0); pwd)

ln -snfv "$self_dir/vimrc" "$HOME/.vimrc"
ln -snfv "$self_dir/zshrc" "$HOME/.zshrc"
ln -snfv "$self_dir/tmux.conf" "$HOME/.tmux.conf"
ln -snfv "$self_dir/vim" "$HOME/.vim"
ln -snfv "$self_dir/emacs.d" "$HOME/.emacs.d"
ln -snfv "$self_dir/config/alacritty" "$HOME/.config/alacritty"
ln -snfv "$self_dir/vim" "$HOME/.config/nvim"
