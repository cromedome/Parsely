package Parsely::Adventure;

use Moo;
use MooX::Types::MooseLike::Base qw/:all/;
use YAML 'LoadFile';

use lib '.';
use Parsely::Base;
use Parsely::Location;
use Data::Dumper;

has name => (
    is  => 'rw',
    isa => Str,
);

has locations => (
    is  => 'rw',
    isa => ArrayRef,
);

# Load a new adventure
sub load( $self, $adventure ) {
    die "No adventure provided!" unless $adventure;
    # TODO: hash to check for duplicate objects

    my $file = "./adventures/$adventure/${ adventure }.yml";
    if( -e $file ) {
        my $config = LoadFile( $file );
        if( $config and $self->validate( $config )) {
            # Everything is valid at this point, add with impunity
            $self->name( $config->{ name } );
            $self->_load_locations( $config );
        }
    }
    else {
        die "No configuration available for $adventure!";
    }
    return 1;
}

sub validate( $self, $config ) {
    die "No adventure configuration!" unless $config;
    
    my $valid = 1;
    $valid = $self->_validate_locations( $config );

    return $valid;
}

# TODO: Validate actors
# TODO: Validate items
# TODO: Validate exits
# TODO: Validate game over conditions

sub _validate_locations( $self, $config ) {
    die "No adventure configuration!" unless $config;

    my $valid = 1;
    my @locations = keys %{ $config->{ locations }};
    if( @locations == 0 ) {
        warn "No locations defined!";
    }
    else {
        foreach my $location( @locations ) {
            my $loc_info = $config->{ locations }->{ $location };
            my $message  = "Location '$location' has no ";
            warn "$message name!"        unless $loc_info->{ name };
            warn "$message exits!"       unless $loc_info->{ exits };
            warn "$message description!" unless $loc_info->{ description };
            $valid = 0 if $message =~ /name|exits|description/;
        }
    }

    return $valid;
}

sub _load_locations( $self, $config ) {
    die "No adventure configuration!" unless $config;

    for my $location( keys %{ $config->{ locations }}) {
        my $loc_info = $config->{ locations }->{ $location };
        my $room     = Parsely::Location->new;

        $room->slug( $location );
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
    }
}

1;

