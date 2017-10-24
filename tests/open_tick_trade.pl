use strict;
use warnings;

use Test::Tool;

use Data::Dumper;
use Future;

local $| = 1;

my $ws_client = Test::Tool::start_client;

while(1) {
    my $proposal = $ws_client->await_proposal({
        proposal => 1,
        amount => 10,
        basis => 'payout',
        contract_type => 'CALL',
        currency => 'USD',
        symbol => 'R_100',
        duration => 5,
        duration_unit => 't'
    });

    my $buy = $ws_client->await_buy({
        buy => $proposal->{id},
        price => $proposal->{ask_price},
    });

    $ws_client->wait_until_finished(
        request => {
            proposal_open_contract => 1,
            subscribe => 1,
            contract_id => $buy->{contract_id},
        },
        timeout => 60 * 6,
        stall_timeout => 10,
        is_finished => sub {
            my $contract = shift->{proposal_open_contract};

            return $contract->{is_sold};
        },
        on_response => sub {
            my $contract = shift->{proposal_open_contract};

            print '@time: ' . time . ', Contract: ' . $contract->{contract_id};

            $ws_client->request({sell_expired => 1}) if $contract->{is_expired} and (not $contract->{is_sold});
        }
    )->then(sub { print Dumper shift; Future->done() })->else(sub { die Dumper shift })
    ->get;
}

1;

