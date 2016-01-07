#!perl6

use v6;

use Test;

use IO::Path::Mode;

can-ok $*PROGRAM, 'mode', "an IO has our method";
isa-ok $*PROGRAM.mode, IO::Path::Mode, "and it's the right sort of thing";


done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
