#!/bin/sh

# copy this file to /root/

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $userresources ]; then
    xrdb -merge $userresources
fi

# if [ -f $sysmodmap ]; then
#     xmodmap $sysmodmap
# fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

[ -f $HOME/.xprofile ] && . $HOME/.xprofile

setxkbmap de
FontPath /usr/share/fonts/100dpi
# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec xterm -geometry 80x66+0+0 -name login
# qtile
##exec xterm
#exec startkde

# exec ssh-agent xmonad > /tmp/xmonadlog
exec ssh-agent qtile start
