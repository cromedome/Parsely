#!/usr/bin/env perl

use Test::Most;
use Parsely::Adventure;

my $adventure = Parsely::Adventure->new;

# Loading a mission
ok( $adventure->load( 'actioncastle' ), "Loaded a mission" );
ok( $adventure->name eq "Action Castle", "...and it's name is Action Castle" );
throws_ok{ $adventure->load( "") }
    qr/No adventure provided/,
    "...but we can't load adventures without a name";
throws_ok{ $adventure->load( "foobar") }
    qr/No configuration available/,
    "...and we don't want try to load invalid adventures";
done_testing();

