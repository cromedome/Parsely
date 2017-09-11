package Parsely::Adventure;

use Moo;
use MooX::Types::MooseLike::Base qw/:all/;
use YAML 'LoadFile';

use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use lib '.';
#use Parsely::Base;
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
    return 1;
}

# TODO: Validate actors
# TODO: Validate items
# TODO: Validate Area
# TODO: Validate exits
# TODO: Validate game over conditions

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

        push @{ $room->items  }, $_ foreach @{ $loc_info->{ items  }};
        push @{ $room->actors }, $_ foreach @{ $loc_info->{ actors }};

        my %ways_out;
        for my $exit( keys %{ $loc_info->{ exits }} ) {
            $ways_out{ $exit } = $loc_info->{ exits }{ $exit };
        }
        $room->exits( \%ways_out );
        #die Dumper $room;
    }
}

1;

