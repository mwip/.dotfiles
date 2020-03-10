#!/usr/bin/bash

text="$(cat /home/loki/.xmonad/xmonad.hs | sed -n '/^myKeys =/,/^]/p;/^        ]/q')"
echo "$text" | less
