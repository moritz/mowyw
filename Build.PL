use strict;
use warnings;
use Module::Build;
require 5.008000;

my $build = Module::Build->new(
    create_readme      => 0,
    create_makefile_pl => 'traditional',
    license            => 'gpl',
    module_name        => 'mowyw',
    dist_author        => 'Moritz Lenz',
    dist_abstract      => 'Macro processor for creating static HTML pages',
    dist_version       => '0.5.1_1',
    requires => {
        'perl'              => '5.8.0',
        'Carp'              => 0,
        'Data::Dumper'      => 0,
        'Scalar::Util'      => 0,
        'File::Temp'        => 0,
        'File::Compare'     => 0,
        'Storable'          => 0,
        'Exporter'          => 0,
    },
    recommends         => {
        'DBI'               => 0,
        'XML::Simple'       => 0,
    },
    script_files        => [ qw(
        mowyw
    )],
    sign               => 0,
);
$build->create_build_script;

# vim: sw=4 ts=4 expandtab
