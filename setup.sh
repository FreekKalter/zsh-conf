#!/bin/sh

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

ln -fs `pwd`/.zshrc ~/.zshrc
ln -fs `pwd`/.zsh_aliases ~/.zsh_aliases
ln -fs `pwd`/.tmux.conf ~/.tmux.conf
ln -fs `pwd`/freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

git clone https://github.com/clvv/fasd.git ~/fasd
cd ~/fasd
sudo make install
