package Parsely::Actions;

use lib '.';
use Moo;
use Types::Standard -all;
use Parsely::Base;

has _dispatch => (
    is      => 'ro',
    isa     => HashRef,
    default => sub {{
        move       => { code => \&move },
        run        => { code => \&move },
        walk       => { code => \&move },
        go         => { code => \&move },
        talk       => { code => \&talk },
        'speak to' => { code => \&talk },
    }},
);

sub move( $args ) {
    my $action    = $args->{ action };
    my $adventure = $args->{ adventure };
    my $player    = $adventure->player;

    croak "No destination provided to Move::action()!" unless $action;

    $action =~ /^(\w+) (.*)?$/;
    my $exits = $adventure->locations->{ $player->current_location }->{ exits };
    if( exists $exits->{ $2 } ) {
        return $args->{ adventure }->locations->{ $exits->{ $2 }}->enter({ player => $adventure->player });
    }
    else {
        return "I can't go that way!";
    }
}

sub talk( $self, $args ) {
    return "BLAH BLAH BLAH I CAN'T HEAR YOU!";
}

1;

