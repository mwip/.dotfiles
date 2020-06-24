#!/bin/sh
# dependencies:
#  - wget
#  - imagemagick
#  - sxiv

COUNT=30
SEARX_INSTANCE="https://searx.lnode.net/"
TMP_FOLDER="/tmp/artwork/"

# guess album title from current folder
FOLDER=$(pwd | xargs -0 -I % basename %)
PARENT_FOLDER=$(pwd | xargs -0 -I % dirname % | xargs -0 -I % basename %)
# echo $FOLDER

read -p "Album title (press ENTER to use \"$(echo $FOLDER)\"): " ALBUM
[ -z "$ALBUM" ] && ALBUM="$FOLDER"
read -p "Artist (press ENTER to use \"$(echo $PARENT_FOLDER)\"): " ARTIST
[ -z "$ARTIST" ] && ARTIST="$PARENT_FOLDER"
read -p "Additional search terms (press ENTER to use \"album cover image\"): " ETC
[ -z "$ETC" ] && ETC="album cover image"
SEARCH="$ARTIST $ALBUM $ETC"
echo -e "\nSearching for \"$SEARCH\""

SEARCH_ENCODED=$(echo $SEARCH | sed 's/%/%25/g;s/\s/%20/g;s/!/%21/g;s/"/%22/g;s/#/%22/g;s/\$/%24/g;s/&/%26/g;s/\x27/%27/g;s/)/%29/g;s/(/%28/g;s/\*/%2A/g;s/\+/%2B/g;s/,/%2C/g;s/-/%2D/g;s/\./%2E/g;s/\//%2F/g;s/:/%3A/g;s/;/%3B/g;s/</%3C/g;s/=/%3D/g;s/>/%3E/g;s/\?/%3F/g;s/@/%40/g;s/]/%5D/g;s/\\/%5C/g;s/\[/%5B/g;s/\^/%5E/g;s/_/%5F/g;s/`/%60/g;s/}/%7D/g;s/|/%7C/g;s/{/%7B/g;s/~/%7E/g;')
# echo -e $SEARCH_ENCODED

URL="$SEARX_INSTANCE?q=$SEARCH_ENCODED&categories=images"
# echo $URL

IMAGES=$(wget --user-agent 'Mozilla/5.0' -qO - $URL |
    sed 's/</\n</' |
    grep '<img' |
    head -n"$COUNT" |
    sed 's/.*src="\([^"]*\)".*/\1/g'|
    sed 's/\ /\n/g')
#echo "$IMAGES" 

mkdir -p $TMP_FOLDER
while IFS= read -r IMAGE; do
    COUNTER=$(($COUNTER + 1))
    wget -qO "$TMP_FOLDER$COUNTER.png" "$IMAGE"
done <<< "$IMAGES"


notify-send "Get Artwork" "Keys:\nM: Select artwork\nQ: Quit selection"
SELECTED_IMAGE=$(sxiv -to $TMP_FOLDER)
# echo "$SELECTED_IMAGE"

TARGET=$(echo "./folder.jpg" | sed 's/ /\\ /g;s/(/\)/g;s/)/\)/g')

# echo $TARGET
# echo $SELECTED_IMAGE
[ -n "$SELECTED_IMAGE" ] &&
    convert $SELECTED_IMAGE $TARGET &&
    notify-send -i "$(pwd)/folder.jpg" "Get Artwork" "Artwork downloaded and converted"

rm -rf $TMP_FOLDER



