package Parsely::Adventure;

use Moo;
use Types::Standard -all;
use YAML 'LoadFile';

use lib '.';
use Parsely::Base;
use Parsely::Actions;
use Parsely::Actor;
use Parsely::Item;
use Parsely::Thing;
use Parsely::Location;
use Data::Dumper;

extends 'Parsely::Thing';

has _action_dispatch => (
    is      => 'ro',
    isa     => InstanceOf[ "Parsely::Actions" ],
    default => sub{ return Parsely::Actions->new; },
);

has actors => (
    is      => 'rw',
    isa     => HashRef[ InstanceOf[ "Parsely::Actor" ]],
    default => sub{{}},
);

has items => (
    is      => 'rw',
    isa     => HashRef[ InstanceOf[ "Parsely::Item" ]],
    default => sub{{}},
);

has locations => (
    is      => 'rw',
    isa     => HashRef[ InstanceOf[ "Parsely::Location" ]],
    default => sub{{}},
);

has player => (
    is  => 'rw',
    isa => InstanceOf[ 'Parsely::Player' ],
);

has _slugs => (
    is      => 'rw',
    isa     => HashRef,
    default => sub{ {} },
);

sub do_action( $self, $action ) {
    croak "No action given to do_action()!" unless $action;

    my $args = {
        adventure => $self,
        action    => $action,
    };

    my $curr_loc = $self->player->current_location;
    if( exists $self->locations->{ $curr_loc }->{ actions }->{ $action } ) {
        $self->locations->{ $curr_loc }->{ actions }->{ $action }->{ code }->( $args );
    }
    else {
        $action =~ /^(\w+)( .*)?$/;
        if( exists $self->locations->{ $curr_loc }->actions->{ $1 } ) {
            $self->locations->{ $curr_loc }->{ actions }->{ $1 }->{ code }->( $args );
        }
        else {
            return "Do what?";
        }
    }
}

sub get_location( $self, $location ) {
    croak "No location specified to get_location()" unless $location;
    croak "Location '$location' not found by get_location() in " . $self->adventure->name
        unless exists $self->locations->{ $location };

    return $self->locations->{ $location };
}

sub load( $self, $gamestate, $adventure ) {
    $self->actors->{ $_ }->load( $gamestate, $_ ) foreach keys %{ $self->actors };
    $self->items->{ $_ }->load( $gamestate, $_ ) foreach keys %{ $self->items };
    $self->locations->{ $_ }->load( $gamestate, $_ ) foreach keys %{ $self->locations };
    return 1;
}

# Start a new game by loading a fresh adventure
sub new_game( $self, $adventure ) {
    croak "No adventure provided to new_game()" unless $adventure;

    my $file = "./adventures/$adventure/${ adventure }.yml";
    if( -e $file ) {
        my $config = LoadFile( $file );
        if( $config and $self->validate( $config )) {
            # Everything is valid at this point, add with impunity
            $self->_check_slug( $adventure, 'adventure' );
            $self->slug( $adventure );
            $self->name( $config->{ name } );
            $self->_ng_actors( $config );
            $self->_ng_items( $config );
            $self->_ng_locations( $config );
            $self->player->start_location( $config->{ player }->{ start_location } );
        }
    }
    else {
        die "No configuration available for $adventure!";
    }

    return 1;
}

sub save( $self, $gamestate ) {
    $self->actors->{ $_ }->save( $gamestate ) foreach keys %{ $self->actors };
    $self->items->{ $_ }->save( $gamestate ) foreach keys %{ $self->items };
    $self->locations->{ $_ }->save( $gamestate ) foreach keys %{ $self->locations };
    $self->SUPER::save( $gamestate );
}

# TODO: this
sub score( $self, $extra_score ) {
}

sub set_player( $self, $player ) {
    croak "No player provided to set_player()!" unless $player;
    $self->player( $player );
}

sub validate( $self, $config ) {
    croak "No adventure configuration in validate()" unless $config;
    
    my $valid = 1;
    $valid = $self->_validate_actors   ( $config );
    $valid = $self->_validate_items    ( $config );
    $valid = $self->_validate_locations( $config );

    return $valid;
}

sub _check_slug( $self, $slug, $what ) {
    my $slugs = $self->_slugs;
    if( exists $slugs->{ $slug } ) {
        croak "Duplicate slug in adventure: '$slug' ($what)";
    }
    else {
        $slugs->{ $slug } = 1;
        $self->_slugs( $slugs );
    }
}

sub _validate_thing( $self, $config, $what, $key ) {
    croak "No adventure configuration in _validate_${ key }()" unless $config;
    croak "No label given to _validate_thing()"                unless $what;
    croak "No key given to _validate_thing()"                  unless $key;

    my $valid   = 1;
    my $default = 0;
    my @things  = keys %{ $config->{ $key }};
    if( @things == 0 ) {
        warn "No $what defined in game config!";
    }
    else {
        foreach my $thing( @things ) {
            my $info = $config->{ $key }->{ $thing };
            foreach my $state( keys %{ $info })  {
                $default = 1 if $state eq 'default';
                my $message = uc( $what ) . " '$thing' has no %s for '$state' state!";
                warn sprintf $message, 'name'        unless $info->{ $state }->{ name };
                warn sprintf $message, 'description' unless $info->{ $state }->{ description };
                $valid = 0 if $message =~ /name|description/;
            }
            
            if( !$default ) {
                warn "No default state for $what '$thing'!";
                $valid = 0;
            }
        }
    }

    return $valid;
}

