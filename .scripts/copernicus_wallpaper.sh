#!/bin/sh
# dependencies:
#   - feh
#   - wget
#   - imagemagick

YEAR=$(date +%Y)
MNTH=$(date +%m)

mkdir -p ~/.cache/wp/

CACHE_FILE=~/.cache/wp/sentinel_calendar_$YEAR$MNTH.jpg
URL="https://esamultimedia.esa.int/img/2023/01/2023_Sentinels_GeneralWeb_1024x768_$(echo $MNTH | sed s/^0//).jpg"

if [ ! -f $CACHE_FILE ]; then
    until wget $URL -O $CACHE_FILE > /dev/null
    do
	echo "No success... Wait and retry"
        sleep 5
    done
fi

BG_COL=$(convert $CACHE_FILE -resize 1x1 txt:- | grep -Po "#[[:xdigit:]]{6}")

feh -B "$BG_COL" --bg-max $CACHE_FILE
