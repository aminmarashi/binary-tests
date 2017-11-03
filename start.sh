#! /bin/bash

./stop.sh && ./run.sh "$@" && ./watch.sh "-p $@"
