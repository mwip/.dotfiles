#!/bin/sh
# inspired by https://github.com/BrodieRobertson/scripts/blob/master/sch
# Opens a dmenu prompt for selecting a search engine and providing a search query
# To avoid issues with spaces and special characters html encoding is applied to the query

url=$(cat ~/.config/search/search |
	  sed 's/:https.*//' |
	  dmenu -i -p "Search Engine" |
	  xargs -I % grep "%:" ~/.config/search/search |
	  sed 's/.*:https/https/')
search=$(sort ~/.config/search/search_history |
	     dmenu -i -p "Search")

# Echo to history file
if [ ! "$(grep -q "$search" < ~/.config/search/search_history)" ]; then
    if [ "$(wc -l < ~/.config/search/search_history)" -gt 500 ]; then
        sed -i "1s/^/$search\n/;$ d" ~/.config/search/search_history
    else
        echo "$search" >> ~/.config/search/search_history
    fi
fi

# Open browser if search query provided
[ -n "$search" ] &&
    [ "$search" != "" ] &&
    firefox --new-tab "$1" "$url$(~/.scripts/encode "$search")" &
