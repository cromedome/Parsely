package Parsely::Adventure;

use lib '.';
use Moo;
use MooX::Types::MooseLike::Base qw/:all/;
use YAML 'LoadFile';
use v5.24;
use strictures 2;
use feature qw(signatures);
no warnings qw(experimental::signatures);
#use Parsely::Base;

has name => (
    is  => 'rw',
    isa => Str,
);

# Load a new adventure
sub load( $self, $adventure ) {
    die "No adventure provided!" unless $adventure;

    my $file = "./adventures/$adventure/${ adventure }.yml";
    if( -e $file ) {
        my $config = LoadFile( $file );
        if( $config and $self->validate( $config )) {
            $self->name( $config->{ name } );
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

# TODO: Validate Area
# TODO: Validate exits
# TODO: Validate items

1;

