#! /bin/bash
. test.config

trap 'pkill -P $$' EXIT

perl -I$LIB_PATH/BinaryAsyncClient/lib -I$LIB_PATH -l "$@"
