package Parsely::Adventure;

use Moo;
use Types::Standard -all;
use YAML 'LoadFile';

use lib '.';
use Parsely::Base;
use Parsely::Item;
use Parsely::Actor;
use Parsely::Thing;
use Parsely::Location;

extends 'Parsely::Thing';

has actors => (
    is  => 'rw',
    isa => ArrayRef[ InstanceOf[ "Parsely::Actor" ]],
);

has items => (
    is  => 'rw',
    isa => ArrayRef[ InstanceOf[ "Parsely::Item" ]],
);

has locations => (
    is  => 'rw',
    isa => ArrayRef[ InstanceOf[ "Parsely::Location" ]],
);

has _slugs => (
    is      => 'rw',
    isa     => HashRef,
    default => sub{ {} },
);

sub get_location( $self, $location ) {
    croak "No location specified to get_location()" unless $location;

    for my $loc( @{ $self->locations } ) {
        return $loc if $loc->slug eq $location;
    }

    die "Location '$location' not found by get_location() in " . $self->adventure->name;
}

sub load( $self, $gamestate, $adventure ) {
    #$_->load( $gamestate, $_->slug ) foreach @{ $self->locations };
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
            #$self->_ng_locations( $config );
            $self->_ng_actors( $config );
            #$self->_ng_items( $config );
        }
    }
    else {
        die "No configuration available for $adventure!";
    }
    return 1;
}

sub save( $self, $gamestate ) {
    $_->save( $gamestate ) foreach @{ $self->actors };
    $_->save( $gamestate ) foreach @{ $self->items };
    $_->save( $gamestate ) foreach @{ $self->locations };
    $self->SUPER::save( $gamestate );
}

sub validate( $self, $config ) {
    croak "No adventure configuration in validate()" unless $config;
    
    my $valid = 1;
    $valid = $self->_validate_locations( $config );
    $valid = $self->_validate_actors   ( $config );
    #$valid = $self->_validate_items    ( $config );

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
            my $info = $config->{ actors }->{ $thing };
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
    return $self->_validate_thing( $config, 'actor', 'actors' );
}

sub _validate_items( $self, $config ) {
    croak "No adventure configuration in _validate_items()" unless $config;

    my $valid   = 1;
    my $default = 0;
    my @items   = keys %{ $config->{ items }};
    if( @items == 0 ) {
        warn "No items defined in game config!";
    }
    else {
        foreach my $item( @items ) {
            my $item_info = $config->{ items }->{ $item };
            my $message  = "Item '$item' has no";
            warn "$message name!"        unless $item_info->{ name };
            warn "$message description!" unless $item_info->{ description };
            $valid = 0 if $message =~ /name|description/;
        }
    }

    return $valid;
}

sub _validate_locations( $self, $config ) {
    croak "No adventure configuration in _validate_locations()" unless $config;

    my $valid = 1;
    my @locations = keys %{ $config->{ locations }};
    if( @locations == 0 ) {
        warn "No locations defined in game config!";
    }
    else {
        foreach my $location( @locations ) {
            my $loc_info = $config->{ locations }->{ $location };
            my $message  = "Location '$location' has no";
            warn "$message name!"        unless $loc_info->{ name };
            warn "$message exits!"       unless $loc_info->{ exits };
            warn "$message description!" unless $loc_info->{ description };
            $valid = 0 if $message =~ /name|exits|description/;
        }
    }

    return $valid;
}

# TODO: Validate exits
# TODO: Validate items in locations
# TODO: Validate actors in locations
# TODO: Validate game over conditions
# TODO: Validate talk (generic - anything you say)

sub _ng_actors( $self, $config ) {
    die "No adventure configuration in _ng_actors()" unless $config;

    my @actors;
    for my $actor( keys %{ $config->{ actors }}) {
        $self->_check_slug( $actor, 'actor' );

        push @actors, Parsely::Actor->new({ 
            slug        => $actor,
            _state_data => $config->{ actors }->{ $actor },
        });
    }

    $self->actors( \@actors );
}

sub _ng_items( $self, $config ) {
    die "No adventure configuration in _ng_items()" unless $config;

    my @items;
    for my $item( keys %{ $config->{ items }}) {
        $self->_check_slug( $item, 'item' );

        my $item_info = $config->{ items }->{ $item };
        my $thing     = Parsely::Item->new({ slug => $item });

        $thing->description( $item_info->{ description } );
        $thing->name       ( $item_info->{ name } );
        $thing->looks      ( $item_info->{ looks }      // {} );
        $thing->properties ( $item_info->{ properties } // {} );
        # TODO: actions!

        push @items, $thing;
    }

    $self->items( \@items );
}

sub _ng_locations( $self, $config ) {
    die "No adventure configuration in _ng_locations()" unless $config;

    my @locations;
    for my $location( keys %{ $config->{ locations }}) {
        $self->_check_slug( $location, 'location' );

        my $loc_info = $config->{ locations }->{ $location };
        my $room     = Parsely::Location->new({ slug => $location });

        $room->initial_description( 
            $loc_info->{ initial_description } // $loc_info->{ description } );
        $room->description( $loc_info->{ description } );
        $room->name( $loc_info->{ name } );

        $room->items     ( $loc_info->{ items  }     // [] );
        $room->actors    ( $loc_info->{ actors }     // [] );
        $room->exits     ( $loc_info->{ exits }      // {} );
        $room->looks     ( $loc_info->{ looks }      // {} );
        $room->properties( $loc_info->{ properties } // {} );
        # TODO: actions!

        push @locations, $room;
    }

    $self->locations( \@locations );
}

1;

