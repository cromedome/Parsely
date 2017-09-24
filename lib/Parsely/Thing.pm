package Parsely::Thing;

use lib '.';
use Moo;
use Types::Standard -all;
use Parsely::Base;

has slug => (
    is       => 'rw',
    isa      => Str,
    required => 1,
);

has name => (
    is  => 'rw',
    isa => Str,
);

has description => (
    is  => 'rw',
    isa => Str,
);

has looks => (
    is  => 'rw',
    isa => HashRef,
);

has properties => (
    is  => 'rw',
    isa => HashRef,
);

has actions => (
    is  => 'rw',
    isa => HashRef,
);

has _state_data => (
    is  => 'ro',
    isa => HashRef,
);

sub BUILD {
    my( $self, $args ) = @_;
    # Adventures and players have no state. But this is ugly. There has to be a better way???
    $self->set_state unless 
        $self->isa( 'Parsely::Adventure' ) || $self->isa( 'Parsely::Player' );
}

sub save( $self, $gamestate ) {
    croak "No gamestate provided!" unless $gamestate;

    $gamestate->set( $self->slug . "|properties",  $self->_stringify( $self->properties // {} ));
}

sub load( $self, $gamestate, $slug ) {
    croak "No gamestate provided!" unless $gamestate;
    croak "No slug provided!"      unless $slug;

    my $prop_string = $gamestate->get( "$slug|properties" ) // '';
    my $props = $self->_hashify( $prop_string );
    $self->set_state( $props->{ current_state } // 'default' );
    $self->properties( $props );
}

# What state is the player in? While players can change state, while in
# a state, a player is immutable. Changing state gives the illusion that
# something changed.
sub set_state( $self, $state = 'default') {
    croak "Invalid object state provided to set_state()" 
        unless exists $self->_state_data->{ $state };

    $self->description( $self->_state_data->{ $state }{ description } );
    $self->name       ( $self->_state_data->{ $state }{ name } );
    $self->looks      ( $self->_state_data->{ $state }{ looks }      // {} );
    $self->properties ( $self->_state_data->{ $state }{ properties } // {} );
    # TODO: Talk!
    # TODO: actions!
}

sub set_property( $self, $key, $value ) {
    croak "Need to specify key/value to set_property()!" unless $key && $value;
    my $props = $self->properties;
    $props->{ $key } = $value;
    $self->properties( $props );
}

sub get_property( $self, $key ) {
    croak "Need to specify key to get_property()!" unless $key;
    my $props = $self->properties;
    return $props->{ $key } // undef;
}

sub _stringify( $self, $thingy ) {
    croak "Nothing to stringify!" unless defined $thingy;
    return join ',', map{ $_ . ':' . $thingy->{ $_ } } keys %$thingy;
}

sub _hashify( $self, $stringy ) {
    croak "Nothing to hashify!" unless defined $stringy;

    my %thingy;
    my @things = split /,/, $stringy;
    foreach my $thing( @things ) {
        my( $thing1, $thing2 ) = split /:/, $thing;
        $thingy{ $thing1 } = $thing2
    }

    return \%thingy;
}

1;

