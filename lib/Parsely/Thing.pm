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

    my $slug = $self->slug;
    $gamestate->set( "$slug|name",        $self->name );
    $gamestate->set( "$slug|description", $self->description );
    $gamestate->set( "$slug|looks",       $self->_stringify( $self->looks ));
    $gamestate->set( "$slug|properties",  $self->_stringify( $self->properties ));
}

sub load( $self, $gamestate, $slug ) {
    die "No gamestate provided!" unless $gamestate;
    die "No slug provided!"      unless $slug;

    my $name        = $gamestate->get( "$slug|name" );
    my $desc        = $gamestate->get( "$slug|description" );
    my $look_string = $gamestate->get( "$slug|looks" );
    my $prop_string = $gamestate->get( "$slug|properties" );

    die "No name for '$slug'!"        unless $name;
    die "No description for '$slug'!" unless $desc;

    my $props = $self->_hashify( $prop_string );
    my $looks = $self->_hashify( $look_string );

    $self->slug( $slug );
    $self->name( $name );
    $self->description( $desc );
    $self->looks( $looks );
    $self->properties( $props );
}

sub _stringify( $self, $thingy ) {
    die "Nothing to stringify!" unless $thingy;
    return join ',', map{ $_ . ':' . $thingy->{ $_ } } keys %$thingy;
}

sub _hashify( $self, $stringy ) {
    die "Nothing to hashify!" unless $stringy;

    my %thingy;
    my @things = split /,/, $stringy;
    foreach my $thing( @things ) {
        my( $thing1, $thing2 ) = split /:/, $thing;
        $thingy{ $thing1 } = $thing2
    }

    return \%thingy;
}

1;

