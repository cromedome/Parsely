package Parsely::Player;

use lib './lib';
use Moo;
use Types::Standard -all;
use Parsely::Base;

extends 'Parsely::Thing';

has start_location => (
    is  => 'rw',
    isa => Str,
);

has current_location => (
    is  => 'rw',
    isa => Str,
);

has deaths => (
    is      => 'rw',
    isa     => Int,
    default => 0,
);

has inventory => (
    is      => 'rw',
    isa     => HashRef,
    default => sub{ {} },
);

sub reset( $self ) {
    $self->slug( '' );
    $self->name( '' );
    $self->description( '' );
    $self->start_location( '' );
    $self->looks( {} );
    $self->properties( {} );
    $self->inventory( {} );
}

1;

