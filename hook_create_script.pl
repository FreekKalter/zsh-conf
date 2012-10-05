#!/usr/bin/perl

use v5.14;

my $script= q{#!/bin/sh
ln -f $GIT_DIR/../.zshrc ~/.zshrc
ln -f $GIT_DIR/../.zsh_aliases ~/.zsh_aliases
ln -f $GIT_DIR/../.tmux.conf ~/.tmux.conf
ln -f $GIT_DIR/../freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme
};
chomp $script;

for( qw(post-commit  post-merge) ){
    my $file = ".git/hooks/$_";
    open(my $dh, ">" , $file) or die "Can't open $file for writing";
    print $dh $script;
    `chmod +x $file`;
};
