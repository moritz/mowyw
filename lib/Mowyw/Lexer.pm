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

Mowyw::Lexer is a simple lexer that breaks up a text into tokens, depenending on the input tokens you provide

The only exported method is lex($$), which expects input text as its first argument and a array ref to list of input tokens.

Each input token consists of a token name (which you can choose freely), a regexwhich matches the desired token, and optionally a reference to a functions that takes the matched token text as its argument. The token text is replaced by the return value of that function. If the function returns undef, that token will not be included in the list of output tokens.

lex() returns a list of output tokens, each output token is a reference to a list which contains the token name and the matched text.

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

sub lex($$){
	my ($text, $tokens) = @_;
	return () unless (length $text);
	my @res;
	while (length($text) > 0){
		my $matched = 0;
		# try to match at the start of $text
		foreach (@$tokens){
			my $re = $_->[1];
			if ($text =~ m#^$re#s){
				$matched = 1;
				my $match = $&;
				die "Each token has to require at least one character; Rule $_->[0] matched Zero!\n" unless (length($match) > 0);
				if (my $fun = $_->[2]){
					$match = &$fun($match);
				}
				if (defined $match){
					push @res, [$_->[0], $&];
				}
				$text = $';
				last;
			}
		}
		unless ($matched){
			# no token matched, look what the closest token is
#			my $remain = substr $text, 0, 30;
#			die "No Token matched the remaining String which starts  as $remain\n";
			my $next_token;
			my $min = length($text);
			foreach(@$tokens){
				my $re = $_->[1];
				if ($text =~ m#$re#s){
					if (length($`) < $min){
						$min = length($`);
						$next_token = $_;
						$matched = 1;
					}
				}
			}
			if ($matched){
				my $re = $next_token->[1];
				$text =~ m#$re#;
				push @res, ['UNMATCHED', $`];
				my $match = $&;
				die "Each token has to require at least one character; Rule $_->[0] matched Zero!\n" unless (length($match) > 0);
				if (my $fun =$next_token->[2]){
					$match = &$fun($match);
				}
				push @res, [$next_token->[0], $match] if (defined $match);
				$text = $';
			} else {
				push @res, ['UNMATCHED', $text];
#				print "END OF FILE IS UNMATCHED: $text\n";
				$text = "";
			}
		}
	}
	return @res;
}
1;
