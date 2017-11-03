# Binary tests

## Dependencies

Download and install avail-tests

```
git clone https://github.com/aminmarashi/avail-test.git avail-test
cd avail-test
./install.sh
```

## Add your token and endpoint to test.config

```
# Hint: Use single-quote around your endpoint!
ENDPOINT=[endpoint]
TOKEN=[your token]
```

## Run the tests with your token and endpoint

```
$ avail-start
```

## Stop the tests

```
$ avail-stop
```

## Watch the tests

```
$ avail-watch
==> logs/tick_trade1.pl.log <==
@time: 1509357041, Contract: 1200019

==> logs/tick_trade2.pl.log <==
@time: 1509357041, Contract: 1199979

==> logs/tick_trade.pl.log <==
@time: 1509357041, Contract: 1200039
```
