#!/usr/bin/perl
# test Mowyw::Lexer
use warnings;
use strict;
use Mowyw::Lexer qw(lex);


my @tokens = (	
		['Int',		qr/(?:-|\+)?\d+/],
		['Op', 		qr/\+|\*|-|\//],
		['Brace_Open',	qr/\(/],
		['Brace_Close',	qr/\)/],
		['Whitespace',	qr/\s/, sub { return undef; }],
	     );
my $text = "12 + foo (3 * (4 + -1))BAR";
my @pt = lex($text, \@tokens);
foreach (@pt){
	my ($name, $text) = @$_;
	print "Found Token $name: $text\n";
}
