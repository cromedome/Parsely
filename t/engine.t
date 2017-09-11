#!/usr/bin/env perl

use Test::Most;
use Parsely;

my $engine = Parsely->new;

ok( $engine->load( 'actioncastle' ), "Loaded a mission" );

done_testing();
