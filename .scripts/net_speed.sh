#!/bin/bash

# borrowed this script from Vicente Hernando
# https://linuxclues.blogspot.com/2009/11/shell-script-show-network-speed.html

# This shell script shows the network speed, both received and transmitted.

# Usage: net_speed.sh interface
#   e.g: net_speed.sh eth0


# Global variables
update_interval=2
interface=$1
received_bytes=""
old_received_bytes=""
transmitted_bytes=""
old_transmitted_bytes=""


# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes
{
line=$(cat /proc/net/dev | grep $interface | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
eval $line
}


# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.
function get_velocity
{
value=$1*8    
old_value=$2*8

let vel=($value-$old_value)/$update_interval
let velMbit=$vel/1024/1024
echo -n "$velMbit Mbit/s"
}

# Gets initial values.
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes

# Shows a message and waits for one second.
# echo "Starting...";
sleep 1;
# echo "";


# Main loop. It will repeat forever.
while true; 
do

# Get new transmitted and received byte number values.
get_bytes

# Calculates speeds.
vel_recv=$(get_velocity $received_bytes $old_received_bytes)
vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes)

# Shows results in the console.
echo -en "$interface : $vel_recv : $vel_trans\r" > $HOME/.cache/networktraffic

# Update old values to perform new calculations.
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes

# Waits one second.
sleep $update_interval;

done
