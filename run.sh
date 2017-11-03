#! /bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

. config

ENDPOINT_ARG=$(echo $@ | grep -oP -- '--endpoint\s*\K[^\s]*')
TOKEN_ARG=$(echo $@ | grep -oP -- '--token\s*\K[^\s]*')

test -n "$ENDPOINT_ARG" && ENDPOINT="$ENDPOINT_ARG"
test -n "$TOKEN_ARG" && TOKEN="$TOKEN_ARG"

(test -e $TOKEN || test -e $ENDPOINT) && echo 'Usage ./run.sh --token [token] --endpoint [endpoint]' && exit 1

export ENDPOINT;
export TOKEN;

echo "Connecting to $ENDPOINT"
echo "Token is $(echo $TOKEN | cut -c 1-8)..."

pushd tests

test ! -d BinaryAsyncClient && git clone https://github.com/aminmarashi/BinaryAsyncClient.git BinaryAsyncClient

pushd BinaryAsyncClient
    git pull
popd

mkdir ../logs 2>/dev/null
mkdir ../pids 2>/dev/null

for p in *.pl; do
    perl -I./BinaryAsyncClient/lib -l $p > ../logs/$p.log 2>&1 &
    echo $! > ../pids/$p.pid
done

popd

exit 0;
