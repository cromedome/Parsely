#!/usr/bin/env perl

use Test::Most;
use Parsely;

my $engine = Parsely->new;

ok( $engine->load( 'actioncastle' ), "Loaded a mission" );

$engine->gamestate->set( "foo", "bar" );
$engine->gamestate->set( "baz", "bah" );
$engine->save;

my $new_engine = Parsely->new;
$new_engine->load( "actioncastle" );
ok( $new_engine->adventure->name eq $engine->adventure->name, 
    "Successfully reloaded an adventure!");

done_testing();
