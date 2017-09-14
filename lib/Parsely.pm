package Parsely;

use lib '.';
use Moo;
use Cache::FastMmap;

use Parsely::Base;
use Parsely::Adventure;
use Parsely::Player;

# Gamestate is an in-memory cache with the current game information
has gamestate => (
    is      => 'lazy',
    builder => '_build_gamestate',
);

has adventure => (
    is      => 'lazy',
    builder => '_build_adventure',
);

has player => (
    is      => 'lazy',
    builder => '_build_player',
);

# Create a new in-memory cache for tracking game state
sub _build_gamestate( $self ) {
    my $cache = Cache::FastMmap->new;
    return $cache;
}

sub _build_adventure( $self ) {
    my $adventure = Parsely::Adventure->new;
    return $adventure;
}

sub _build_player( $self ) {
    my $player = Parsely::Player->new;
    return $player;
}

# Reset the game
sub reset( $self ) {
    $self->gamestate->clear;
    # TODO: reset player
}

sub new_game( $self, $adventure ) {
    # TODO: create new player object
    # TODO: Load adventure
    # TODO: ensure gamestate reset
}

sub load( $self, $adventure ) {
    # TODO: create new player
    # TODO: load adventure
    # TODO: Load YAML
    # TODO: Load gamestate from YAML
    # TODO: set adventure objects from YAML
    return $self->adventure->load( $adventure );
}

sub save( $self ) {
    # TODO: get name of adventure
    # TODO: use get_keys(2) to get hashref of cache info
    # TODO: write to YAML
}

sub game_over( $self, $condition ){
    return 1;
}

sub take_game_action( $self, $action ) {
    return 1;
}

1;

