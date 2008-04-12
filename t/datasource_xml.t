use strict;
use warnings;
use lib qw(blib);
use Test::More;

BEGIN {
    eval 'use XML::Simple';
    if ($@){
        plan skip_all => 'XML::Simple not available';
    } else {
        plan tests => 19;
    }
}

BEGIN {
    use_ok 'Mowyw::Datasource';
    use_ok 'Mowyw::Datasource::XML';
}

my $x = eval {
    Mowyw::Datasource->new({
            type    => 'XML',
            file    => 't/sample.xml',
    });
};

print $@ if $@;
ok !$@, 'No errors while creating Mowyw::Datasource::XML instance';


ok !$x->is_exhausted,           'Iterator not yet exhausted';
my $data = $x->get();
is $data->{foo},    'bar1',     'First element (item "foo") retrieved';
is $data->{baz},    'quox1',    'First element (item "baz") retrieved';
$x->next();
ok !$x->is_exhausted,           'Iterator not yet exhausted';
$data = $x->get();
is $data->{foo},    'bar2',     'Second element (item "foo") retrieved';
is $data->{baz},    'quox2',    'Second element (item "baz") retrieved';
$x->next();
ok !$x->is_exhausted,           'Iterator not yet exhausted';
$data = $x->get();
is $data->{foo},    'bar3',     'Third element (item "foo") retrieved';
is $data->{baz},    'quox3',    'Third element (item "baz") retrieved';
$x->next();
ok $x->is_exhausted,            'Iterator exhausted';

# next test file

$x = Mowyw::Datasource->new({
        type    => 'XML',
        file    => 't/sample-single.xml',
        root    => 'item',
});

ok $x,                          'Datasource created from t/sample-single.xml';
ok !$x->is_exhausted,           'Iterator not yet exhausted';
$data = $x->get();
is $data->{foo},    'bar',      'First element (item "foo") retrieved';
is $data->{baz},    'quox',     'First element (item "baz") retrieved';
$x->next();
ok $x->is_exhausted,            'Iterator exhausted';

eval {
    Mowyw::Datasource->new({
            type    => 'XML',
            file    => 't/sample-bad.xml',
    });
};

ok $@,                          'Dies with ambigous root element';
