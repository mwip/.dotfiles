export SUDO_ASKPASS="$HOME/.scripts/dmenu_pass.sh"

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep xmonad || startx
fi
