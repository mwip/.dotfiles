#!/usr/bin/env bash

if [ -n $2 ]; then
    binary=$1
    link=$2
    file=~/Nextcloud/AppImages/$binary.AppImage
else
    echo "usage: update-appimage.sh BINARY-NAME LINK"
    exit 1
fi

wget -O $file $link

if [ -f $file ]; then
    chmod +x $file
    ln -sf $file ~/.local/bin/$binary
    exit 0
else
    echo $file is not a file!
    exit 1
fi

