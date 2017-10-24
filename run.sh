#! /bin/bash

export ENDPOINT=$(echo $@ | grep -oP -- '--endpoint\s*\K[^\s]*')
export TOKEN=$(echo $@ | grep -oP -- '--token\s*\K[^\s]*')

(test -e $TOKEN || test -e $ENDPOINT) && echo 'Usage ./run.sh --token [token] --endpoint [endpoint]' && exit 1

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

echo 'Done'
