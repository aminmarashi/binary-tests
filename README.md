# Binary tests

## Dependencies

Download and install [avail-tests](https://github.com/aminmarashi/avail-test)

```
git clone https://github.com/aminmarashi/avail-test.git avail-test
cd avail-test
source install.sh
```

## Add your token and endpoint to ~/.binary_test.conf

```
# Hint: Use single-quote around your endpoint!
ENDPOINT='wss://endpoint/somewhere?something=value'
TOKEN='abcdefg12345'
```

## Run the tests

```
$ avail-test
```

## Stop the tests

```
$ avail-stop
```

## Watch the tests

```
$ avail-watch
Time    |# Alive|Alive Tests
09:19:54|10     |++++++++++
09:19:55|10     |++++++++++
09:19:56|10     |++++++++++
09:19:58|10     |++++++++++
09:19:59|10     |++++++++++
```

## Watch the tests logs

```
$ avail-watch -w -l 5

Every 1.0s: tail -n 5 /home/nobody/binary-tests/.avail-tests/logs/*

==> /home/nobody/binary-tests/.avail-tests/logs/1_tick_trade.pl.log <==
Subcribed to proposal
Purchased the contract
New open contract: 123182398
Contract finished
Start over
```
