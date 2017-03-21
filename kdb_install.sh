sudolist=$(grep '^sudo:.*$' /etc/group | cut -d: -f4 | tr "," " ")

echo $sudolist

for u in $sudolist; do
    if [ $u=$USER ]; then
        sudo apt-get install gcc-multilib
        if [ -f linuxx86.zip ]; then
            echo "installing kdb+"
            unzip linuxx86.zip
            mv q ~/.bin/
            export QHOME=~/.bin/q
            export PATH=~/.bin/q/l32/:$PATH
        fi
    fi
done
