#!/bin/bash

BLUEZCARD=`pactl list cards short | egrep -o bluez.*[[:space:]]`
pactl set-card-profile $BLUEZCARD a2dp_sink
pactl set-card-profile $BLUEZCARD headset_head_unit
pactl set-card-profile $BLUEZCARD a2dp_sink
notify-send -i $HOME/.scripts/icons/bluetooth_headphones.png "Bluetooth Headset" "Audio profile reset"
