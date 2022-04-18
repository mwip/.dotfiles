#!/bin/sh
# Device specific autostarts 
if [ $(hostname) == "andlang" ]
then
    xrandr --output DisplayPort-0 --primary --mode 1920x1200 --pos 1920x0 --rotate normal --output DisplayPort-1 --mode 1920x1200 --pos 0x0 --rotate normal --output DisplayPort-2 --off --output HDMI-A-0 --off
    setxkbmap de
    imwheel
fi &
if [ $(hostname) == "bifrost" ]
then
    setxkbmap de && setxkbmap -option ctrl:nocaps  # remap capslock to control
    # remap lenovo print key to context menu key
    xmodmap -e "keycode 107 = Menu" 
fi &

libinput-gestures-setup restart &
xbindkeys &
picom &
sleep 5 && copernicus_wallpaper.sh &
xsetroot -cursor_name left_ptr &
nm-applet &
xset r rate 280 28 &
emacs --daemon --chdir=$HOME &
keepassxc &
syncthing-gtk &
dunst &
redshift-gtk -t 6500:3000 -l 48.13:11.57 & 
xfce4-power-manager &
$HOME/.scripts/deactivateBluetooth &
blueman-applet &
xautolock -time 10 -notify 30 -notifier "notify-send 'xautolock kicking in soon'" -corners ---- -locker 'betterlockscreen -l blur' -detectsleep  &
protonmail-bridge --no-window &
udiskie &
nextcloud &
flameshot &
betterlockscreen -u $(/usr/bin/ls ~/Pictures/Wallpapers/* | shuf -n1) --blur 1 &
cp $HOME/.scripts/audio-volume-change.wav /tmp/avc.wav &

