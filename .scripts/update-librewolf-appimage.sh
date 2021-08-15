#!/usr/bin/env bash

if [ -n $1 ]; then
    link=$1
else
    echo "usage: update-librewolf-appimage.sh LINK"
fi

echo "Attempting download from $link"

file=~/Nextcloud/AppImages/$(basename $link)

if [ -f $file ]; then
    echo "file is present, just symlinking"
else
    wget --directory-prefix ~/Nextcloud/AppImages/ $link
fi

chmod +x $file
ln -sf $file ~/.local/bin/librewolf

