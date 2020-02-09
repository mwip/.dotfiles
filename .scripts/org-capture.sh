#!/usr/bin/bash
# got the idea from
# https://www.reddit.com/r/emacs/comments/74gkeq/system_wide_org_capture/
emacsclient -c -F '(quote (name . "capture"))' -e '(activate-capture-frame)'
