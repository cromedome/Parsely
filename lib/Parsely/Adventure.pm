package Parsely::Adventure;

use lib '.';
use Moo;
use MooX::Types::MooseLike::Base qw/:all/;
use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);
#use Parsely::Base;

has name => (
    is  => 'rw',
    isa => Str,
);

# Load a new adventure
sub load( $self, $adventure ) {
    die "No adventure provided!" unless $adventure;
    return 1;
}

# TODO: Validate Area
# TODO: Validate exits
# TODO: Validate items

1;

