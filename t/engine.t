#!/usr/bin/env perl

use Test::Most;
use Parsely;

my $engine     = Parsely->new;
my $start_room = $engine->new_game( 'actioncastle' );
my $next_room  = $engine->do_action( "move out" );
my $non_room   = $engine->do_action( "move out" );

ok( ref $start_room eq "Parsely::Location", "Started a new adventure" );
ok( $next_room->{ slug } eq "gardenpath", "...and moved to the garden path" );
ok( ref $non_room eq "", "...but you can't go in an invalid direction" );

# Change gamestate, create a new copy of the adventure, load it, and make sure 
# state is restored.
my $loc = $engine->adventure->get_location( 'cottage' );
$loc->set_property( 'baz', 'bah' );
$engine->gamestate->set( "foo", "bar" );
$engine->save;

#my $new_engine = Parsely->new;
#$new_engine->load( "actioncastle" );
#ok( $new_engine->adventure->name eq $engine->adventure->name, 
    #"Successfully reloaded an adventure!");
#ok( $new_engine->adventure->get_location( 'cottage' )->get_property( 'baz' )
    #eq 'bah', "...and properly restored gamestate too" );

done_testing();
