## initialise settings

rootc=$(dirname "${BASH_SOURCE}")                                                               # return custom settings directory
dfiles=$rootc/dotfiles

for stg in $@; do
    if [ "all" = $stg ]; then
        stg="repos bashrc dotfiles git scripts kdb"
    fi

    stgs=$stgs" "$stg
done

for stg in $stgs; do

  case $stg in

    gitkeys )
      echo "Creating git keys, enter git email"
      read gitemail
      mkdir -p $HOME/.ssh                                                                       # create ssh dir
      ssh-keygen -N '' -t rsa -b 4096 -C "$gitemail" -f $HOME/.ssh/${HOSTNAME}_key
      echo "Host github.com" >> $HOME/.ssh/config
      echo "IdentityFile $HOME/.ssh/${HOSTNAME}_key" >> $HOME/.ssh/config
      echo "Add key to github before proceeding"
      return 0
    ;;

    repos )
      echo "cloning repos"                                                                      # clone necessary repos
      while read line; do
        gf=$(basename $line)                                                                    # return *.git file
        gn=$HOME/git/${gf%$".git"}																# drop .git to return directory name
        if [ ! -d $gn ]; then																	# check if repo has been cloned
          echo "cloning $gf"
          mkdir -p $gn																			# create directory to store repo
          git clone $line $gn																	# clone repo
        fi
      done < $rootc/repos.txt                                                                   # file contains list of repos to clone

      echo "adding tldr"                                                                        # install tldr
      mkdir -p $HOME/local/bin
      curl -o $HOME/local/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
      chmod +x $HOME/local/bin/tldr

      echo "fetching git-prompt.sh"                                                             # get git prompt script
      wget -O $HOME/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

      echo "adding kdb syntax highlighting"                                                     # vim kdb syntax highlighting
      mkdir -p $HOME/.vim
      cp -r $HOME/git/qvim/.vim/* $HOME/.vim

      cd -
    ;;

    bashrc )
      echo "adding to bashrc"                                                                   # add settings
      if [ ! "source ~/.bash_custom.sh" = "$(tail -n 1 ~/.bashrc)" ]; then
          echo "source ~/.bash_custom.sh" >> ~/.bashrc									        # ensure custom settings are picked up by bashrc
      fi
    ;;

    dotfiles )
      echo "adding dotfiles"                                                                    # add dotfiles
      cp -r $dfiles/* ~                                                                         # copy to homedir
    ;;

    git )
      echo "input git name"                                                                     # set git name
      read gitname
      echo "setting name to $gitname"
      git config --global user.name "$gitname"

      echo "input git email"                                                                    # set git email
      read gitemail
      echo "setting email to $gitemail"
      git config --global user.email "$gitemail"
    ;;

    libevent )
      echo "getting libevent"
#      wget https://github.com/libevent/libevent/releases/tag/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
      wget https://github.com/downloads/libevent/libevent/libevent-2.0.19-stable.tar.gz
      tar -xvzf $custhome/libevent-2.0.19-stable.tar.gz
      cd $custhome/libevent-2.0.19-stable
      ./configure --prefix=$HOME/local
      make
      make install
      cd -
      rm $custhome/libevent-2.0.19-stable.tar.gz
      rm -r $custhome/libevent-2.0.19-stable
    ;;

    scripts )
      mkdir -p $HOME/scripts                                                                    # custom scripts
      cp -rsf $custhome/scripts/* $HOME/scripts/
    ;;

    kdb )
      echo "checking for kdb+"
      . $custhome/kdb_install.sh
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
