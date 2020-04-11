#!/bin/sh

file=$(find . -maxdepth 4 | fzf --preview='pistol {}')

prgrm=$(echo -e "emacsclient\nvim\nless\ncat" | dmenu -i -p "Open with: ")

$prgrm $file
