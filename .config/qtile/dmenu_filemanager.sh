#!/bin/bash

DMENU="/usr/bin/dmenu -i -p"
FOLDERS="Downloads/\nDocuments/\n.config"

function choose {
    CHOICE=$(echo -e $FOLDERS | $DMENU "Launch file browser at:" )
}

function launch {
    cd $HOME
    pcmanfm $CHOICE
}

choose && launch
