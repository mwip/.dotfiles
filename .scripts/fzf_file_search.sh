#!/bin/sh

file=$(find . -maxdepth 4 | fzf --preview='pistol {}')

prgrm=$(echo -e "emacsclient\nvim\nless\ncat\nxclip" | dmenu -i -p "Open with: " | sed "s/emacsclient/emacsclient -c -n -a ''/")

case $prgrm in
    xclip)
	echo "$file" | xclip -r
	;;
    "")
	echo "$file"
      ;;
    *)
	$prgrm $file
	;;
esac
