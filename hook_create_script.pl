#!/usr/bin/perl

use v5.12;

my $script= q{#!/bin/sh
ln -f $GIT_DIR/../.zshrc ~/.zshrc
ln -f $GIT_DIR/../.zsh_aliases ~/.zsh_aliases
ln -f $GIT_DIR/../.tmux.conf ~/.tmux.conf
ln -f $GIT_DIR/../freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

mkdir -p ~/scripts
ln -f $GIT_DIR/../scripts/* ~/scripts

mkdir -p ~/scripts/sabnzbd
ln -f $GIT_DIR/../scripts/sabnzbd/* ~/scripts/sabnzbd

echo "Links created"
};

for( qw(post-commit  post-merge) ){
    my $file = ".git/hooks/$_";
    open(my $dh, ">" , $file) or die "Can't open $file for writing";
    print $dh $script;
    `chmod +x $file`;
};
say "Hooks created";
