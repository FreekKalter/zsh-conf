#!/bin/bash

if [ ! -z $GITDIR ]; then
    # The script can be used as a git hook in project_dir/.git/hooks/post-commit
    # in this case the $GIT_DIR env variable will be set and you can use this to
    # navigate to the root of the project_dir to start linking.
    cd $GIT_DIR/..
else
    # If you have this file in the root of your prject_dir you can call it manualy
    # from the commandline to in that case the location of this script itself will
    # be used as the working directory.
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    cd $DIR
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
            # recurseDir will change the current working dir, so switch back
            # to the working dir for this loop
            cd $1
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
