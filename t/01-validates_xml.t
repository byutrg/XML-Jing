#basic test file

use strict;
use warnings;
use XML::Jing;
use Test::More;
use Path::Tiny;
use FindBin qw($Bin);

plan tests => 1;
my $jing = XML::Jing->new(path($Bin, 'data','test.rng'));
ok(1);
diag $jing->validate(path($Bin, 'data','testPASS.xml'));