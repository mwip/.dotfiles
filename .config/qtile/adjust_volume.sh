#!/bin/bash

PERCENT=5

pactl set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo $1$PERCENT% && gst-play-1.0 $HOME/.config/qtile/audio-volume-change.oga
