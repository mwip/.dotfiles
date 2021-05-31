#!/bin/bash

# Device specific autostarts 
if [ $(hostname) == "walhall" ]
then
    xrandr --output DisplayPort-0 --off --output DisplayPort-1 --mode 1440x900 --pos 0x300 --rotate normal --output HDMI-0 --off --output DVI-0 --off --output DVI-1 --primary --mode 1920x1200 --pos 1440x0 --rotate normal
fi &
if [ $(hostname) == "andlang" ]
then
    xrandr --output DisplayPort-0 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output DisplayPort-1 --mode 1920x1200 --pos 0x0 --rotate normal --output DisplayPort-2 --off --output HDMI-A-0 --off
    setxkbmap de
    imwheel
fi &
xbindkeys &
wmname LG3D & # DWM tweak to get jabref running
stalonetray &
picom &
#nitrogen --restore &
sleep 5 && coperincus_wallpaper.sh &
xsetroot -cursor_name left_ptr &
xset r rate 280 35 &
keepassxc &
xrdb -merge ~/.Xresources &
syncthing-gtk &
dunst &
redshift-gtk -t 6500:3000 -l 48.13:11.57 & 
xfce4-power-manager &
$HOME/.scripts/deactivateBluetooth &
blueman-applet &
libinput-gestures-setup restart &
xautolock -time 10 -notify 30 -notifier "notify-send 'xautolock kicking in soon'" -corners 000- -locker 'betterlockscreen -l blur' -detectsleep  &
#lockctl.sh -D &> /tmp/lockctl.log &
#xautolock -time 10 -notify 30 -notifier "notify-send 'xautolock kicking in soon'" -corners 000- -locker 'lockctl.sh -l' -detectsleep -secure &
udiskie &
nextcloud &
protonmail-bridge --no-window &
# Device specific autostarts 
if [ $(hostname) == "bifrost" ]
then
    setxkbmap de && setxkbmap -option ctrl:nocaps  # remap capslock to control
    # remap lenovo print key to context menu key
    xmodmap -e "keycode 107 = Menu" 
    # reduce size in alacritty 
    #sed 's/size: 13/size: 9/g' $HOME/.config/alacritty/alacritty.yml > /tmp/alacritty && cat /tmp/alacritty > $HOME/.config/alacritty/alacritty.yml &
    # start mpd notifications (using dunst)
    # sleep 30 & mpDris2 & # should be started as systemd service
fi &
emacs --daemon --chdir=$HOME &
sleep 5 && $HOME/.scripts/restart_systray.sh stalonetray &
