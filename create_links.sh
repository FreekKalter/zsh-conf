#!/bin/bash

if [ ! -z $GITDIR ]; then # to call it manualy
    cd $GIT_DIR/..
fi
ln -f .zshrc ~/.zshrc
ln -f .zsh_aliases ~/.zsh_aliases
ln -f .tmux.conf ~/.tmux.conf
ln -f freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

# $1 source $2 destination
recurseDir(){
    cd $1
    if [ ! -e $2 ]; then
        mkdir $2
    fi
    for i in *
    do
        if [ -d $i ]
        then
            recurseDir "$1/$i" "$2/$i"
        else
            ln -sf "$1/$i" "$2/$i"
        fi
    done
}

destination=~/scripts
if [ ! -e $destination ]; then
    mkdir $destination
fi
recurseDir "`pwd`/scripts" $destination
# remove dead links, files wich are deleted in git
find $destination -type l ! -exec test -r {} \; -delete
