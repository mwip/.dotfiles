#!/bin/sh
# Script using xcolor to pick a color and send a notification.
# This is especially useful in window managers as it focus stealing behavior
# does not affect it. 

COLOR=$(xcolor)

notify-send "Color picker" \
	    "<span color='$COLOR'>$COLOR</span> copied to clipboard" -t 10000
echo -e $COLOR | xclip -selection clipboard -r
