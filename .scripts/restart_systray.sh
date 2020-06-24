#!/usr/bin/bash

if [ $1 == "stalonetray" ]; then
    xdotool search --class stalonetray windowraise
fi
