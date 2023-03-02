#!/bin/bash

DMENU="/usr/bin/rofi -dmenu -i -p "
# FONT="-fn \"Ubuntu Mono-14\""
# COLORS=' -nb darkred -sb red -sf white -nf gray '

# DMENU="/usr/bin/rofi -dmenu -i -l \
        # -theme ~/.config/rofi/dmenu-custom.rasi"
FIRST_MENU="Lock\nLogout\nSuspend\nReboot\nShutdown"
SECOND_MENU="No\nYes"
ACTION=""

function choose {
    CHOICE=$(echo -e $FIRST_MENU | $DMENU "Select an Option")
}

function confirm {
    if [ "$CHOICE" == "Lock" ]; then
        CONFIRM="Yes"
    else
        CONFIRM=$(echo -e $SECOND_MENU | $DMENU "$CHOICE: Are You Sure?")
    fi
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
