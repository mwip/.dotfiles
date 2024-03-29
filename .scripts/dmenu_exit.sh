#!/bin/bash

#USERNAME=${SUDO_USER:-$(id -u -n)}
#HOMEDIR="/home/$USERNAME"
DMENU="/usr/bin/dmenu -i -p "
FONT="-fn \"Ubuntu Mono-14\""
COLORS=' -nb darkred -sb red -sf white -nf gray '

#ROFI="/usr/bin/rofi -dmenu -i -l \
#         -theme ~/.config/rofi/dmenu-custom.rasi"
FIRST_MENU="Lock\nLogout\nSuspend\nReboot\nShutdown"
SECOND_MENU="No\nYes"
ACTION=""

function choose {
    CHOICE=$(echo -e $FIRST_MENU | $DMENU "" $COLORS )
}

function confirm {
    CONFIRM=$(echo -e $SECOND_MENU | $DMENU "Are You Sure?" $COLORS )
}

function execute {
    if [ "$CHOICE" == "Lock" ];then
	ACTION="betterlockscreen -l blur"
    elif [ "$CHOICE" == "Logout" ];then
	 [ -n "$(ps -a | grep qtile)" ] && ACTION="pkill qtile"
	 [ -n "$(ps -a | grep xmonad)" ] && ACTION="pkill xmonad"
    elif [ "$CHOICE" == "Suspend" ];then
	ACTION="/bin/systemctl -i suspend"
    elif [ "$CHOICE" == "Reboot" ];then
	ACTION="/bin/systemctl -i reboot"
    elif [ "$CHOICE" == "Shutdown" ];then
	ACTION="/bin/systemctl -i poweroff"
    fi
    
    if [ "$CONFIRM" == "Yes" ];then
	${ACTION}
    fi
}

choose && confirm && execute

exit 0



