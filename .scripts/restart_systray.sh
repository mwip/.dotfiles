#!/usr/bin/bash

if [ $1 == "trayer" ]; then
    killall trayer && trayer --edge top --align right --expand true --widthtype request --transparent true --alpha 0 --height 18 --tint 0x282a36 --monitor "primary" &
fi

if [ $1 == "stalonetray" ]; then
    killall stalonetray && stalonetray &
fi
