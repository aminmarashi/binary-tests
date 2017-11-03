#! /bin/bash

./stop.sh && ./run.sh "$@"
./watch.sh "-p --interval=10 $@" > output.log &
./watch.sh "-p $@"
