#!/bin/bash

PERCENT=5
MAXVOLUME=200
SOUND=.scripts/audio-volume-change.oga

# pactl version
# pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $1$PERCENT% && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga

# pamixer version
if [ $1 == '+' ]
then
    if [ $(pamixer --get-volume) -lt "$MAXVOLUME" ]
       then
	   pamixer -i $PERCENT --allow-boost && gst-play-1.0 $SOUND
    fi
fi

if [ $1 == '-' ]
then
   pamixer -d $PERCENT --allow-boost && gst-play-1.0 $SOUND
fi    
   
if [ $1 == 'm' ]
then
    pamixer -t --allow-boost && gst-play-1.0 $SOUND
fi
