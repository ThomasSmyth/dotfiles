mkdir -p $HOME/.ssh                                                                             # create ssh dir

## settings

for stg in $@; do
    if [ "all" = $stg ]; then
        stg="repos bashrc bash vim git tmux-conf libevent scripts kdb"
    fi

    stgs=$stgs" "$stg
done

for stg in $stgs; do

    case $stg in

        gitkeys )
            echo "Creating git keys, enter git email"
            read gitemail
            ssh-keygen -N '' -t rsa -b 4096 -C "$gitemail" -f $HOME/.ssh/${HOSTNAME}_key
            echo "Host github.com" >> $HOME/.ssh/config
            echo "IdentityFile $HOME/.ssh/${HOSTNAME}_key" >> $HOME/.ssh/config
            echo "Add key to github before proceeding"
            return 0
        ;;

        repos )
            echo "cloning repos"                                                                # clone necessary repos
            mkdir -p $HOME/git && cd "$_"
            git clone https://github.com/raylee/tldr.git
            git clone https://github.com/patmok/qvim.git
            git clone git@github.com:vibronicshark55/custom-settings.git
            git clone git@github.com:vibronicshark55/myfuncs.git
            git clone git@github.com:vibronicshark55/segment_comparison.git

            echo "adding tldr"                                                                  # install tldr
            mkdir -p $HOME/local/bin
            curl -o $HOME/local/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
            chmod +x $HOME/local/bin/tldr

            echo "fetching git-prompt.sh"                                                       # get git prompt script
            wget -O $HOME/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

            echo "adding kdb syntax highlighting"                                               # vim kdb syntax highlighting
            mkdir -p $HOME/.vim
            cp -r $HOME/git/qvim/.vim/* $HOME/.vim

            cd -
        ;;

        bashrc )
            echo "adding to bashrc"                                                             # add settings
            if [ ! "source ~/.bash_custom.sh" = "$(tail -n 1 ~/.bashrc)" ]; then
                echo "source ~/.bash_custom.sh" >> ~/.bashrc
            fi
            cat $HOME/git/custom-settings/bash_custom.sh > $HOME/.bash_custom.sh                # custom bash settings
            cat $HOME/git/custom-settings/settings.q > $HOME/.settings.q
        ;;

        bash )
            echo "adding additional bash files"                                                 # add settings
            mkdir -p $HOME/.custom																# create dir for custom scripts
            cat $HOME/git/custom-settings/bash_functions.sh > $HOME/.custom/bash_functions.sh   # alias for use in bash
            cat $HOME/git/custom-settings/bash_aliases.sh > $HOME/.custom/bash_aliases.sh       # alias for use in bash
        ;;

        vim )
            echo "adding vim settings files"                                                    # add settings
            cat $HOME/git/custom-settings/vimrc > $HOME/.vimrc                                  # custom vimrc
            mkdir -p $HOME/.vim/ftplugin
            cp $HOME/git/custom-settings/ftplugin/* $HOME/.vim/ftplugin                         # custom filetype settings
        ;;

        git )
            cat $HOME/git/custom-settings/gitconfig > $HOME/.gitconfig                          # custom gitconfig

            echo "input git name"                                                               # set git name
            read gitname
            echo "setting name to $gitname"
            git config --global user.name "$gitname"

            echo "input git email"                                                              # set git email
            read gitemail
            echo "setting email to $gitemail"
            git config --global user.email "$gitemail"
        ;;

        tmux-dl )
            echo "getting tmux"
            mkdir -p $HOME/git && cd "$_"
            git clone https://github.com/tmux/tmux.git
            cd $HOME/git/tmux
            ./configure --prefix $HOME/local
            make
            make install
            cd -
        ;;

        tmux-conf )
            echo "adding tmux files"
            cat $HOME/git/custom-settings/tmux.conf > $HOME/.tmux.conf                          # custom tmux settings
        ;;

        libevent )
            echo "getting libevent"
#            wget https://github.com/libevent/libevent/releases/tag/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
            wget https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz
            tar -xvzf $HOME/git/custom-settings/libevent-2.0.19-stable.tar.gz
            cd $HOME/git/custom-settings/libevent-2.0.19-stable
            ./configure --prefix=$HOME/local
            make
            make install
            cd -
            rm $HOME/git/custom-settings/libevent-2.0.19-stable.tar.gz
            rm -r $HOME/git/custom-settings/libevent-2.0.19-stable
        ;;

        scripts )
            mkdir -p $HOME/scripts                                                              # custom scripts
            cp -rsf $HOME/git/custom-settings/scripts/* $HOME/scripts/
        ;;

        kdb )
            echo "checking for kdb+"
            . $HOME/git/custom-settings/kdb_install.sh
        ;;

        * )
            echo "Invalid option: $stg"
        ;;

    esac

done

stgs=""

echo "sourcing $HOME/.bashrc"                                                                   # wrapping up
source $HOME/.bashrc

echo "setup complete"
