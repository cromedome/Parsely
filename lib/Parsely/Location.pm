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
sub enter( $self, $args ) {
    croak "No player specified to enter()!" unless $args->{ player };

    $args->{ player }->current_location( $self->slug );
    $self->set_property( 'visited', 0 );
    return {
        game_over => $self->get_property( 'game_over' ) //= 0,
        #description => $self->get_property( 'visited' ) ? $self->description : 
            #$self->initial_description,

    };
}

1;

