#!/usr/bin/bash

status=$($HOME/.scripts/batterystatus.sh)

perc=$(echo "$status" | sed 's/%.*//g')
state=$(echo "$status" | grep -o '[|ﮣ]')

batterychecker(){
    if [ "$state" == "" ]; then
	if [ "$perc" -lt "29" ]; then
	    notify-send -u critical "Battery critical at $perc%.
Need some juice soon!"
	fi
    fi
}

while true; do
    batterychecker
    sleep 180
done
