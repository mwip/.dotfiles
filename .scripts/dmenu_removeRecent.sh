#!/bin/bash

# a script to remove items from the dmenu_recent.sh cache

recent_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dmenu-recent/recent"

# echo $recent_cache



removal=$(cat "$recent_cache" | dmenu -p 'Remove from recent:')

mv $recent_cache $recent_cache.bak

grep -vx "$removal" $recent_cache.bak > $recent_cache

rm $recent_cache.bak





