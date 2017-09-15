#!/usr/bin/env perl

use Test::Most;
use Parsely;

my $engine = Parsely->new;

ok( $engine->new_game( 'actioncastle' ), "Started a new adventure" );

# Change gamestate, create a new copy of the adventure, load it, and make sure 
# state is restored.
my $loc = $engine->adventure->get_location( 'cottage' );
$loc->set_property( 'baz', 'bah' );
$engine->gamestate->set( "foo", "bar" );
$engine->save;

my $new_engine = Parsely->new;
$new_engine->load( "actioncastle" );
ok( $new_engine->adventure->name eq $engine->adventure->name, 
    "Successfully reloaded an adventure!");
ok( $new_engine->adventure->get_location( 'cottage' )->get_property( 'baz' )
    eq 'bah', "...and properly restored gamestate too" );

done_testing();
