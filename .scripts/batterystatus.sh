#! /usr/bin/bash

pwr=$(/usr/bin/upower -i /org/freedesktop/UPower/devices/battery_BAT0)

state="$(echo "$pwr" | grep -e state | sed 's/.*state:[[:space:]]*//g')"
ttemp="$(echo "$pwr" | grep -e 'time to empty' | sed 's/.*time to empty: //g')"
ttful="$(echo "$pwr" | grep -e 'time to full' | sed 's/.*time to full: //g')"
perct="$(echo "$pwr" | grep -e 'percentage' | sed 's/.*percentage: //g')"

if [ "$state" == "charging" ];
then
    state="$(echo $state | sed 's/charging/ ﮣ /')"
    out="$perct $state $ttful"
fi

if [ "$state" == "discharging" ];
then
    state="$(echo $state | sed 's/discharging/  /')"
    out="$perct $state $ttemp"
fi

if [ "$state" == "fully-charged" ];
then
    state="$(echo $state | sed 's/fully-charged/  fully charged/')"
    out="$state"
fi


echo $out
