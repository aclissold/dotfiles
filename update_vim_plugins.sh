#!/bin/bash

cwd=$(pwd)
cd ~/.vim/bundle
for dir in `ls`
do
    cd $dir
    echo Updating $dir...
    git pull
    cd ..
done
