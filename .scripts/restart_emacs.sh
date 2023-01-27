#!/bin/sh


notify-send 'Emacs' 'Restarting Emacs Daemon'

[ -n "$(pgrep emacs)" ] && emacsclient -e '(server-shutdown)'

emacs --daemon --chdir=$HOME

notify-send 'Emacs' 'Emacs Daemon restarted'
