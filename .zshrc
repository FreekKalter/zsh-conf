# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt incappendhistory 
setopt sharehistory
setopt extendedhistory

setopt extendedglob
unsetopt beep
bindkey -v

autoload -Uz compinit
compinit
setopt completeinword

#Type .. instead of cd ..
setopt auto_cd

#Display CPU usage stats for commands taking more than 10 seconds
REPORTTIME=10
# oh my zsh from here on down
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# custom key-bindings
bindkey -M viins 'jk' vi-cmd-mode


# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="fishy"
ZSH_THEME="freek"

#default editor
EDITOR=/usr/bin/vim
#load aliases file
source ~/.zsh_aliases
[[ -z ${fpath[(r)$HOME/.zsh/completion]} ]] && fpath=(~/.zsh/completion $fpath)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git extract vi-mode perl cpanm)

source $ZSH/oh-my-zsh.sh

# no freaking auto correct
unsetopt correct_all
export VISUAL='vim'
export EDITOR='vim'

# Customize to your needs...
#export PATH=/home/fkalter/perl5/perlbrew/bin:/home/fkalter/perl5/perlbrew/perls/perl-5.16.0/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

source ~/perl5/perlbrew/etc/bashrc
# TMUX
if which tmux 2>&1 >/dev/null; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux

    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi
