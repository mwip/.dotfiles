#!/bin/sh


notify-send 'Emacs' 'Restarting Emacs Daemon'

[ -n "$(pgrep emacs)" ] && killall emacs

emacs --daemon --chdir=$HOME

notify-send 'Emacs' 'Emacs Daemon restarted'
