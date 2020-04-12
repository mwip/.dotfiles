#!/bin/bash

DMENU="/usr/bin/dmenu -i -p"
FOLDERS="home\nCloudStation\nDownloads/\nDocuments/\n.config\n~~edit~~"

FILEMNGR="doublecmd -T"

CHOICE=$(echo -e $FOLDERS | $DMENU "Launch file browser at:" )

case $CHOICE in
    home)
	$FILEMNGR $HOME
	;;
    '~~edit~~')
	$MYTERM vim ${BASH_SOURCE[0]}
	;;
    *)
	doublecmd -T $CHOICE
esac


