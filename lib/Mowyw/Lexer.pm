#!/usr/bin/perl
use warnings;
use strict;
package Mowyw::Lexer;

=pod
=head1 NAME

Mowyw::Lexer - Simple Lexer

=head1 SYNOPSIS
	
	use Mowyw::Lexer qw(lex);
	# suppose you want to parse simple math expressions
	my @input_tokens = (
		['Int',		qr/(?:-|\+)?\d+/],
		['Op', 		qr/\+|\*|-|\//],
		['Brace_Open',	qr/\(/],
		['Brace_Close',	qr/\)/],
		['Whitespace',	qr/\s/, sub { return undef; }],
	     );
	my $text = "-12 * (3+4)";
	foreach (lex($text, \@input_tokens){
		my ($name, $text) = @$_;
		print "Found Token $name: $text\n";
	}

=head1 DESCRIPTION

Mowyw::Lexer is a simple lexer that breaks up a text into tokens, depenending
on the input tokens you provide.

The only exported routine is C<lex>, which expects input text as its first
argument, and a array references as second argument, which contains arrays of
token names and regexes.

Each input token consists of a token name (which you can choose freely), a regexwhich matches the desired token, and optionally a reference to a functions that takes the matched token text as its argument. The token text is replaced by the return value of that function. If the function returns undef, that token will not be included in the list of output tokens.

C<lex> returns a list of output tokens, each output token is a reference to a list which contains the token name and the matched text.

If there is unmatched text, it is returned with the token name UNMATCHED.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Moritz Lenz, http://moritz.faui2k3.org, moritz@faui2k3.org

This Program and its Documentation is free software. You may distribute it under the same terms as perl itself.

However all code examples are to be public domain, so you can use it in any way you want to.

=cut

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(lex);

our %EXPORT_TAGS = (":all" => \@EXPORT);

sub lex {
	my ($text, $tokens) = @_;
	return () unless length $text;
	my @res;
    pos($text) = 0;
	while (pos($text) < length($text)){
		my $matched = 0;
		# try to match at the start of $text
		foreach (@$tokens){
			my $re = $_->[1];
			if ($text =~ m#\G($re)#gc){
				$matched = 1;
				my $match = $1;
				die "Each token has to require at least one character; Rule $_->[0] matched Zero!\n" unless (length($match) > 0);
				if (my $fun = $_->[2]){
					$match = $fun->($match);
				}
				if (defined $match){
					push @res, [$_->[0], $match, pos($text) - length($match)];
				}
				last;
			}
		}
		unless ($matched){
			my $next_token;
            my $next_token_match;
            my $match;

			my $min = length($text);
            my $pos = pos($text);

            # find the token that matches first
			foreach(@$tokens){
                pos($text) = $pos;
				my $re = $_->[1];
				if ($text =~ m#\G((?s:.)*?)($re)#gc){
					if ($+[1] < $min){
						$min              = $+[1];
						$next_token       = $_;
                        $next_token_match = $2;
						$match            = $1;
					}
				}
			}
			if (defined $match){
				push @res, ['UNMATCHED', $match, $pos - length($pos)];
				die "Each token has to require at least one character; Rule $_->[0] matched Zero!\n"
                    unless (length($next_token_match) > 0);
				if (my $fun = $next_token->[2]){
					$match = $fun->($match);
				}
				push @res, [$next_token->[0], $next_token_match, $min] if defined $match;
                pos($text) = $min + length($next_token_match);
			} else {
				push @res, ['UNMATCHED', substr($text, $pos), $pos];
                pos($text) = length($text);
			}
		}
	}
	return @res;
}
-1;
