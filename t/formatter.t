#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::Differences;
use File::Slurp qw(slurp);
use App::Prove 3.12;
use File::Temp qw/tempfile/;

###############################################################################
# Figure out how many tests we have to run.
#
# *MANY* thanks Andy Armstrong et al. for the fabulous set of tests in
# Test::Harness. :)
my @tests = grep { -f $_ } <t/data/tests/*>;
plan tests => scalar(@tests);

###############################################################################
# Run each of the tests in turn, and compare the output to the expected JUnit
# output.
foreach my $test (@tests) {
    (my $junit = $test) =~ s{/tests/}{/tests/junit/};

    my $received = smash(scalar `$^X t/bin/my-prove --formatter TAP::Formatter::JUnit --merge $test`);
    my $expected = smash(scalar slurp($junit));

    eq_or_diff $received, $expected, $test;
}

# Squash all the XML with xmllint, in an attempt to make diffs sane.

sub smash {
    my ($data) = @_;

    my ($fh, $fn) = tempfile( SUFFIX => '.xml', UNLINK => 1 );
    print $fh $data;
    close $fh;

    open(my $lint, '-|', 'xmllint', '--format', $fn) or die $!;
    my $ret = slurp($lint);

    if ($ret eq '') {
        return $data;
    }
    return $ret;
}
