#!/bin/bash

STATUS=$(mpc | grep -E "(playing|paused)")
#echo $STATUS

if [[ $STATUS == *"playing"* ]]
then
    mpc pause
else
    mpc play
fi

