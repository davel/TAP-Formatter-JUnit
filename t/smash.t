#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use TestLib;

my $a = q{<testsuites>
  <testsuite failures="0" errors="0" tests="5" name="data_tests_descriptive">
    <system-out><![CDATA[1..5
ok 1    Interlock activated
ok 2    Megathrusters are go
]]></system-out>
    <system-err><![CDATA[
bad 1
fail 2
]]></system-err>
  </testsuite>
</testsuites>
};

my $b = q{<testsuites>
  <testsuite failures="0" errors="0" tests="5" name="data_tests_descriptive">
    <system-out><![CDATA[1..5
        ok 1    Interlock activated
        ok 2    Megathrusters are go
]]></system-out>
    <system-err><![CDATA[
        bad 1
        fail 2
]]></system-err>
  </testsuite>
</testsuites>
};

my $bprime = join("\n", map { s/^\s*//; $_; } split(/\n/, $b));

isnt(TestLib::smash($a), TestLib::smash($b), 'not equal, white space in CDATA');
is(TestLib::smash($a), TestLib::smash($bprime), 'kill leading whitespace everywhere, now equal');

done_testing();
