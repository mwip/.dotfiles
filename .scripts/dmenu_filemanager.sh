#!/bin/bash

DMENU="/usr/bin/dmenu -i -p"
FOLDERS="home\nCloudStation\nDownloads/\nDocuments/\n.config"

function choose {
    CHOICE=$(echo -e $FOLDERS | $DMENU "Launch file browser at:" )
}

function launch {
    cd $HOME
    if [ $CHOICE == "home" ]
    then
	CHOICE=""
    fi
    pcmanfm $CHOICE
}

choose && launch
