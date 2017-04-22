# custom-settings

Set up is handled by the script `setup.sh`, which should be retrieved as a standalone file:

```
wget https://raw.githubusercontent.com/rocketship92/custom-settings/master/setup.sh
```

The script handles
* Creating keys for github.
* Fetching and installing [git-prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh).
* Clones necessary [repos](https://github.com/rocketship92/custom-settings#repos).
* Setting custom [settings](https://github.com/rocketship92/custom-settings#settings).
* Installing kdb+, if the user has sudo access and the necessary [files](https://github.com/rocketship92/custom-settings#installing-kdb).


## Running

On the initial use of this scripts keys are created, with the public key
needing added to [github](https://github.com/settings/keys).

After the public key has been added running the script again will complete the setup.


## Repos

* [tldr](https://github.com/raylee/tldr)
* [vim-qkdb-syntax](https://github.com/katusk/vim-qkdb-syntax)
* [custom-settings](https://github.com/rocketship92/custom-settings)
* [myfuncs](https://github.com/rocketship92/myfuncs)
* [segment_comparison](https://github.com/rocketship92/segment_comparison)

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
