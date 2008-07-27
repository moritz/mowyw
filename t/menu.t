use Test::More tests => 6;
use strict;
use warnings;

BEGIN { use_ok('Mowyw', 'parse_str'); };

my %meta = ( VARS => {}, FILES => [qw(t/menu.t)]);
$Mowyw::config{default}{include} = 't/';
$Mowyw::config{default}{menu}    = 't/menu-';
$Mowyw::config{default}{postfix} = '';


is  parse_str('[% menu sample %]', \%meta),
    " i1 i2 \n",
    'Menu without selected item';

is  parse_str('[% menu sample i1 %]', \%meta),
    " i1b i2 \n",
    'Menu with first item selected';

is  parse_str('[% menu sample i2 %]', \%meta),
    " i1 i2b \n",
    'Menu with second item selected';

is  parse_str('[% menu sample i3 %]', \%meta),
    " i1 i2  i3i1\n",
    'Menu with third item selected';

is  parse_str('[% menu sample i3 i3i1 %]', \%meta),
    " i1 i2  i3i1b\n",
    'Menu with third item and subitem selected';
