package TestLib;

use File::Temp qw/tempfile/;
use File::Slurp qw(slurp);

use strict;
use warnings;

# Squash all the XML with xmllint, in an attempt to make diffs sane.

sub smash {
    my ($data) = @_;
    return $data unless $data =~ /^</;
    my ($fh, $fn) = tempfile( SUFFIX => '.xml', UNLINK => 1 );
    print $fh $data;
    close $fh;

    open(my $lint, '-|', 'xmllint', '--format', $fn) or die $!;
    return slurp($lint);
}

1;
