#!/usr/bin/bash

#echo ".DS_Storeファイルを削除します(中断するにはCtrl-c)"
#read i
#find . -type f | grep ".DS_Store" | xargs rm

for FILENAME in `ls -a HOME/ | grep -v "\.$" | grep -v ".DS_Store"`
do
    ln -s ~/dotfiles/HOME/$FILENAME ~/
    if [ $? -eq "0" ] ; then
        echo "link" $FILENAME
    else
        echo "error" $FILENAME
    fi
done
