#!/bin/sh
# inspired by https://github.com/BrodieRobertson/scripts/blob/master/sch
# Opens a dmenu prompt for selecting a search engine and providing a search query
# To avoid issues with spaces and special characters html encoding is applied to the query

DMENU_CMD='dmenu -i -fn "Ubuntu Mono:size=11" -nb "#161616" -nf "#D0D0D0" -sf "#444444" -sb "#c3e88d"'

URL=$(cat ~/.config/search/search|
	  sed 's/:https.*//' | 
	  eval "$DMENU_CMD -p 'Search Engine:'" |
	  xargs -I % grep "%:" ~/.config/search/search |
	  sed 's/.*:https/https/')
SEARCH=$(sort ~/.config/search/search_history |
	    eval "$DMENU_CMD -p 'Search:'")

# Echo to history file
if [ ! "$(grep -q "$SEARCH" < ~/.config/search/search_history)" ]; then
    if [ "$(wc -l < ~/.config/search/search_history)" -gt 500 ]; then
        sed -i "1s/^/$SEARCH\n/;$ d" ~/.config/search/search_history
    else
	[ -n "$SEARCH" ] && echo "$SEARCH" >> ~/.config/search/search_history
    fi
fi

# Open browser if search query provided
[ -n "$SEARCH" ] &&
    [ "$SEARCH" != "" ] &&
    case $SEARCH in
	"~~edit~~")
	    $EDITOR ~/.config/search/search
	    ;;
	*)
	    firefox --new-tab "$1" "$URL$(~/.scripts/encode "$SEARCH")"
    esac &
