=comment

Install all dependencies with:

    cpanm --installdeps . --with-develop --with-all-features

Note on version specification syntax:

    # Any version of My::Module equal or higher than 0.01 is required
    requires 'My::Module' => '0.01';

    # ditto
    requires 'My::Module' => '>= 0.01';

    # Exactly My::Module v0.01 is required
    requires 'My::Module' => '== 0.01';

See https://metacpan.org/pod/CPAN::Meta::Spec#VERSION-NUMBERS for details.

=cut

requires 'perl', '5.24.0';
requires 'strictures';
requires 'Moo';
requires 'Type::Tiny';
requires 'Cache::FastMmap';
requires 'Import::Base';
requires 'YAML';

on 'develop' => sub {
    requires 'App::Ack';
    requires 'Pod::Cpandoc';
};

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::Most';
    requires 'Test::Warn';
};
