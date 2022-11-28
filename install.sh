#!/usr/bin/env bash

############
# settings #
############

# archive settings
archive=0                                                               # archive if set to 1
archdir=$HOME/.archive                                                  # archive directory
dotdir=$HOME                                                            # install location for dotfiles

# other
arglist=""                                                              # ensure arguments are cleared in case of failure
hardcopy=0                                                              # hard copy if set to 1
gitdir=$HOME/git                                                        # location of cloned repos
localdir=$HOME/local                                                    # binaries
scriptsdir=$HOME/scripts                                                # local scripts
vimsyntax="yaq-vim"
sshconf=$HOME/.ssh/config


# dotfile locations
rootc=$PWD/$(dirname "${BASH_SOURCE}")                                  # full path dotfiles repo
dfiles=$rootc/dotfiles                                                  # full path to dotfiles sub directory
templates=$rootc/templates                                              # dotfile templates

#############
# functions #
#############

copyFiles () {
  echo copying files $1 to $2
  if [ 1 -eq $hardcopy ]; then                                          # hardcopy files if enabled
    cp -rf $1 $2
  else
    cp -rsf $1 $2
  fi
 }

recurseFiles () {                                                       # return files form all sub directories
  dir=$(echo "$1" | sed 's|\/*$||g')                                    # trim trailing forward slash
  find $dir -type f | sed "s|^$dir\/||g"                                # return file paths of dotfiles
 }

fillTemplate () {
  rm $2
  while read line; do
    eval echo "$line" >> $2
  done < $1
 }

archiveFile() {                                                         # archive file if it exists
  oldFile=$dotdir/$1
  if [ -f $oldFile ]; then
    echo "archiving $oldFile"
    mkdir -p $archdir/$(dirname $1)
    cp $oldFile $archdir/$1
  fi
 }

archiveAllFiles() {                                                     # archive all dotfiles
  newFiles=($(recurseFiles $dfiles))                                    # store files to install as array

  for file in ${newFiles[@]}; do                                        # iterate over dotfiles
    archiveFile $file                                                   # archive dotfile to $archdir
  done
 }

########################
# command line parsing #
########################

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -a|--archive)                                                         # if passed enable archiving
      archive=1
      echo archiving enabled
      shift                                                               # past argument
      ;;
    -h|--hard-copy)
      hardcopy=1
      echo hard-copying enabled
      shift
      ;;
    -g|--git-directory)
      gitdir="$2"
      echo cloning location set to $gitdir
      shift
      shift
      ;;
    -r|--repo-full)
      repofull=1
      echo repo flag passed, all repos will be cloned
      shift
      ;;
    *)                                                                    # unknown option
      POSITIONAL+=("$1")                                                  # save it in an array for later
      shift                                                               # past argument
      ;;
  esac
done

################
# installation #
################

if [ 0 -eq ${#POSITIONAL[@]} ]; then
  echo no arguments passed, exiting...
  return 0
fi

for arg in ${POSITIONAL[@]}; do
  if [ "all" = $arg ]; then
    arg="repos dotfiles bashrc vim vundle scripts tmux"
  fi

  arglist="$arglist $arg"
done

for arg in $arglist; do

  case $arg in

    repos)
      echo "cloning repos"                                              # clone necessary repos
      while IFS="," read -r repo opt; do
        gf=$(basename $repo)                                            # return *.git file
        gn=$gitdir/${gf%$".git"}                                        # drop .git to return directory name
        if [[ "$opt" == "default" ]] || [[ 1 -eq $repofull ]]; then     # clone repo if it is defined as default, or all repo flag passed
          if [ ! -d $gn ]; then                                         # check if repo has been cloned
            echo "cloning $gf"
            mkdir -p $gn                                                # create directory to store repo
            git clone --recurse-submodules $repo $gn                    # clone repo
          else
            echo "$gf already exists, skipping..."
          fi
        else
          echo "default repos only, skipping $gf..."
        fi
      done < $rootc/repos.csv                                           # file contains list of repos to clone
      ;;

    dotfiles)
      if [ 1 -ne $archive ]; then                                       # archive dotfiles if enabled
        echo "archiving not enabled"
      else
        echo "archiving enabled"
        archiveAllFiles
      fi

      echo "adding dotfiles"                                            # add dotfiles
      copyFiles $dfiles/. $dotdir                                       # copy dotfiles to homedir
      ;;

    bashrc)
      if [ ! "source $dotdir/.bash_custom" = "$(tail -n 1 ~/.bashrc)" ]; then
        echo "adding to bashrc"                                         # add settings
        echo "source $dotdir/.bash_custom" >> ~/.bashrc                 # ensure custom settings are picked up by bashrc
      fi
      if [ ! -f $dotdir/.git-prompt.sh ]; then                          # check for existence of git-prompt.sh
        echo "fetching git-prompt.sh"                                   # get git prompt script
        wget -O $dotdir/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
      fi

      ;;

    git)
      echo "input git name"                                             # set git name
      read gitname
      echo "setting name to $gitname"
      git config --global user.name "$gitname"

      echo "input git email"                                            # set git email
      read gitemail
      echo "setting email to $gitemail"
      git config --global user.email "$gitemail"
      ;;

    vim)
      echo "adding kdb syntax highlighting from $vimsyntax"             # vim kdb syntax highlighting
      if [ -d $HOME/git/$vimsyntax ]; then
        cp -rsf $HOME/git/${vimsyntax}/filetype.vim $HOME/.vim
        cp -rsf $HOME/git/${vimsyntax}/syntax $HOME/.vim
        cp -rsf $HOME/git/${vimsyntax}/indent $HOME/.vim
      else
        echo "$vimsyntax not cloned"
      fi
      ;;

    vundle)
      echo "cloning Vundle"
      if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
        vim +PluginInstall +qall                                        # ensure plugins are installed
        echo "Vundle cloned"
      else
        echo "Vundle already installed"
      fi
      ;;

    scripts)
      echo "copying scripts"
      mkdir -p $scriptsdir                                              # custom scripts
      copyFiles $rootc/scripts/* $scriptsdir
      ;;

    kdb)
      source $rootc/kdb_install.sh
      ;;

    tldr)
      if [ ! -f $localdir/bin/tldr ]; then                              # check if tld has been installed
        echo adding tldr                                                # install tldr
        mkdir -p $localdir/bin
        curl -o $localdir/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
        chmod +x $localdir/bin/tldr
      fi
      ;;

    tmux_install)
      if [ -z `which tmux` ]; then
        echo installing tmux
        cd $gitdir/tmux
        ./configure --prefix $localdir
        make
        make install
        cd -
      fi
      ;;

    ssh_config)
      if [ -f $sshconf ]; then                                          # create ssh config if it does not already exist
        echo "$sshconf exists"
      else
        echo "creating $sshconf"
        fillTemplate $templates/sshconfig.txt $sshconf
      fi
      ;;

    *)
      echo "Invalid option: $arg"
      ;;

  esac

done

##############
# post steps #
##############

arglist=""

echo "sourcing $HOME/.bashrc"                                           # wrapping up
source $HOME/.bashrc

echo "setup complete"
