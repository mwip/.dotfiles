#!/usr/bin/env bash

# some variables, cache etc.
cache_folder=/tmp/dwd_wttr
img_program=sxiv

# first ask for location using dmenu, use $DWD_LOCATION if left empty
region=$(echo -e "$DWD_LOCATION (default set as env. variable DWD_LOCATION)\n\
Bayern\n\
Baden-Württemberg\n\
Berlin und Brandenburg\n\
Hessen\n\
Mecklenburg-Vorpommern\n\
Niedersachsen und Bremen\n\
Nordrhein-Westfalen\n\
Rheinland-Pfalz und Saarland\n\
Sachsen\n\
Sachsen-Anhalt\n\
Schleswig-Holstein und Hamburg\n\
Thüringen\n\
Deutschland" | dmenu -i -l 10 -p "Choose your region:")

# if used from $DWD_LOCATION, remove parantheses
region=$(echo $region | sed "s/\s*(.*)//g")

[[ "$region" = "Use $DWD_LOCATION" ]] && region=$DWD_LOCATION
[[ -z $region ]] && region="Deutschland"

# Substitute region for abbreviation. Used for creating URL.
case $region in
    "Bayern")                         abbr="bay" ;;
    "Baden-Württemberg")              abbr="baw" ;;
    "Berlin und Brandenburg")         abbr="bbb" ;;
    "Hessen")                         abbr="hes" ;;
    "Mecklenburg-Vorpommern")         abbr="mvp" ;;
    "Niedersachsen und Bremen")       abbr="nib" ;;
    "Nordrhein-Westfalen")            abbr="nrw" ;;
    "Rheinland-Pfalz und Saarland")   abbr="rps" ;;
    "Sachsen")                        abbr="sac" ;;
    "Sachsen-Anhalt")                 abbr="saa" ;;
    "Schleswig-Holstein und Hamburg") abbr="shh" ;;
    "Thüringen")                      abbr="thu" ;;
    "Deutschland")                    abbr="brd" ;;
esac

# create and clean cache folder
mkdir -p $cache_folder
rm -f $cache_folder/*

# create urls and file order
prefix="https://www.dwd.de/DWD/wetter/wv_allg/deutschland/bilder/vhs_$abbr"
order="
${prefix}_heutefrueh.jpg\n
${prefix}_heutemittag.jpg\n
${prefix}_heutespaet.jpg\n
${prefix}_heutenacht.jpg\n
${prefix}_morgenfrueh.jpg\n
${prefix}_morgenspaet.jpg\n
${prefix}_uebermorgenfrueh.jpg\n
${prefix}_uebermorgenspaet.jpg\n
${prefix}_tag4frueh.jpg\n
${prefix}_tag4spaet.jpg\n
"

# download the images
echo -e $order | xargs -P 10 -n 1 wget -qP $cache_folder > /dev/null

# imagemagick montage
montage $(echo -e $order | sed "s|https.*bilder|$cache_folder|g") -tile 2x5 -geometry +2+2 \
 $cache_folder/dwd_wttr.jpg

$img_program $cache_folder/dwd_wttr.jpg &

