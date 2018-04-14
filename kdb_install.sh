#!/usr/bin/env bash

sudolist=$(grep '^sudo:.*$' /etc/group | cut -d: -f4 | tr "," " ")

echo $sudolist

for u in $sudolist; do
    if [ $u=$USER ]; then
        sudo apt-get install gcc-multilib
        sudo apt install rlwrap
        sudo apt install unzip
        if [ -f ~/linuxx86.zip ]; then
            echo "installing kdb+"
            unzip ~/linuxx86.zip
            mv q/ ~/local/bin/
            export QHOME=~/local/bin/q
            export PATH=~/local/bin/q/l32/:$PATH
        fi
    fi
done
