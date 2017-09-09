# Custom Settings

Set up is handled by the script `setup.sh`, which should be retrieved as a standalone file:

```
wget https://raw.githubusercontent.com/vibronicshark55/custom-settings/master/setup.sh
```

The script handles
* Creating keys for github.
* Fetching and installing [git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh).
* Clones necessary [repos](https://github.com/vibronicshark55/custom-settings#repos).
* Setting custom [settings](https://github.com/vibronicshark55/custom-settings#settings).
* Installing kdb+, if the user has sudo access and the necessary [files](https://github.com/vibronicshark55/custom-settings#installing-kdb).


## Running

On the initial use of this scripts git keys must be created,
this can be done with:
```
. setup.sh gitkeys
```
the public key should be added to [github](https://github.com/settings/keys).

After this all settings can be installed by using `all`:
```
. setup.sh all
```
NOTE: `gitkeys`,`libevent` and `tmux-dl` are not included in `all`


## Repos

* [tldr](https://github.com/raylee/tldr)
* [vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)
* [custom-settings](https://github.com/vibronicshark55/custom-settings)
* [myfuncs](https://github.com/vibronicshark55/myfuncs)
* [segment_comparison](https://github.com/vibronicshark55/segment_comparison)

### Optional Repos

* [tmux](https://github.com/tmux/tmux.git)

## Installing kdb
To install kdb+ the user will need sudo access and the `linuxx86.zip` file from [kx](https://kx.com/download/).
This final should be placed in the users home directory.

## Settings

Various settings files are included:

* bashrc
* bash_aliases
* bash_functions
* vimrc
* gitconfig
* tmux.conf
