#!/bin/bash
#
# Mike Kelly <mikekelly321@gmail.com>

# basics
: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# complete hostnames from this file
: ${HOSTFILE=~/.ssh/known_hosts}

# readline config
: ${INPUTRC=~/.inputrc}

# ----------------------------------------------------------------------
# PATH
# ----------------------------------------------------------------------

# we want the various sbins on the path along with /usr/local/bin
PATH="/usr/local/heroku/bin:/usr/local/bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin"

# ----------------------------------------------------------------------
# ENVIRONMENT CONFIGURATION
# ----------------------------------------------------------------------

# ignore backups, CVS directories, python bytecode, vim swap files
FIGNORE="~:CVS:#:.pyc:.swp:.swa:apache-solr-*"

# erase duplicate entries
HISTCONTROL=erasedups
# store 10k of them
HISTSIZE=10000
# Append to the history file when exiting instead of overwriting it
shopt -s histappend

# ----------------------------------------------------------------------
# PAGER / EDITOR
# ----------------------------------------------------------------------

# See what we have to work with ...
HAVE_VIM=$(command -v vim)

# EDITOR
test -n "$HAVE_VIM" &&
EDITOR=vim ||
EDITOR=vi
export EDITOR

# PAGER
if test -n "$(command -v less)" ; then
    PAGER="less -FirSwX"
    MANPAGER="less -FiRswX"
else
    PAGER=more
    MANPAGER="$PAGER"
fi
export PAGER MANPAGER

# ----------------------------------------------------------------------
# PROMPT
# ----------------------------------------------------------------------

source ~/.bash_colours

function format_last_commit_time {
        local NUMBER=$1
        local UNIT=""

        if [ "$NUMBER" = "na" ]; then
                UNIT=""
        elif [ "$NUMBER" -lt 1 ]; then
                NUMBER="now"
                UNIT=""
        elif [ "$NUMBER" -lt 60 ]; then
                UNIT="m"
        elif [ "$NUMBER" -lt 1440 ]; then
                NUMBER=`expr $NUMBER / 60`
                UNIT="h"
        else
                NUMBER=`expr $NUMBER / 1440`
                UNIT="d"
        fi

        echo "${NUMBER}${UNIT}"
}

function minutes_since_last_commit {
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
    if [ $? -eq 0 ]; then
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    else
      echo "na"
    fi
}

grb_git_prompt() {
    local g="$(__gitdir)"
    if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
                local DISPLAY_LAST_COMMIT_TIME=`format_last_commit_time $MINUTES_SINCE_LAST_COMMIT`
        local yellow=$(tput setaf 3)
        local green=$(tput setaf 2)
        local red=$(tput setaf 1)
        local none=$(tput sgr0)

        if [ $MINUTES_SINCE_LAST_COMMIT = "na" ]; then
            local COLOR=""
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
            local COLOR=${red}
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
            local COLOR=${yellow}
        else
            local COLOR=${green}
        fi

        if [ "$MINUTES_SINCE_LAST_COMMIT" = "na" ]; then
            local GIT_PROMPT=`__git_ps1`
        else
            local SINCE_LAST_COMMIT="\[${COLOR}\]${DISPLAY_LAST_COMMIT_TIME}\[${none}\]"
            local GIT_PROMPT=`__git_ps1 "(%s|${SINCE_LAST_COMMIT})"`
        fi
        PS1="\w ${GIT_PROMPT} \$ "
    else
      PS1="\w \$ "
    fi
}

PROMPT_COMMAND="grb_git_prompt"

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

test -z "$BASH_COMPLETION" && {
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    test -n "$PS1" && test $bmajor -gt 1 && {
        # search for a bash_completion file to source
        for f in /usr/local/etc/bash_completion \
                 /usr/pkg/etc/bash_completion \
                 /opt/local/etc/bash_completion \
                 /etc/bash_completion
        do
            test -f $f && {
                . $f
                break
            }
        done
    }
    unset bash bmajor bminor
}

# override and disable tilde expansion
_expand() {
    return 0
}

# Git completion
source ~/git-completion.bash

# ----------------------------------------------------------------------
# LS AND DIRCOLORS
# ----------------------------------------------------------------------

export CLICOLOR=1
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"

# we always pass these to ls(1)
LS_COMMON="-hBG"

# setup the main ls alias if we've established common args
test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias ll="ls -l"
alias l.="ls -d .*"

# -------------------------------------------------------------------
# SHELL ENVIRONMENT
# -------------------------------------------------------------------

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# load tmux with correct TERM setting
alias tmux='TERM=screen-256color tmux -2'

# tmuxifier stuff
export TMUXIFIER_LAYOUT_PATH="$HOME/.tmux_layouts/"
alias session="tmuxifier load-session"
[[ -s "$HOME/.tmuxifier/init.sh" ]] && source "$HOME/.tmuxifier/init.sh"

# ctags
alias ctags="ctags -R --exclude='.git'"

# binstubs
PATH="vendor/binstubs:$PATH"

alias dc="docker-compose"

export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/opt/go/libexec/bin

#eval $(docker-machine env curl)

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
