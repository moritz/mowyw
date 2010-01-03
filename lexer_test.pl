#!/usr/bin/perl
# test Mowyw::Lexer
use warnings;
use strict;
use Mowyw::Lexer qw(lex);


my @tokens = (
        ['Int',         qr/(?:-|\+)?\d+/],
        ['Op',          qr/\+|\*|-|\//],
        ['Brace_Open',  qr/\(/],
        ['Brace_Close', qr/\)/],
        ['Whitespace',  qr/\s+/, sub { return undef; }],
         );
my $text = "12 + foo\n (3 * (4 + -1))BAR";
my @pt = lex($text, \@tokens);
foreach (@pt){
    my ($name, $matched, $pos, $line) = @$_;
    print "Found Token $name: $matched ($pos; $line)\n";
}
