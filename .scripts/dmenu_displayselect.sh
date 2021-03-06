#!/bin/sh

CHOICES="Laptop\nDual\nHDMI-only\nManual Selection\n~~edit~~"
DMENU_CMD='dmenu -i -fn "Ubuntu Mono:size=11" -nb "#161616" -nf "#D0D0D0" -sf "#444444" -sb "#479E61"'
CHOSEN=$(echo -e "$CHOICES" | eval "$DMENU_CMD -p 'Select the xrandr preset:'")

[ -n "$CHOSEN" ] &&
    case "$CHOSEN" in
	Laptop)
	    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI1 --off --output VIRTUAL1 --off
	    ;;
	Dual)
	    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI1 --mode 1920x1080 --pos 1920x0 --rotate normal --output VIRTUAL1 --off
	    ;;
	HDMI-only)
	    xrandr --output eDP1 --off --output DP1 --off --output DP2 --off --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
	    ;;
	"Manual Selection")
	    arandr
	    ;;
	"~~edit~~")
	    $MYTERM vim ${BASH_SOURCE[0]}
esac &&
    xmonad --restart && sleep 3 && $HOME/.scripts/restart_systray.sh stalonetray &
