#!/usr/bin/env perl

# perl might be a little overkill but i'm sick of shell scripts
use v5.12;
use File::Copy;

for( qw(post-commit  post-merge) ){
    my $file = ".git/hooks/$_";
    copy("template.sh", $file);
    `chmod +x $file`;
};
say "Hooks created";
