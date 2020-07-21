#!/usr/bin/bash

if [ $1 == "stalonetray" ]; then
    # raise the window to top
    xdotool search --class stalonetray windowraise
    # move the window to the outer right corner minus its own x-size
    xdotool search --class stalonetray windowmove \
	    $(( 1920 * 2 - \
	    $(xdotool search --class stalonetray getwindowgeometry | \
	      grep Geometry | sed 's/  Geometry: //;s/x.*//') )) y
fi
