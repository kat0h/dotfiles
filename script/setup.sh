function main() {
    # Main
    cd $(cd $(dirname $0); pwd) && cd ..

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
    echo 'tmux  vim  build_essential  python3  nodejs  wget  llvm'
    echo
    printf  '(y/n): '
    if read -q; then
        echo
        apt-get update && apt-get upgrade
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
        add-apt-repository -y ppa:longsleep/golang-backports
        apt update -y
        apt install -y golang-go
        pip3 install --upgrade youtube_dl
        curl -fsSL https://deno.land/x/install/install.sh | sh
        # Todo: Build Vim
    else
        echo
        return
    fi
}

echo '____ ____ ___ _  _ ___ '
echo '[__  |___  |  |  | |__]'
echo '___] |___  |  |__| |   '
echo

install_linux
exit

# Super Uset Check
if [[ "$USER" != "root" ]];then
    echo "Please run this script as root user (use sudo)"
    exit
fi
main
