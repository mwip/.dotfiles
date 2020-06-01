#!/usr/bin/sh

RX=$(( $(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+' ) ))
TX=$(( $(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+' ) )) 
UT=$(date +'%s')

LOGFILE="$HOME/.cache/net.log"
LOGDATA=$(cat $LOGFILE)

UT_prev=$(echo $LOGDATA | cut -d' ' -f1)
RX_prev=$(echo $LOGDATA | cut -d' ' -f2)
TX_prev=$(echo $LOGDATA | cut -d' ' -f3)

echo " : $(( ($RX-$RX_prev)/($UT-$UT_prev)*8/(1024**2) )) Mbit/s : $(( ($TX-$TX_prev)/($UT-$UT_prev)*8/(1024**2) )) Mbit/s"
echo "$UT $RX $TX" > $LOGFILE
