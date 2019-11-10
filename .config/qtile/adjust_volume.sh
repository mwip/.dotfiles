#!/bin/bash

PERCENT=5

# pactl version
# pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $1$PERCENT% && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga

# pamixer version
if [ $1 == '+' ]
then
   pamixer -i $PERCENT && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga
fi

if [ $1 == '-' ]
then
   pamixer -d $PERCENT && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga
fi    
   
if [ $1 == 'm' ]
then
    if [ $(pamixer --get-volume-human) == 'muted' ]
    then
	pamixer -u && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga
    else
	pamixer -m
    fi
fi
