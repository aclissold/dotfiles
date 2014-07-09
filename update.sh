#!/bin/bash

# Creates symbolic links to all files contained within this repository to the
# correct locations, e.g. when setting up a new box. This is harmless to run if
# files / symlinks already exist where these ones belong--ln -s fails if
# something already exists in a given location under the same name.

git pull

symlink () {
    for file in $@
    do
        # Skip symlinks that have already been made
        if [[ ! -h $HOME/$file ]]
        then
            echo 'New symlink: ~/'"$file"
            ln -s $(pwd)/$file $HOME
        fi
    done
}

if [[ -n $(pwd | grep "^$HOME/.dotfiles$") ]]
then
    symlink .gitconfig .gitignore .tmux.conf .pylintrc .pythonrc .vim \
        .vimrc .zsh .zshrc .irbrc .gemrc .terminfo

    if [[ $(uname) == 'Darwin' ]]
    then
        symlink .slate
    else
        symlink .fonts.conf
    fi

    mkdir -p ~/.vimundo
    mkdir -p ~/.Trash

    git submodule update --init
else
    echo "Command failed. Please ensure that
    1) this repository exists at ~/.dotfiles, and
    2) this command is being executed from within that directory."
fi
