package Parsely;

use lib '.';
use Moo;
use Cache::FastMmap;
use YAML qw/ DumpFile LoadFile /;

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

# TODO: unsaved flag?

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
    my $player = Parsely::Player->new({ slug => "player" });
    return $player;
}

# Reset the game
sub reset( $self ) {
    $self->gamestate->clear;
    $self->player->reset;
    return 1;
}

sub new_game( $self, $adventure ) {
    croak "No game specified to new_game()" unless $adventure;

    $self->reset;
    $self->adventure->new_game( $adventure );
    return $self->start_game;
}

sub load( $self, $adventure ) {
    croak "No game specified to load()" unless $adventure;

    $self->reset;

    my $file = "saves/${ adventure }.yml";
    croak "Save game '$file' doesn't exist; can't load()" unless -e $file;
    my $config = LoadFile( $file );
    $self->gamestate->set( $_, $config->{ $_ }) foreach keys %$config;
    $self->adventure->new_game( $adventure );
    # TODO: set adventure objects from YAML
    
    return 1;
}

sub save( $self ) {
    die "No game in progress" unless $self->adventure->name;

    my @game_vars = $self->gamestate->get_keys( 2 );
    my %game_data;
    $game_data{ $_->{ key } } = $self->gamestate->get( $_->{ key } ) foreach @game_vars;

    DumpFile( "saves/" . $self->adventure->slug . ".yml", \%game_data );
    return 1;
}

sub start_game( $self ) {
    # TODO: we have a new game loaded. Get the player started!
    return 1;
}

# TODO: Throw GameOver exception? Wrap actions in try/catch?
sub game_over( $self, $condition ){
    return 1;
}

sub take_game_action( $self, $action ) {
    return 1;
}

1;

