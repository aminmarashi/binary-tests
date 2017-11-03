. avail.config

export ENDPOINT;
export TOKEN;

echo "Connecting to $ENDPOINT"
echo "Token is $(echo $TOKEN | cut -c 1-8)..."

mkdir "$LIB_PATH" 2>/dev/null

pushd "$LIB_PATH"

test ! -d BinaryAsyncClient && git clone https://github.com/aminmarashi/BinaryAsyncClient.git BinaryAsyncClient

pushd BinaryAsyncClient
    git pull
popd

popd

