#!/usr/bin/env perl

use Test::Most;
use Parsely;

my $engine = Parsely->new;

ok( $engine->load( 'actioncastle' ), "Loaded ActionCastle mission" );

done_testing();
