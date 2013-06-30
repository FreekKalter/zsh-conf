#!/bin/bash

cd $GIT_DIR/..
ln -f .zshrc ~/.zshrc
ln -f .zsh_aliases ~/.zsh_aliases
ln -f .tmux.conf ~/.tmux.conf
ln -f freek.zsh-theme ~/.oh-my-zsh/themes/freek.zsh-theme

echo "links created"
