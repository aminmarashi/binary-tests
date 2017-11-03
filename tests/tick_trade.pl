use strict;
use warnings;

use Test::Tool;

use Data::Dumper;
use Future;

local $| = 1;

my $ws_client = Test::Tool::start_client;

my $duration = 15;

while(1) {
    my $proposal = $ws_client->await_proposal({
        proposal => 1,
        amount => 10,
        basis => 'payout',
        contract_type => 'CALL',
        currency => 'USD',
        symbol => 'R_100',
        duration => $duration,
        duration_unit => 's'
    });

    my $buy = $ws_client->await_buy({
        buy => $proposal->{id},
        price => $proposal->{ask_price},
    });

    my $wuf = $ws_client->wait_until_finished(
        request => {
            proposal_open_contract => 1,
            subscribe => 1,
            contract_id => $buy->{contract_id},
        },
        timeout => $duration * 2,
        stall_timeout => 10,
        is_finished => sub {
            my $contract = shift->{proposal_open_contract};

            return $contract->{is_sold};
        },
        on_response => sub {
            my $contract = shift->{proposal_open_contract};

            print '@time: ' . time . ', Contract: ' . $contract->{contract_id} . ', Expired: ' . $contract->{is_expired} . ', Sold: ' . $contract->{is_sold} . ', Settleable: ' . $contract->{is_settleable};

            $ws_client->request({sell_expired => 1}) if $contract->{is_expired} and (not $contract->{is_sold});
        }
    )->then(sub {
        my $contract = shift->{proposal_open_contract};
        print '@time: ' . time . ', Finished Contract: ' . $contract->{contract_id};
        return Future->done();
    })->else(sub { die '@time: ' . time . ' - ' . Dumper shift });

    $wuf->get;
}

1;

