# Super Uset Check
if [[ "$USER" == "root" ]];then
    echo "Please run this script as normal user"
    exit
fi

source ./link.sh
sudo source ./setup.sh