sub _validate_actors( $self, $config ) {
    # TODO: Validate actors in locations
    # TODO: Validate items in locations
    return $self->_validate_thing( $config, 'actor', 'actors' );
}

sub _validate_items( $self, $config ) {
    return $self->_validate_thing( $config, 'item', 'items' );
}

sub _validate_locations( $self, $config ) {
    # TODO: Validate items in locations
    # TODO: Validate exits
    # TODO: validate actions
    my $valid = $self->_validate_thing( $config, 'location', 'locations' );

    my @locations = keys %{ $config->{ locations }};
    if( @locations == 0 ) {
        warn "No locations defined in game config!";
    }
    else {
        foreach my $location( @locations ) {
            my $loc_info = $config->{ locations }->{ $location };
            foreach my $state( keys %{ $loc_info })  {
                unless( $loc_info->{ $state }->{ exits } ) {
                    warn "Location '$location' has no exits for '$state' state!";
                    $valid = 0;
                }
            }
        }
    }

    return $valid;
}

sub _ng_actors( $self, $config ) {
    croak "No adventure configuration in _ng_actors()" unless $config;

    my @actors;
    for my $actor( keys %{ $config->{ actors }}) {
        $self->_check_slug( $actor, 'actor' );

        $self->actors->{ $actor } = Parsely::Actor->new({ 
            slug        => $actor,
            _state_data => $config->{ actors }->{ $actor },
        });
    }
}

sub _ng_items( $self, $config ) {
    croak "No adventure configuration in _ng_items()" unless $config;

    my @items;
    for my $item( keys %{ $config->{ items }}) {
        $self->_check_slug( $item, 'item' );

        $self->items->{ $item } = Parsely::Item->new({ 
            slug        => $item,
            _state_data => $config->{ items }->{ $item },
        });
    }
}

sub _ng_locations( $self, $config ) {
    croak "No adventure configuration in _ng_locations()" unless $config;

    my @locations;
    for my $location( keys %{ $config->{ locations }}) {
        $self->_build_actions( $location, $config );
        
        $self->locations->{ $location } = Parsely::Location->new({ 
            slug        => $location,
            _state_data => $config->{ locations }->{ $location },
        });
    }
}

sub _build_actions( $self, $location, $config ) {
    croak "No location given to _build_actions()"          unless $location;
    croak "No adventure configuration in _build_actions()" unless $config;

    my $loc_info    = $config->{ locations }->{ $location };
    my $new_actions = $self->_action_dispatch->_dispatch;

    foreach my $state( keys %{ $loc_info })  {
        my $action_data = $loc_info->{ $state }->{ actions };

        $self->_load_actions( $new_actions, $action_data ) if $action_data;

        foreach my $actor( @{ $loc_info->{ $state }->{ actors }} ) {
            my $actor_info = 
                $config->{ actors }->{ $actor }->{ $self->actors->{ $actor }->state };
            $self->_load_actions( $new_actions, $actor_info->{ actions })
                if $actor_info->{ actions };

            # TODO: actions on any item the actor has, too.
        }

        foreach my $item( @{ $loc_info->{ $state }->{ items }} ) {
            my $item_info = 
                $config->{ items }->{ $item }->{ $self->items->{ $item }->state };
            $self->_load_actions( $new_actions, $item_info->{ actions }) 
                if $item_info->{ actions };
        }

        $loc_info->{ $state }->{ actions } = $new_actions;
    }
    
}

sub _load_actions( $self, $new_actions, $action_info ) {
    croak "No action list given to _load_actions()!"   unless $new_actions;
    croak "No action data provided to _load_actions()" unless $action_info;

    foreach my $action( keys %$action_info ) {
        $action =~ /^(\w+)( .*)?$/;
        my $akey = $1 . ($2 // '');
        $new_actions->{ $akey }->{ code   }    = $new_actions->{ $1 }->{ code };
        $new_actions->{ $akey }->{ result }    = $action_info->{ $action }->{ result } // '';
        $new_actions->{ $akey }->{ game_over } = $action_info->{ $action }->{ game_over } // 0;
        $new_actions->{ $akey }->{ blocks }    = $action_info->{ $action }->{ blocks } // '';
        $new_actions->{ $akey }->{ unblocks }  = $action_info->{ $action }->{ unblocks } // '';
        $new_actions->{ $akey }->{ property }  = $action_info->{ $action }->{ property } // '';
        $new_actions->{ $akey }->{ args }      = $action_info->{ $action }->{ args } // {};

        foreach my $alias( @{ $action_info->{ $action }->{ aliases }} ) {
            $new_actions->{ $alias }->{ code } = $new_actions->{ $1 }->{ code };
        }
    }
    return $new_actions;
}

1;

