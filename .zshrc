# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000000
SAVEHIST=100000000
setopt incappendhistory
setopt sharehistory
setopt extendedhistory

setopt extendedglob
unsetopt beep
bindkey -v

bindkey '^R' history-incremental-search-backward

setopt complete_in_word

# Type .. instead of cd ..
setopt auto_cd

# Display CPU usage stats for commands taking more than 10 seconds
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
# ZSH_THEME="fishy"
ZSH_THEME="freek"

export TERM=xterm-256color
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git extract vi-mode perl docker golang)

source $ZSH/oh-my-zsh.sh

fpath=(~/.zsh/completion $fpath)

# completion system
autoload -Uz compinit
compinit

# no freaking auto correct
unsetopt correct_all
export VISUAL='gvim -f'
export EDITOR='vim'
export COLUMNS=${COLUMNS}

export VAGRANT_HOME='/media/truecrypt3/.vagrant.d'

# Customize to your needs...
# export PATH=/home/fkalter/perl5/perlbrew/bin:/home/fkalter/perl5/perlbrew/perls/perl-5.16.0/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

export GOPATH=~/gopath
export PATH=$PATH:/usr/local/go/bin

if [ -d $GO_ROOT ] && [ -d $GOPATH ]; then
    export PATH=$PATH:$GO_ROOT/bin:$GOPATH/bin
    # commandline completion
fi

export PATH=$PATH:~/scripts
export PATH=$PATH:~/scripts/links
export PATH=$PATH:/usr/local/share/python
export PATH=/home/fkalter/anaconda3/bin:$PATH
export PATH=/home/fkalter/anaconda/bin:$PATH

if [ -e ~/perl5/perlbrew/etc/bashrc ]; then
    source ~/perl5/perlbrew/etc/bashrc
fi

eval "$(fasd --init auto)"

# load aliases file
source ~/.zsh_aliases

# TMUX
if [ -z "$SSH_CONNECTION" ]; then
    if which tmux 2>&1 >/dev/null; then
        # if no session is started, start a new session
        test -z ${TMUX} && tmux
    fi
else
    TERM="xterm-256color"
fi

# don't hang ctrl-s when in terminal vim
stty -ixon
