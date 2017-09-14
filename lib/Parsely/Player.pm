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

has inventory => (
    is  => 'rw',
    isa => HashRef,
);

1;

