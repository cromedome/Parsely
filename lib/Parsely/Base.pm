package Parsely::Base;

use strictures 2;

our @IMPORT_MODULES = (
    'v5.24',
    { 'strictures' => 2 },
    feature => [qw( signatures )],
    '>-warnings' => [qw( experimental::signatures )],
    'Try::Tiny',
);

1;

