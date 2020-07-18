#!/bin/bash

PERCENT=5
MAXVOLUME=200
SOUND=.scripts/audio-volume-change.wav
GST='gst-play-1.0 -q --no-interactive --volume=1.0'
# pactl version
# pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $1$PERCENT% && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga

# pamixer version
if [ $1 == '+' ]
then
    if [ $(pamixer --get-volume) -lt "$MAXVOLUME" ]
       then	
	   $($GST $SOUND) &
	   pamixer -i $PERCENT --allow-boost &
    fi
fi

if [ $1 == '-' ]
then
   $($GST $SOUND) &
   pamixer -d $PERCENT --allow-boost &
fi    
   
if [ $1 == 'm' ]
then
    $($GST $SOUND)  &
    pamixer -t --allow-boost &
fi
