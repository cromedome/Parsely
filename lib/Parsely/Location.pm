package Parsely::Location;

use lib '.';
use Moo;
use Types::Standard -all;
use YAML 'LoadFile';
use Parsely::Base;

extends 'Parsely::Thing';

has initial_description => (
    is  => 'rw',
    isa => Str,
);

has actors => (
    is  => 'rw',
    isa => ArrayRef,
);

has items => (
    is  => 'rw',
    isa => ArrayRef,
    default => sub{[]},
);

has exits => (
    is  => 'rw',
    isa => HashRef,
);

has actions => (
    is  => 'rw',
    isa => HashRef,
);

1;

