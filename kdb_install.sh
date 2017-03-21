cd ~
sudo apt-get install gcc-multilib
if [ -f linuxx86.zip ]; then
    unzip linuxx86.zip
    mv q ~/.bin/
    export QHOME=~/.bin/q
    export PATH=~/.bin/q/l32/:$PATH
fi
