#!/usr/bin/env bash

if [ -n $1 ]; then
    link=$1
    file=~/Nextcloud/AppImages/$(basename $link)
else
    echo "usage: update-librewolf-appimage.sh LINK"
    exit 1
fi

if [ -f $file ]; then
    echo "file is present, attempting to symlink"
else
    echo "Attempting download from $link"
    wget --directory-prefix ~/Nextcloud/AppImages/ $link
fi

if [ -f $file ]; then
    chmod +x $file
    ln -sf $file ~/.local/bin/librewolf
    exit 0
else
    echo $file is not a file!
    exit 1
fi

