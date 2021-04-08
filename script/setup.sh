function main() {
    # Main
    cd $(cd $(dirname $0); pwd) && cd ..

    # Make symlinks
    ln -s tmux.conf ~/.tmux.conf
    ln -s vim ~/.vim
    ln -s vimrc ~/.vimrc
    mkdir -p ~/.config/nvim
    ln -s vimrc ~/.config/nvim/init.vim
    ln -s zshrc ~/.zshrc
    mkdir -p ~/.config/alacritty
    ln -s alacritty.yml ~/.config/alacritty/alacritty.yml
    ln -s emacs.d ~/.emacs.d

    echo "The current directory is $(pwd)"

    # Check Platform
    if [[ "$(uname)" == 'Darwin' ]]; then
        OS='Mac'
    elif [[ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]]; then
        if [[ "$(uname -o)" == 'Android' ]]; then
            OS='Android'
        else
            OS='Linux'
        fi
    else
        echo "Your platform ($(uname)) is not supported."
        exit 1
    fi
    echo "Your platform is $OS"
    case "$OS" in
        "Mac") install_mac;;
        "Android") install_android;;
        "Linux") install_linux;;
    esac
}

# Defines
function install_mac() {
    echo "Nothing yet."
}

function install_linux() {
    echo 'Do you want to install these packages?\n'
    echo
    echo 'golang-go tmux vim build_essential python3 nodejs wget llvm'
    echo 'python3-pip ffmpeg libncursesw5-dev figlet curl youtube_dl'
    echo 'deno'
    echo
    printf  '(y/n): '
    if read -q; then
        echo
        add-apt-repository -y ppa:longsleep/golang-backports
        apt-get update && apt-get upgrade
        apt-get install -y golang-go
        apt-get install -y tmux
        apt-get install -y vim
        apt-get install -y build_essential
        apt-get install -y python3
        apt-get install -y nodejs
        apt-get install -y wget
        apt-get install -y llvm
        apt-get install -y python3-pip
        apt-get install -y ffmpeg
        apt-get install -y libncursesw5-dev
        apt-get install -y figlet
        apt-get install -y curl
        pip3 install --upgrade youtube_dl
        curl -fsSL https://deno.land/x/install/install.sh | sh
        # Todo: Build Vim
        echo "Install vim plugins"
        echo|vim +q!
    fi
    echo
    echo "Change login shell to zsh"
    chsh -s $(which zsh)
    return
}

echo '____ ____ ___ _  _ ___ '
echo '[__  |___  |  |  | |__]'
echo '___] |___  |  |__| |   '
echo

# Super Uset Check
if [[ "$USER" != "root" ]];then
    echo "Please run this script as root user (use sudo)"
    exit
fi

main
