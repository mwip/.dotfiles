#!/usr/bin/sh

# get current net stats and timestamp
RX=$(( $(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+' ) ))
TX=$(( $(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+' ) )) 
UT=$(date +'%s')

# read data from log file
LOGFILE="$HOME/.cache/net.log"
touch $LOGFILE
LOGDATA=$(cat $LOGFILE | head -n 1)
PREVTEXT=$(cat $LOGFILE | tail -n 1)


# if the log file was not empty, extract previous data and calculate time diff
if [ -n "$LOGDATA" ]; then
    # extract prevoius data form the log file
    UT_prev=$(echo $LOGDATA | cut -d' ' -f1)
    RX_prev=$(echo $LOGDATA | cut -d' ' -f2)
    TX_prev=$(echo $LOGDATA | cut -d' ' -f3)
    UT_diff=$(( $UT-$UT_prev ))
    # check whether the time difference is 0 (to avoid division by zero error)
    if [ $UT_diff -ne 0 ]; then
	# calculate net speeds and create output text
	RX_text=$(( (($RX-$RX_prev)*8)/$UT_diff/(1024**2) ))
	TX_text=$(( (($TX-$TX_prev)*8)/$UT_diff/(1024**2) ))
	TEXT=" : $RX_text Mbit/s : $TX_text Mbit/s"
    else
	# if time difference is 0 then use prevous text
	TEXT=$PREVTEXT
    fi
else
    # if it was empty, use echo empty text
    TEXT="caching net stats..."
fi


# write the current data and text to the log file
cat <<EOF > $LOGFILE
$UT $RX $TX
$TEXT
EOF

# return text to stdout
echo $TEXT
