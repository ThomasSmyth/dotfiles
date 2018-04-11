echo "getting tmux"
mkdir -p $HOME/git && cd "$_"
git clone https://github.com/tmux/tmux.git
cd $HOME/git/tmux
./configure --prefix $HOME/local
make
make install
cd -
