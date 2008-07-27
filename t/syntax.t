use Test::More tests => 3;
use strict;
use warnings;

BEGIN { use_ok('Mowyw', 'parse_str'); };

$Mowyw::Quiet = 1;

{
    # Test without Vim::TextColor first
    local @INC = ();
    my $ps =  parse_str('[% syntax foobar %]<argl>[% endsyntax %]', {}); 

    ok $ps !~ m/<argl>/, 'Syntax hilighting at least escapes';
}

{
    my $ps =  parse_str('[% syntax foobar %]<argl>[% endsyntax %]', {}); 

    ok $ps !~ m/<argl>/, 'Syntax hilighting at least escapes';
}
