#!/home/fkalter/perl

use v5.12;
use Cwd;
use File::Spec;
use Path::Class;

my $dir = dir( File::Spec->rel2abs( getcwd ), "scripts" );

my $script= qq{#!/bin/sh
ln -f \$GIT_DIR/../.zshrc ~/.zshrc
ln -f \$GIT_DIR/../.zsh_aliases ~/.zsh_aliases
ln -f \$GIT_DIR/../.tmux.conf ~/.tmux.conf
ln -f \$GIT_DIR/../freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

mkdir -p ~/scripts
ln -sf $dir/*  ~/scripts

echo "Links created"
};

for( qw(post-commit  post-merge) ){
    my $file = ".git/hooks/$_";
    open(my $dh, ">" , $file) or die "Can't open $file for writing";
    print $dh $script;
    `chmod +x $file`;
};
say "Hooks created";
