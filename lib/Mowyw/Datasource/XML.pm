package Mowyw::Datasource::XML;

use strict;
use warnings;
use base 'Mowyw::Datasource';
use XML::Simple;
use Scalar::Util qw(reftype);

use Carp qw(confess);

sub new {
    my ($class, $opts) = @_;
    my $self = bless { OPTIONS => $opts, INDEX => 0 }, $class;

    my $file = $opts->{file} or confess "Mandatory option 'file' is missing\n";
    $self->_read_data($file);

    return $self;
}

sub _read_data {
    my ($self, $file) = @_;
    my $data;
    if (exists $self->{OPTIONS}{root}){
        $data = XMLin($file, ForceArray => [ $self->{OPTIONS}{root} ]);
    } else {
        $data = XMLin($file);
    }
    if (reftype $data eq 'ARRAY'){
        $self->{DATA} = $data;
    } else {
        if (exists $self->{OPTIONS}{root}){
            $self->{DATA} = $data->{$self->{OPTIONS}{root}};
        } else {
            my @keys = keys %$data;
            if (@keys > 1){
                confess "More than one root item, and no 'root' option specified";
            } elsif (@keys == 0){
                $self->{DATA} = [];
            } else {
                $self->{DATA} = $data->{$keys[0]};
            }
        }
    }
}

sub is_exhausted {
    my $self = shift;
    return scalar(@{$self->{DATA}}) <= $self->{INDEX}
}

sub get {
    my $self = shift;
    return $self->{DATA}[$self->{INDEX}];
}

sub next {
    shift->{INDEX}++;
}

sub reset {
    shift->{INDEX} = 0;
}

1;
