#!/bin/bash

# Creates symbolic links to all files contained within this repository to the
# correct locations, e.g. when setting up a new box. This is harmless to run if
# files / symlinks already exist where these ones belong--ln -s fails if
# something already exists in a given location under the same name.

if [[ -n $(pwd | grep '/.dotfiles$') ]]
then
    echo 'Making symlinks... '
    ln -s $(pwd)/.gitconfig ~
    ln -s $(pwd)/.gitignore ~
    ln -s $(pwd)/.pylintrc ~
    ln -s $(pwd)/.pythonrc ~
    ln -s $(pwd)/.vim ~
    ln -s $(pwd)/.vimrc ~
    ln -s $(pwd)/.xinitrc ~
    ln -s $(pwd)/.zsh ~
    ln -s $(pwd)/.zshrc ~
    ln -s $(pwd)/.irbrc ~
    ln -s $(pwd)/.gemrc ~
    if [[ $(uname) == 'Darwin' ]]
    then
        ln -s $(pwd)/.slate ~
    fi
    mkdir -p ~/.vimundo
    echo 'Done.'
    echo 'Updating submodules... '
    git submodule update --init
    echo 'Done.'
else
    echo "Command failed. Please ensure that
    1) this repository exists at ~/.dotfiles, and
    2) this command is being executed from within that directory."
fi
