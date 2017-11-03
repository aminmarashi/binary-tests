#! /bin/bash

. config

ARG_RE='[\s=]*\K[^\s^=]*'

PROGRESS_ARG=$(echo $@ | grep -oP -- '-p|--progress');
INTERVAL_ARG=$(echo $@ | grep -oP -- "--interval$ARG_RE")
ALIVE_TIMEOUT_ARG=$(echo $@ | grep -oP -- "--alive-timeout$ARG_RE")
ALIVE_CHECK_ARG=$(echo $@ | grep -oP -- "--alive-check=\K.*")

test -n "$PROGRESS_ARG" && PROGRESS="$PROGRESS_ARG"
test -n "$INTERVAL_ARG" && INTERVAL="$INTERVAL_ARG"
test -n "$ALIVE_TIMEOUT_ARG" && ALIVE_TIMEOUT="$ALIVE_TIMEOUT_ARG"
test -n "$ALIVE_CHECK_ARG" && ALIVE_CHECK="$ALIVE_CHECK_ARG"

test -z "$INTERVAL" && INTERVAL=1
test -z "$ALIVE_TIMEOUT" && ALIVE_TIMEOUT=10
test -z "$ALIVE_CHECK" && ALIVE_CHECK=":"

is_alive() {
    ALIVE=`echo $ALIVE_LIST | grep $1`
    eval "$ALIVE_CHECK"
    if [ $? -eq 0 -a -n "$ALIVE" ]; then
        OUTPUT="$OUTPUT+"
    else
        OUTPUT="$OUTPUT."
    fi
}

if [ -n "$PROGRESS" ]; then
    echo -e 'Time\t|# Alive|Alive Tests'
    while : ; do
        ALIVE_LIST=`find logs -newermt "-$ALIVE_TIMEOUT seconds"`
        for i in logs/*; do
            is_alive $i;
        done
	COUNT=`echo $OUTPUT |grep + -o |wc -l`
        echo -e `date +'%H:%M:%S'`"|$COUNT\t|$OUTPUT"
	OUTPUT=''
	sleep $INTERVAL;
    done
else
    watch -n $INTERVAL 'tail -n 1 logs/*.pl.log'
fi

exit 1;
