#!/bin/bash

while true
do
    read -p 'Are you sure you want to "cp" all files to their respective locations (y/N)? ' yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo 'Process aborted.'; exit;;
            * ) echo 'Process aborted.'; exit;;
    esac
done

# Survived switch case; proceed with copying

echo 'Copying files.'
