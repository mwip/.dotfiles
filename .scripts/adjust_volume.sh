#!/bin/bash

PERCENT=5
MAXVOLUME=200
SOUND=$HOME/.scripts/audio-volume-change.wav
TMPSOUND=/tmp/audio-volume-change.wav
GST='mpv'
# pactl version
# pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $1$PERCENT% && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga

[ ! -f $TMPSOUND ] && cp $SOUND $TMPSOUND

# pamixer version
if [ $1 == '+' ]
then
    if [ $(pamixer --get-volume) -lt "$MAXVOLUME" ]
       then	
	   $($GST $TMPSOUND) > /dev/null &
	   pamixer -i $PERCENT --allow-boost &
    fi
fi

if [ $1 == '-' ]
then
   $($GST $TMPSOUND) > /dev/null &
   pamixer -d $PERCENT --allow-boost &
fi    
   
if [ $1 == 'm' ]
then
    $($GST $TMPSOUND) > /dev/null &
    pamixer -t --allow-boost &
fi
