#! /usr/bin/bash

kill $(pstree -lp | grep -- -dwmbar | sed 's/.*sleep(\([[:digit:]]*\))/\1/')

