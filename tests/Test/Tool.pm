package Test::Tool;

use warnings;
use strict;

use BinaryAsync::Client;
use IO::Async::Loop;

our $loop = IO::Async::Loop->new;

sub start_client {
    my ($endpoint, $token) = @_;
    $endpoint //= $ENV{ENDPOINT};
    $token    //= $ENV{TOKEN};

    warn $token;

    my $ws_client = BinaryAsync::Client->new(uri => $endpoint);

    $loop->add($ws_client);

    $ws_client->await_authorize({authorize => $token});

    return $ws_client;
}

1;
