mkdir -p $HOME/.ssh                                                                 # create ssh dir

if [ 2 -ne $(find $HOME/.ssh -type f -name ${HOSTNAME}* | wc -l) ]; then            # ensure git keys exist
    echo "Creating git keys, enter git email"
    read gitemail
    ssh-keygen -N '' -t rsa -b 4096 -C "$gitemail" -f  $HOME/.ssh/${HOSTNAME}_key
    echo "Host github.com" >> $HOME/.ssh/config
    echo "IdentityFile $HOME/.ssh/${HOSTNAME}_key" >> $HOME/.ssh/config
    echo "Add key to github before proceeding"
    return 0
fi
echo "git keys exist"

echo "fetching git-prompt.sh"                                                       # get git prompt script
wget -O $HOME/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

echo "cloning repos"                                                                # clone necessary repos
mkdir -p $HOME/git && cd "$_"
git clone https://github.com/raylee/tldr.git
git clone https://github.com/katusk/vim-qkdb-syntax.git
git clone git@github.com:rocketship92/custom-settings.git
git clone git@github.com:rocketship92/myfuncs.git
git clone git@github.com:rocketship92/segment_comparison.git

echo "adding tldr"                                                                  # install tldr
mkdir -p $HOME/.bin
curl -o $HOME/.bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x $HOME/.bin/tldr

echo "updating settings files"                                                      # add settings
cat $HOME/git/custom-settings/bash_aliases >> $HOME/.bash_aliases                   # alias for use in bash
cat $HOME/git/custom-settings/bash_functions.sh >> $HOME/.bash_functions            # alias for use in bash
cat $HOME/git/custom-settings/bashrc >> $HOME/.bashrc                               # custom bashrc
cat $HOME/git/custom-settings/vimrc >> $HOME/.vimrc                                 # custom vimrc
mkdir -p $HOME/.vim/ftplugin
cp $HOME/git/custom-settings/ftplugin/* $HOME/.vim/ftplugin                         # custom filetype settings
cat $HOME/git/custom-settings/gitconfig >> $HOME/.gitconfig                         # custom gitconfig

echo "input git name"                                                               # set git name
read gitname
echo "setting name to $gitname"
git config --global user.name "$gitname"

echo "input git email"                                                              # set git email
read gitemail
echo "setting email to $gitemail"
git config --global user.email "$gitemail"

echo "adding kdb syntax highlighting"                                               # vim kdb syntax highlighting
mkdir -p $HOME/.vim
cp -r $HOME/git/vim-qkdb-syntax/* $HOME/.vim

mkdir -p $HOME/scripts                                                              # custom scripts
cp -rsf $HOME/git/custom-settings/scripts/* $HOME/scripts/

echo "checking for kdb+"
. $HOME/git/custom-settings/kdb_install.sh

echo "sourcing $HOME/.bashrc"                                                       # wrapping up
source $HOME/.bashrc

echo "setup complete"
cd $HOME
