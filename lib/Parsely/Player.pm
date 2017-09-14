package Parsely::Player;

use lib './lib';
use Moo;
use Types::Standard -all;
use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);
#use Parsely::Base;

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

