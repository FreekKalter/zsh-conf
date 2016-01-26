#!/bin/bash

# Install necessary programs
declare -A NEEDED_PROGS=( ["git"]="git"
			  ["tmux"]="tmux"
			  ["zsh"]="zsh"
		          ["make"]="build-essential" )
TO_INSTALL=""

# [@] will get all elements, crazy bash
for prog in "${!NEEDED_PROGS[@]}"; do
    if [[ -z $(command -v $prog) ]]; then
        TO_INSTALL="$TO_INSTALL ${NEEDED_PROGS["$prog"]}"
    fi
done

if [[ -n $TO_INSTALL ]]; then
    echo "[-] going to install $TO_INSTALL"
    sudo apt-get install -y $TO_INSTALL
    echo "[+] installed necessary programs"
fi

if [ ! -d ~/.oh-my-zsh ]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

ln -fs `pwd`/.zshrc ~/.zshrc
ln -fs `pwd`/.zsh_aliases ~/.zsh_aliases
ln -fs `pwd`/.tmux.conf ~/.tmux.conf
ln -fs `pwd`/freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme
mkdir -p ~/.config
ln -fs `pwd`/flake8 ~/.config/flake8

if [ ! -d ~/fasd ]; then
    git clone https://github.com/clvv/fasd.git ~/fasd
    cd ~/fasd
    sudo make install
fi
