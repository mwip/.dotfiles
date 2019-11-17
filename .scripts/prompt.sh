#!/usr/bin/env sh
# A dmenu binary prompt script.
# Gives a dmenu prompt labeled with $1 to perform command $2.
# For example:
# `./prompt "Do you want to shutdown?" "shutdown -h now"`
# source: https://github.com/LukeSmithxyz/voidrice/blob/ff0366fc7dd456bc363015da09749942d9308d94/.local/bin/i3cmds/prompt

[ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray )" = "Yes" ] && $2
