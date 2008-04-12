package Mowyw::Datasource;
use strict;
use warnings;
use Carp qw(confess);

sub new {
    my ($base, $opts) = @_;
    my $type = lc($opts->{type}) or confess "No 'type' given";
    delete $opts->{type};
    if ($type eq 'xml'){
        eval 'use Mowyw::Datasource::XML';
        confess $@ if $@;
        return Mowyw::Datasource::XML->new($opts);
    }
    elsif ($type eq 'dbi') {
        eval 'use Mowyw::Datasource::DBI';
        confess $@ if $@;
        return Mowyw::Datasource::DBI->new($opts);
    }
    else {
        confess "Don't know what to do with datasource type '$type'\n";
    }
}

# these are stubs for inherited classes

sub reset        { confess "Called virtual method in base class!" }
sub get          { confess "Called virtual method in base class!" }
sub next         { confess "Called virtual method in base class!" }
sub is_exhausted { confess "Called virtual method in base class!" }

1;
