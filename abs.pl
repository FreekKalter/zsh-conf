#!/usr/bin/perl

use strict;
use warnings;
use Cwd 'abs_path';
my $root = $ARGV[0];
$root = abs_path($root);
print $root , "\n";
