#!/bin/sh

CHOICES="Laptop\nDual\nHDMI-only\nManual Selection"

CHOSEN=$(echo -e "$CHOICES" | dmenu -i)



case "$CHOSEN" in
    Laptop) xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI1 --off --output VIRTUAL1 --off;;
    Dual) xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI1 --mode 1920x1080 --pos 1920x0 --rotate normal --output VIRTUAL1 --off;;
    HDMI-only) ;;
    "Manual Selection") ;;
esac

# restart WM
qtile-cmd -o cmd -f restart
