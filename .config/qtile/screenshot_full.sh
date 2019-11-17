#!/bin/bash

# create dynamic file name 
FILE="$HOME/Pictures/screenshots/$(date +"%Y-%m-%d_%H-%M-%S.png")"
# create folder if not existing
mkdir -p "$HOME/Pictures/screenshots"
# take screenshot and save to file
scrot $FILE
# copy the screenshot to the clipboard
xclip -selection clipboard -t image/png -i $FILE
# send a notification to the system
notify-send "Screenshot copied to clipboard"
