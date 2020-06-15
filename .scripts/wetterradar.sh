#!/bin/sh

notify-send "Loading Weather Radar" "Please wait..."

mpv --loop-file=inf "https://www.dwd.de/DWD/wetter/radar/radfilm_bay_akt.gif"
