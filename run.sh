#! /bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

. config

ARG_RE='[\s=]*\K[^\s^=]*'

ENDPOINT_ARG=$(echo $@ | grep -oP -- "--endpoint$ARG_RE")
TOKEN_ARG=$(echo $@ | grep -oP -- "--token$ARG_RE")
RUN_PREFIX_ARG=$(echo $@ | grep -oP -- "--run-prefix$ARG_RE")

test -n "$ENDPOINT_ARG" && ENDPOINT="$ENDPOINT_ARG"
test -n "$TOKEN_ARG" && TOKEN="$TOKEN_ARG"
test -n "$RUN_PREFIX_ARG" && RUN_PREFIX="$RUN_PREFIX_ARG"

(test -e $TOKEN || test -e $ENDPOINT) && echo 'Usage ./run.sh --token [token] --endpoint [endpoint]' && exit 1

export ENDPOINT;
export TOKEN;

echo "Connecting to $ENDPOINT"
echo "Token is $(echo $TOKEN | cut -c 1-8)..."

mkdir ./logs 2>/dev/null
mkdir ./pids 2>/dev/null
rm ./logs/*  2>/dev/null

pushd lib

test ! -d BinaryAsyncClient && git clone https://github.com/aminmarashi/BinaryAsyncClient.git BinaryAsyncClient

pushd BinaryAsyncClient
    git pull
popd

popd

LIB_PATH=`pwd`/lib

pushd tests

for t in *.pl; do
    for p in $RUN_PREFIX; do
	TEST="$p$t"
        perl -I$LIB_PATH/BinaryAsyncClient/lib -I$LIB_PATH -l $t > ../logs/$TEST.log 2>&1 &
        echo $! > ../pids/$TEST.pid
    done
done

popd

exit 0;
