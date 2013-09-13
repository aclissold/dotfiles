#!/bin/bash

# This shell script will create symbolic links to all files contained within
# this repository to the correct locations. This is harmless to run if you
# have some but not all links, or still have the real files where they belong--
# ln -s fails if something already exists in that location with that name.

#    # Ensure the user understands what will happen before running
#
#    function clean {
#        echo Hello
#    }
#
#    while true
#    do
#        read -p \
#    'Are you sure you want to delete any existing files? This process cannot be undone. [y/N]: ' yn
#        case $yn in
#            [Yy]* ) clean && break;;
#            [Nn]* ) echo 'Process aborted.'; exit;;
#                * ) echo 'Process aborted.'; exit;;
#        esac
#    done
#
#    # Survived switch case; proceed with copying. (Note: rc.lua is intentionally
#    # excluded. To my future self: it lives at ~/.config/awesome/rc.lua.

echo 'Making links... '
ln -s $(pwd)/.gitconfig ~
ln -s $(pwd)/.gitignore_global ~
ln -s $(pwd)/.pythonrc ~
ln -s $(pwd)/.vimrc ~
ln -s $(pwd)/.xinitrc ~
ln -s $(pwd)/.zshrc ~
mkdir -p ~/.vim/colors
ln -s $(pwd)/symfony_modified.vim ~/.vim/colors/symfony_modified.vim
mkdir -p ~/.vimundo
echo 'Done.'
