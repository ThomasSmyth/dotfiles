# create ssh dir
mkdir -p ~/.ssh

# ensure git keys exist
if [ 2 -ne $(find ~/.ssh -type f -name ${HOSTNAME}* | wc -l) ]; then
    echo "Creating git keys"
    ssh-keygen -N '' -t rsa -b 4096 -C "tsmyth92@gmail.com" -f  ~/.ssh/${HOSTNAME}_key
    echo "Host github.com" >> ~/.ssh/config
    echo "IdentityFile ~/.ssh/${HOSTNAME}_key" >> ~/.ssh/config
    echo "Add key to github before proceeding"
    return 0
fi
echo "git keys exist"

# get git prompt script
echo "fetching git-prompt.sh"
wget -O ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# clone necessary repos
echo "cloning repos"
mkdir -p ~/git
cd ~/git
git clone https://github.com/raylee/tldr.git
git clone https://github.com/katusk/vim-qkdb-syntax.git
git clone git@github.com:rocketship92/custom-settings.git
git clone git@github.com:rocketship92/myfuncs.git
git clone git@github.com:rocketship92/segment_comparison.git

# install tldr
echo "adding tldr"
mkdir -p ~/.bin
curl -o ~/.bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x ~/.bin/tldr

# add settings
echo "updating settings files"
cat ~/git/custom-settings/bash.txt >> ~/.bashrc
touch ~/.vimrc
cat ~/git/custom-settings/vim.txt >> ~/.vimrc
touch ~/.gitconfig
cat ~/git/custom-settings/git.txt >> ~/.gitconfig

# vim kdb syntax highlighting
echo "adding kdb syntax highlighting"
mkdir -p ~/.vim
cp -r ~/git/vim-qkdb-syntax/* ~/.vim

mkdir -p ~/scripts

cp ~/git/custom-settings/scripts/* ~/scripts

echo "checking for kdb+"
. ~/git/custom-settings/kdb_install.sh

echo "sourcing ~/.bashrc"
source ~/.bashrc

echo "setup complete"
cd ~
