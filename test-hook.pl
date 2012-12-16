#!/usr/bin/env perl
use v5.14;
use File::Spec;

my %tmpENV = (
          'GIT_DIR' => "$ENV{PWD}/.git" ,
);
local %ENV = (%ENV, %tmpENV);
my $exec = $ARGV[0] || "$ENV{PWD}/.git/hooks/post-commit";
say $exec;
`$exec`;
