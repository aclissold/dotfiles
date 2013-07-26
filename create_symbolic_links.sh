#!/bin/bash

# This shell script will create symbolic links to all files contained within
# this repository in the correct locations. This is harmless to run if you
# have some but not all links, or still have the real files where they belong--
# ln -s fails if something already exists in that location with that name.

# Ensure the user understands what will happen before running

while true
do
    read -p \
'Are you sure you want to create symbolic links to all files in this repository
in their respective locations [y/N]? ' yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo 'Process aborted.'; exit;;
            * ) echo 'Process aborted.'; exit;;
    esac
done

# Survived switch case; proceed with copying. (Note: rc.lua is intentionally
# excluded. To my future self: it lives at ~/.config/awesome/rc.lua.
echo 'Making links...'
ln -s .gitconfig ~/.gitconfig
ln -s .pythonrc ~/.pythonrc
ln -s .vimrc ~/.vimrc
ln -s .zshrc ~/.zshrc
mkdir -p ~/.vim/colors
ln -s symfony_modified.vim ~/.vim/colors/symfony_modified.vim
echo 'Process complete.'
