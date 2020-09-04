#!/bin/sh

CACHE_FILE=~/.cache/wp/sentinel_calendar_$(date +%m).jpg

mkdir -p ~/.cache/wp/

URL="https://esamultimedia.esa.int/multimedia/eo/calendar2020/2020_Sentinels_digital_calendar_1920x1080_$(date +%m).jpg"

while [ ! -f $CACHE_FILE ];
do
    wget $URL -O $CACHE_FILE
done

BG_COL=$(convert $CACHE_FILE -resize 1x1 txt:- | grep -Po "#[[:xdigit:]]{6}")

feh -B "$BG_COL" --bg-max $CACHE_FILE
