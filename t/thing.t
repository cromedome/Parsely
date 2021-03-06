#!/usr/bin/env perl

use Test::Most;
use Cache::FastMmap;
use Parsely::Thing;

my $slug = "test";
my $name = "Test Thing";
my $description = "This is just a plain ol' boring test thingy";
my $other = "This is just a less boring test thingy";
my %looks = (
    sideways => 'You look sideways at the silly thing.',
);
my %props = (
    this   => 'that',
    thing1 => 'thing2',
    foo    => 'bar',
);
my $args = {
    default => {
        name        => $name,
        description => $description,
        looks       => \%looks,
        properties  => \%props,
    },
    other => {
        name        => $name,
        description => $other,
        looks       => \%looks,
        properties  => \%props,
    },
};
my $gamestate = Cache::FastMmap->new;

my $thing = Parsely::Thing->new( slug => $slug, _state_data => $args );
ok( $slug eq $thing->slug, "A new thing was created with a slug of $slug" );
ok( $name eq $thing->name, "...and with a name of $name" );
ok( $description eq $thing->description, "...and with the right description" );
cmp_deeply( \%looks, $thing->looks, "...and all the same looks" );
cmp_deeply( \%props, $thing->properties, "...and the same properties too" );
cmp_deeply( $args, $thing->_state_data, "...and is initialized with all state data" );

# Change state
$thing->set_state( 'other' ); 
ok( $thing->description eq $other, "Changed thing to another object state" );

# Set/get_property
ok( !defined $thing->get_property( 'jason' ), "Key 'jason' doesn't exist yet" );
$thing->set_property( 'jason', 'cromedome' );
ok( $thing->get_property( 'jason' ) eq 'cromedome', "...but now it does!" );

# Stringification
like( $thing->_stringify( $thing->properties ), qr/this:that/,
    "Properties were properly stringified");
like( $thing->_stringify( $thing->looks ), qr/sideways:You look/,
    "...and so were the looks");

# Hashification
cmp_deeply( \%props, $thing->_hashify($thing->_stringify( $thing->properties )),
    "Properties were properly hashified");
cmp_deeply( \%looks, $thing->_hashify($thing->_stringify( $thing->looks )),
    "...and so were looks");

# Save
$thing->save( $gamestate );
ok( $gamestate->get( "$slug|properties" ) eq $thing->_stringify( $thing->properties ), 
    "Thing was saved to gamestate successfully" );

# Load
my $thing1 = Parsely::Thing->new( slug => "new", _state_data => $args );
$thing1->load( $gamestate, $slug );
cmp_deeply( $thing->properties, $thing1->properties, 
    "...and was successfully loaded to a new object" );

# Exceptions
throws_ok{ $thing->set_property( undef, undef ) }
    qr/Need to specify key\/value/,
    "set_property() dies when no key is provided";
throws_ok{ $thing->set_property( 'key', undef ) }
    qr/Need to specify key\/value/,
    "...and when no value is provided";
throws_ok{ $thing->get_property( undef ) }
    qr/Need to specify key/,
    "get_property() dies when no key is provided";
throws_ok{ $thing->set_state( 'asjkdhdajk' ) }
    qr/Invalid object state/,
    "set_state() dies when an invalid state is provided";

throws_ok{ $thing->save( undef ) }
    qr/No gamestate provided/,
    "save() dies when no gamestate is provided";

throws_ok{ $thing->load( undef, undef ) }
    qr/No gamestate provided/,
    "...and so does load()";

throws_ok{ $thing->load( $gamestate, undef ) }
    qr/No slug provided/,
    "load() also dies when not given a slug to load";

throws_ok{ $thing->_stringify( undef ) }
    qr/Nothing to stringify/,
    "_stringify() needs something to stringify";

throws_ok{ $thing->_hashify( undef ) }
    qr/Nothing to hashify/,
    "_hashify() needs something to hashify";

done_testing();

