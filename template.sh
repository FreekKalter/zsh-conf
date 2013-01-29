#!/bin/bash
SCRIPT_LOC=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT_LOC`
GIT_DIR="$SCRIPT_PATH/.."

function link_recursive(){
    dir=$1      # part after $GIT_DIR/..
    target=$2   # base of target dir

    cleaned_up_dir=$($GIT_DIR/../abs.pl $target/${dir##$GIT_DIR/..})
    mkdir -p $cleaned_up_dir
    for a in $GIT_DIR/../$dir/*; do
        if [ -d $a ]; then
            link_recursive ${a##$GIT_DIR/..} $target # strip first part of the path to make it relative
        elif [ -f $a ]; then
            relative_part=$target${a##$GIT_DIR/..}
            ln -sf $($GIT_DIR/../abs.pl $a) $relative_part # make $a a relative path to paste behind $target
        fi
    done
}

ln -f $GIT_DIR/../.zshrc ~/.zshrc
ln -f $GIT_DIR/../.zsh_aliases ~/.zsh_aliases
ln -f $GIT_DIR/../.tmux.conf ~/.tmux.conf
ln -f $GIT_DIR/../freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

link_recursive "scripts" ~ # 1)pass dir relative to "$GIT_DIR/.." 2) dir to create replica of argument 1

echo "Links created"
