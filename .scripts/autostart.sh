#!/bin/bash

# xrandr --output VGA-1 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output VGA-2 --mode 1920x1200 --pos 0x0 --rotate normal --output VGA-3 --mode 1200x1600 --pos 3840x0 --rotate normal
#xrandr --output VGA-1 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output VGA-2 --mode 1920x1200 --pos 0x0 --rotate normal
wmname LG3D & # DWM tweak to get jabref running
compton &
nitrogen --restore & 
urxvtd -q -o -f &
xsetroot -cursor_name left_ptr &
keepassxc &
xrdb -merge ~/.Xresources &
nm-applet &
setxkbmap de &
syncthing-gtk &
dunst &
redshift-gtk -t 6500:3000 -l 48.13:11.57 & 
$HOME/.config/qtile/deactivateBluetooth &
blueman-applet &
libinput-gestures-setup restart &
xautolock -time 10 -locker '$HOME/.scripts/lockscreen.sh' &
udiskie &
# Device specific autostarts 
if [ $(hostname) == "bifrost" ] 
then
    # remap lenovo print key to context menu key
    xmodmap -e "keycode 107 = Menu" &
fi
if [ $(hostname) == "walhall" ]
then
    # start mpd notifications (using dunst)
    # sleep 30 & mpDris2 & # should be started as systemd service
fi
synology-drive &


