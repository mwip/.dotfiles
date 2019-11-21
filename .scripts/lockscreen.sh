#!/bin/bash
ICON=$HOME/.scripts/icon.png
TMPBG=/tmp/screen.png
scrot $TMPBG
convert $TMPBG -scale 5% -scale 2000% $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
i3lock -u -i $TMPBG
sleep 5 & rm $TMPBG
