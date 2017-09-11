package Parsely;

use lib '.';
use Moo;
use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use Cache::FastMmap;

#use Parsely::Base;
use Parsely::Adventure;

# Gamestate is an in-memory cache with the current game information
has gamestate => (
    is      => 'lazy',
    builder => '_build_gamestate',
);

has adventure => (
    is      => 'lazy',
    builder => '_build_adventure',
);

# TODO: Save after each action?
# TODO: save() (call adventure->name)

# Create a new in-memory cache for tracking game state
sub _build_gamestate( $self ) {
    my $cache = Cache::FastMmap->new;
    return $cache;
}

sub _build_adventure( $self ) {
    my $adventure = Parsely::Adventure->new;
    return $adventure;
}

# Reset the gamestate
sub reset( $self ) {
    $self->gamestate->clear;
}

sub load( $self, $adventure ) {
    return $self->adventure->load( $adventure );
}

sub game_over( $self, $condition ){
    return 1;
}

sub take_game_action( $self, $action ) {
    return 1;
}

1;

