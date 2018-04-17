#!/usr/bin/env bash

# archive settings
archive=1                                                               # archive if set to 1
archdir=~/.archive                                                      # archive directory
dotdir=$HOME                                                            # install location for dotfiles

# dotfile locations
rootc=$PWD/$(dirname "${BASH_SOURCE}")                                  # full path dotfiles repo
dfiles=$rootc/dotfiles                                                  # full path to dotfiles sub directory

recurseFiles () {                                                       # return files form all sub directories
  dir=$(echo "$1" | sed 's|\/*$||g')                                    # trim trailing forward slash
  find $dir -type f | sed "s|^$dir\/||g"                                # return file paths of dotfiles
 }

newFiles=($(recurseFiles $dfiles))                                      # store files to install as array


archiveFile() {
  oldFile=$dotdir/$1
  if [ 1 -eq $archive ] && [ -f $oldFile ]; then
    echo "archiving $oldFile"
    mkdir -p $archdir/$(dirname $1)
    cp $oldFile $archdir/$1
  fi
 }

for file in ${newFiles[@]}; do
  archiveFile $file
done
