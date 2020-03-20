#!/bin/bash

# Device specific autostarts 
if [ $(hostname) == "walhall" ]
then
    xrandr --output DisplayPort-0 --off --output DisplayPort-1 --mode 1680x1050 --pos 0x0 --rotate normal --output HDMI-0 --off --output DVI-0 --off --output DVI-1 --primary --mode 1920x1200 --pos 1680x0 --rotate normal &
fi &
xbindkeys &
wmname LG3D & # DWM tweak to get jabref running
#trayer --edge top --align right --expand true --widthtype request --transparent true --alpha 0 --height 18 --tint 0x282a36 --monitor "primary" &
stalonetray &
compton &
nitrogen --restore & 
# urxvtd -q -o -f &
xsetroot -cursor_name left_ptr &
keepassxc &
xrdb -merge ~/.Xresources &
nm-applet &
syncthing-gtk &
dunst &
redshift-gtk -t 6500:3000 -l 48.13:11.57 & 
$HOME/.scripts/deactivateBluetooth &
blueman-applet &
libinput-gestures-setup restart &
xautolock -time 10 -notify 30 -notifier "notify-send 'xautolock kicking in soon'" -corners 000- -locker '$HOME/.scripts/lockscreen.sh' &
udiskie &
synology-drive &
# net speed 
case "$(hostname)" in
    walhall)
	interface="enp4s0"
	;;
    bifrost)
	interface="wlp0s20f3"
	;;
esac && $HOME/.scripts/net_speed.sh $interface &

# Device specific autostarts 
if [ $(hostname) == "bifrost" ]
then
    setxkbmap de &
    setxkbmap -option ctrl:nocaps & # remap capslock to control
    # remap lenovo print key to context menu key
    xmodmap -e "keycode 107 = Menu" &
    # reduce size in alacritty 
    sed 's/size: 11/size: 9/g' $HOME/.config/alacritty/alacritty.yml > /tmp/alacritty && cat /tmp/alacritty > $HOME/.config/alacritty/alacritty.yml &
    # start mpd notifications (using dunst)
    # sleep 30 & mpDris2 & # should be started as systemd service
fi &
emacs --daemon --chdir=$HOME &
sleep 5 && $HOME/.scripts/restart_systray.sh stalonetray &
