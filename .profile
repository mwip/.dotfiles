export EDITOR=/usr/bin/vim
# MPD daemon start (if no other user instance exists)
#[ ! -s ~/.config/mpd/pid ] && mpd
export SUDO_ASKPASS="$HOME/.scripts/dmenu_pass.sh"
