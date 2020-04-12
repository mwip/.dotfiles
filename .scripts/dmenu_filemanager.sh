#!/bin/bash

DMENU="/usr/bin/dmenu -i -p"
FOLDERS="home\nCloudStation\nDownloads/\nDocuments/\n.config\n~~edit~~"

CHOICE=$(echo -e $FOLDERS | $DMENU "Launch file browser at:" )

case $CHOICE in
    home)
	$MYFILEMNGR $HOME
	;;
    '~~edit~~')
	$MYTERM vim ${BASH_SOURCE[0]}
	;;
    *)
	doublecmd -T $CHOICE
esac


