#!/bin/sh
# dependencies:
#   - feh
#   - wget
#   - imagemagick

YEAR=$(date +%Y)
MNTH=$(date +%m)

mkdir -p ~/.cache/wp/

CACHE_FILE=~/.cache/wp/sentinel_calendar_$YEAR$MNTH.jpg
URL="https://esamultimedia.esa.int/img/2021/12/2022_Sentinels_digital_calendar_1024x768_211215$(echo $MNTH | sed s/^0// | sed s/^1$//).jpg"

if [ ! -f $CACHE_FILE ]; then
    until wget $URL -O $CACHE_FILE &> /dev/null
    do
	echo "No success... Wait and retry"
        sleep 5
    done
fi

BG_COL=$(convert $CACHE_FILE -resize 1x1 txt:- | grep -Po "#[[:xdigit:]]{6}")

feh -B "$BG_COL" --bg-max $CACHE_FILE
