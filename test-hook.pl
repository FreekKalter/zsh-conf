#!/usr/bin/env perl
use v5.14;
use File::Spec;
use Cwd;

my %tmpENV = (
          'GIT_DIR' =>  getcwd() . "/.git" ,
);
local %ENV = (%ENV, %tmpENV);
my $exec = $ARGV[0] || getcwd() . "/.git/hooks/post-commit";
`$exec`;
