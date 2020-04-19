#!/bin/bash

DMENU_CMD='dmenu -i -fn "Ubuntu Mono:size=11" -nb "#161616" -nf "#D0D0D0" -sf "#444444" -sb "#82AAFF"'
FOLDERS="home\nCloudStation\nDownloads/\nDocuments/\n.config\n.scripts\n~~edit~~"

CHOICE=$(echo -e $FOLDERS | eval "$DMENU_CMD -p 'Launch $(echo $MYFILEMNGR | awk '{print $1}') at:'" )

[ -n "$CHOICE" ] &&
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
