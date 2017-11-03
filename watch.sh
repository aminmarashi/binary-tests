#! /bin/bash

export PROGRESS=$(echo $@ | grep -oP -- '-p|--progress');

is_alive() {
    tail -n 1 $1 | grep Contract >/dev/null
    if [ $? -eq 0 ]; then
        echo -n +
    else
        echo -n .
    fi
}

if [ -n "$PROGRESS" ]; then
    while : ; do
        for i in logs/*; do
        is_alive $i;
        done
        echo
    done
else
    watch -n 1 'tail -n 1 logs/*.pl.log '
fi
