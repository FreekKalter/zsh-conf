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

bindkey '^R' history-incremental-search-backward

autoload -Uz compinit
compinit
setopt complete_in_word

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
export COLUMNS=${COLUMNS}

# Customize to your needs...
#export PATH=/home/fkalter/perl5/perlbrew/bin:/home/fkalter/perl5/perlbrew/perls/perl-5.16.0/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

source ~/perl5/perlbrew/etc/bashrc

export GOROOT=/usr/local/go
export PATH=$PATH:~/scripts:$GOROOT/bin
export GOPATH=~/gopath

# set go env variables
#if [[ $(uname) == "Linux" ]]; then
#    export GOROOT="/usr/lib/go"
#    export GOBIN="$GOROOT/bin"
#    export GOARCH="386"
#    export GOCHAR="8"
#    export GOOS="linux"
#    export GOEXE=""
#    export GOHOSTARCH="386"
#    export GOHOSTOS="linux"
#    export GOTOOLDIR="/usr/lib/go/pkg/tool/linux_386"
#    export GOGCCFLAGS="-g -O2 -fPIC -m32 -pthread"
#    export CGO_ENABLED="1"
#fi

# TMUX
if [ -z "$SSH_CONNECTION" ]; then
    if which tmux 2>&1 >/dev/null; then
        # if no session is started, start a new session
        test -z ${TMUX} && tmux
    fi
else 
    TERM="linux"
fi
