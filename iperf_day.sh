#!/bin/sh

#SERVER=bouygues.testdebit.info
SERVER=bouygues.iperf.fr
#ping.online.net
OUTPUT_FILE=/root/dwltest/daily_results.log

die() {
    echo "$1" | logger $msg
exit
}

logger "iperf dwl measure start, server: $SERVER"

#Rx state of wan interface
rx_state_start=`cat /proc/net/dev | awk '/br-wan/{ print $2 }'`

json=`iperf3 -R -J -p 5209 -c $SERVER` 

rx_state_end=`cat /proc/net/dev | awk '/br-wan/{ print $2 }'`

if [[ $? -ne 0 ]]; then
    die "cannot contact server: $SERVER"
fi


jsonout=`echo "$json" | /root/dwltest/parse_iperf.lua`

if [[ "$?" -ne 0 ]]; then
    die "iperf fail!: $SERVER"
fi


iperf_transfer=`echo "$jsonout" | awk '{ print $2 }'`

if [[ $((rx_state_end - rx_state_start - iperf_transfer)) -gt $((iperf_transfer + 10*1024)) ]]; then
    die "iperf invalid value: $SERVER"
fi

echo $jsonout >> $OUTPUT_FILE

if [[ $? -ne 0 ]]; then
    die "iperf fail!: $SERVER"
fi

