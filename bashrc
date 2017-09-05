# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# set functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# files to sourse
source ~/.git-prompt.sh

# variables
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth                                          # no duplicate lines in history

# PS1
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[1;33m\]@\[\033[01;34m\]\h\[\033[01;37m\] \w\[\033[1;33m\]$(__git_ps1 " [%s]")> \[\033[00m\]'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# add user programs to path
export PATH=~/local/bin:$PATH

if [ -d ~/.bin/q ]; then
    export QHOME=~/local/bin/q
    export PATH=~/local/bin/q/l32/:$PATH
fi
