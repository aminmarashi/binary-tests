#! /bin/bash

. config

ARG_RE='[\s=]*\K[^\s^=]*'

PROGRESS_ARG=$(echo $@ | grep -oP -- '-p|--progress');
INTERVAL_ARG=$(echo $@ | grep -oP -- "--interval$ARG_RE")

test -n "$PROGRESS_ARG" && PROGRESS="$PROGRESS_ARG"
test -n "$INTERVAL_ARG" && INTERVAL="$INTERVAL_ARG"

test -z "$INTERVAL" && INTERVAL=1

is_alive() {
    echo $ALIVE_LIST | grep $1 >/dev/null
    if [ $? -eq 0 ]; then
        OUTPUT="$OUTPUT+"
    else
        OUTPUT="$OUTPUT."
    fi
}

if [ -n "$PROGRESS" ]; then
    while : ; do
        ALIVE_LIST=`find logs -newermt '-10 seconds'`
        for i in logs/*; do
        is_alive $i;
        done
        echo $OUTPUT
	OUTPUT=''
	sleep $INTERVAL;
    done
else
    watch -n $INTERVAL 'tail -n 1 logs/*.pl.log'
fi

exit 1;
