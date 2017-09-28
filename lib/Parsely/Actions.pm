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

sub go( $self, $action, $args ) {
    croak "No action specified to go()!"  unless $action;
    warn  "No arguments provided to go()" unless $args;
    return $self->_dispatch->{ $action }->( $args );
}

sub move( $self, $args ) {
    croak "No destination provided to Move::action()!" unless $args->{ dest };
    # TODO: make sure we can actually move in that direction
    return $self->locations->{ $args->{ dest } }->enter;
}

sub talk( $self, $args ) {
    return "BLAH BLAH BLAH I CAN'T HEAR YOU!";
}

1;

