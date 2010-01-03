use strict;
use warnings;
use lib 'lib';
use Mowyw::Lexer qw(lex);
use Test::More tests => 13;

my @tokens = (
        ['Int',         qr/(?:-|\+)?\d+/],
        ['Op',          qr/\+|\*|-|\//],
        ['Brace_Open',  qr/\(/],
        ['Brace_Close', qr/\)/],
        ['Whitespace',  qr/\s+/, sub { return undef; }],
    );
my $text = "12 + foo\n (3 * (4 + -1))BAR";

my @expected = split /\n/, <<EXPECTED;
Int: 12 (0; 1)
Op: + (3; 1)
UNMATCHED: foo (4; 1)
Brace_Open: ( (10; 2)
Int: 3 (11; 2)
Op: * (13; 2)
Brace_Open: ( (15; 2)
Int: 4 (16; 2)
Op: + (18; 2)
Int: -1 (20; 2)
Brace_Close: ) (22; 2)
Brace_Close: ) (23; 2)
UNMATCHED: BAR (24; 2)
EXPECTED

for (lex($text, \@tokens)) {
    my ($name, $matched, $pos, $line) = @$_;
    is "$name: $matched ($pos; $line)", shift(@expected);
}
