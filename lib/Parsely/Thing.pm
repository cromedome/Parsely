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

sub save( $self, $gamestate ) {
    die "No gamestate provided!" unless $gamestate;

    $gamestate->set( $self->slug . "|properties",  $self->_stringify( $self->properties // {} ));
}

sub load( $self, $gamestate, $slug ) {
    die "No gamestate provided!" unless $gamestate;
    die "No slug provided!"      unless $slug;

    my $prop_string = $gamestate->get( "$slug|properties" ) // '';
    my $props = $self->_hashify( $prop_string );
    $self->properties( $props );
}

sub set_property( $self, $key, $value ) {
    my $props = $self->properties;
    $props->{ $key } = $value;
    $self->properties( $props );
}

sub get_property( $self, $key ) {
    my $props = $self->properties;
    return $props->{ $key } // undef;
}


sub _stringify( $self, $thingy ) {
    die "Nothing to stringify!" unless defined $thingy;
    return join ',', map{ $_ . ':' . $thingy->{ $_ } } keys %$thingy;
}

sub _hashify( $self, $stringy ) {
    die "Nothing to hashify!" unless defined $stringy;

    my %thingy;
    my @things = split /,/, $stringy;
    foreach my $thing( @things ) {
        my( $thing1, $thing2 ) = split /:/, $thing;
        $thingy{ $thing1 } = $thing2
    }

    return \%thingy;
}

1;

