#! /bin/bash
. test.config

export ENDPOINT;
export TOKEN;

_pushd () {
    pushd "$1" >/dev/null
}

_popd () {
    popd >/dev/null
}

echo "Connecting to $ENDPOINT"
echo "Token is $(echo $TOKEN | cut -c 1-8)..."

mkdir "$LIB_PATH" 2>/dev/null

_pushd "$LIB_PATH"

test ! -d BinaryAsyncClient && git clone https://github.com/aminmarashi/BinaryAsyncClient.git BinaryAsyncClient

_pushd BinaryAsyncClient
    git pull
_popd

_popd

