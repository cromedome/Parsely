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

# Locations have a few more concerns than other things
after set_state => sub( $self, $state = 'default') {
    # We'd have croaked by now if state were invalid
    $self->initial_description( 
        $self->_state_data->{ $state }{ initial_description } // 
        $self->_state_data->{ $state }{ description } 
    );
    $self->items     ( $self->_state_data->{ $state }{ items  } // [] );
    $self->actors    ( $self->_state_data->{ $state }{ actors } // [] );
    $self->exits     ( $self->_state_data->{ $state }{ exits  } // {} );
};

# What to do when a player enters a room
sub enter( $self, $room, $player ) {
    croak "No such room '$room' to enter()!" unless $room && $self->slug eq $room;
    croak "No player to move via enter()!"   unless $player;

    $player->current_location( $room );
    return ();
}

1;

