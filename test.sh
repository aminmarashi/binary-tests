#! /bin/bash
. test.config

perl -I$LIB_PATH/BinaryAsyncClient/lib -I$LIB_PATH -l "@_"
