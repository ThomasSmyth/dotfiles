# Custom Settings

This repo stores and manages the install of various dotfiles and settings files.

## First time set up

On a new environment initial set up is handled by the standalone file
`onetime.sh` which can be retrieved directly from the master branch.

```
wget https://raw.githubusercontent.com/vibronicshark55/custom-settings/master/onetime.sh
. onetime.sh
```

First time running the script will create SSH keys for use with Github. After
the keys are created further running the script will clone this repo, if it
does not already exist.

## Add dotfiles

The addition of dotfiles and other settings is handled by `init.sh` which is
available upon cloning this repo. This script must then be passed then name of
the settings to install, or all. The following options are available:

- [repos](#repos)
- [bashrc](#bashrc)
- [dotfiles](#dotfiles)
- [git](#git)
- [vim](#vim)
- [scripts](#scripts)
- [kdb](#kdb)
- [tldr](#tldr)
- [tmux_install](#tmux_install)
- [libevent\*](#libevent)

> \* Not included in all

## Availble Settings

The following are details of the available settings.

### repos

Will clone the repos listed in [repos.txt](https://github.com/vibronicshark55/custom-settings/blob/master/repos.txt).

### dotfiles

Various settings files are included:

- .bash_custom.sh - environment settings
- .custom/ - bash functions and aliases
- .vimrc - vim settings
- .vim/ - language specific plugins
- .gitconfig - git aliases and settings
- .tmux.conf - custom prefix and bindings

### bashrc

Ensures that `.bash_custom.sh` is sourced in `.bashrc`, and installs
`gitprompt.sh` which is sourced by the custom bash file.

### git

Adds git global user and email.

### vim

Adds [kdb syntax highlighting](https://github.com/patmok/qvim) from
[patmok](https://github.com/patmok). 

### scripts

Adds:
- multigrep.sh - simplified multiple word search for grep
- tmux_session.sh - basic tmux session template

### kdb

Installs kdb+ if the user has sudo access and `linuxx86.zip` from
[kx](https://kx.com/download/). It is expected that this file is
placed in the users home directory.

### tldr

Retrieves [tldr](https://github.com/raylee/tldr) from
[raylee](https://github.com/raylee) which shows simplified man pages.

### tmux_install

Will install [tmux](https://github.com/tmux/tmux) if it does not already
exist on the host.

### libevent

Installs libevent, can't remember why this was needed.
