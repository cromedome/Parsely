#!/usr/bin/env perl

use Test::Most;
use Cache::FastMmap;
use Parsely::Adventure;

my $adventure = Parsely::Adventure->new( slug => 'new' );
my $gamestate = Cache::FastMmap->new;

# Start a new game
ok( $adventure->new_game( 'actioncastle' ), "Loaded a mission" );
ok( $adventure->name eq "Action Castle", "...and it's name is Action Castle" );

# Make sure we die when we are supposed to
throws_ok{ $adventure->new_game( "") }
    qr/No adventure provided/,
    "...but we can't load adventures without a name";
throws_ok{ $adventure->new_game( "foobar") }
    qr/No configuration available/,
    "...and we don't want try to start invalid adventures";
done_testing();

