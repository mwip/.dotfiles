#!/bin/bash

# use imagemagick to select a region for screenshot. 
import /tmp/shot.png
# copy the screenshot to the clipboard
xclip -selection clipboard -t image/png -i /tmp/shot.png
# send a notification to the system
notify-send "Screenshot copied to clipboard"
