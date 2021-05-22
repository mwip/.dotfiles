export EDITOR=/usr/bin/vim
export TERM=xterm-256color
# MPD daemon start (if no other user instance exists)
#[ ! -s ~/.config/mpd/pid ] && mpd
export SUDO_ASKPASS="$HOME/.scripts/dmenu_pass.sh"
#source /opt/OTB-7.1.0-Linux64/otbenv.profile
export QT_QPA_PLATFORMTHEME="qt5ct"

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep xmonad || startx
fi
