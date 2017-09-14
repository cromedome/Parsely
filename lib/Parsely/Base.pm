package Parsely::Base;

use strictures 2;
use base 'Import::Base';

our @IMPORT_MODULES = (
    { 'strictures' => 2 },
    feature => [qw( :5.24 signatures )],
    '>-warnings' => [qw( experimental::signatures )],
    'Try::Tiny',
    'Carp',
);

1;

