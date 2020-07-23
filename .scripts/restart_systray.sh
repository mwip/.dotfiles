#!/usr/bin/bash

if [ $1 == "stalonetray" ]; then
    # raise the window to top
    xdotool search --class stalonetray windowraise
    # set multiplyer for different displays using hostnames
    case $(hostname) in 
	    andlang) 
		    multiplyer=2
		    ;;
	    *)
		    multiplyer=1
		    ;;
    esac
    # move the window to the outer right corner minus its own x-size
    xdotool search --class stalonetray windowmove \
	    $(( 1920 * $multiplyer - \
	    $(xdotool search --class stalonetray getwindowgeometry | \
	      grep Geometry | sed 's/  Geometry: //;s/x.*//') )) y
fi

