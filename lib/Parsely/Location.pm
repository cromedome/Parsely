package Parsely::Location;

use lib '.';
use Moo;
use Types::Standard -all;
use YAML 'LoadFile';
use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);
#use Parsely::Base;

has slug => (
    is  => 'rw',
    isa => Str,
);

has name => (
    is  => 'rw',
    isa => Str,
);

has initial_description => (
    is  => 'rw',
    isa => Str,
);

has description => (
    is  => 'rw',
    isa => Str,
);

has visited => (
    is      => 'rw',
    isa     => Bool,
    default => 0,
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

has looks => (
    is  => 'rw',
    isa => HashRef,
);

has actions => (
    is  => 'rw',
    isa => HashRef,
);

has properties => (
    is  => 'rw',
    isa => HashRef,
);

1;

