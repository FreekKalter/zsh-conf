#!/usr/bin/env perl

use v5.12;
use Cwd;
use File::Spec;

my $script= qq{#!/bin/sh
if [ -z \$GIT_DIR ]; then
    SCRIPT_LOC=\$(readlink -f \$0)
    SCRIPT_PATH=`dirname \$SCRIPT_LOC`
    GIT_DIR="\$SCRIPT_PATH/.."
fi

ln -f \$GIT_DIR/../.zshrc ~/.zshrc
ln -f \$GIT_DIR/../.zsh_aliases ~/.zsh_aliases
ln -f \$GIT_DIR/../.tmux.conf ~/.tmux.conf
ln -f \$GIT_DIR/../freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

mkdir -p ~/scripts
ln -sf \$GIT_DIR/../scripts/*  ~/scripts

echo "Links created"
};

for( qw(post-commit  post-merge) ){
    my $file = ".git/hooks/$_";
    open(my $dh, ">" , $file) or die "Can't open $file for writing";
    print $dh $script;
    `chmod +x $file`;
};
say "Hooks created";
