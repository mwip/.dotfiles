#! /usr/bin/bash

raw=$(/usr/bin/xbacklight -get)
round="$(echo $raw | awk '{print int($1+0.5)}')%"
echo " "$round
