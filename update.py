#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Synchronizes the config files and commands of a development environment."""

import os
import platform
import shutil
import subprocess

HOME = os.environ['HOME']
SYSTEM = platform.system()

DOTFILES = ['.gitconfig', '.gitignore', '.tmux.conf', '.pylintrc', '.pythonrc',
            '.vim', '.vimrc', '.zsh', '.zshrc', '.irbrc']

# ['command name', 'install name']
PACKAGES = [['cloc', 'cloc'],
            ['colordiff', 'colordiff'],
            ['cowsay', 'cowsay'],
            ['git', 'git'],
            ['convert', 'imagemagick'],
            ['tmux', 'tmux'],
            ['tree', 'tree'],
            ['vim', 'vim'],
            ['zsh', 'zsh']]

CASKS = [['Skim', 'skim'],
         ['Google Chrome', 'google-chrome'],
         ['Slate', 'slate'],
         ['Alfred 2', 'alfred'],
         ['Spotify', 'spotify']]

if SYSTEM == 'Darwin':
    DOTFILES.append('.slate.js')
    PACKAGES.append(['cliclick', 'cliclick'])
else:
    DOTFILES.append('.fonts.conf')
    PACKAGES.append(['xclip', 'xclip'])

def main():
    """Set up or synchronize dotfiles."""
    # Abort if not run from the root of the repository.
    if os.getcwd() != os.path.join(HOME, '.dotfiles'):
        usage = ('Update failed. Please ensure that\n' +
                 '\t1) this repository exists at ~/.dotfiles, and\n' +
                 '\t2) this command is being executed from within that' +
                 'directory.')

        print(usage)
        exit(1)

    # Merge in the latest changes, if any.
    run(['git', 'pull'])

    # Create symlinks for non-platform-specific dotfiles.
    symlink(DOTFILES)

    # Create symlinks for platform-specific dotfiles.
    if SYSTEM == 'Darwin':
        symlink(['.terminfodarwin'], '.terminfo')
        symlink(['.vimrc'], '.xvimrc')
    else:
        symlink(['.terminfolinux'], '.terminfo')

    # Install commonly used packages.
    if SYSTEM == 'Darwin':
        get(PACKAGES, ['brew'])
        get(CASKS, ['brew', 'cask'])
    else:
        get(PACKAGES, ['sudo', 'apt-get'])

    # Clone and/or update Vim and Zsh plugins.
    run(['git', 'submodule', 'update', '--init'])

    # Symlink Xcode colortheme (special case)
    if SYSTEM == 'Darwin':
        symlink_path = os.path.join(HOME, 'Library', 'Developer', 'Xcode',
            'UserData', 'FontAndColorThemes')
        os.makedirs(symlink_path, exist_ok=True)
        symlink_path = os.path.join(symlink_path, 'Lunarized.dvtcolortheme')
        if not os.path.islink(symlink_path):
            dotfile_path = os.path.join(HOME, '.dotfiles', '.vim', 'bundle',
                    'lunarized-syntax', 'Lunarized.dvtcolortheme')
            os.symlink(dotfile_path, symlink_path)

    # Ensure these directories exist.
    os.makedirs(os.path.join(HOME, '.vimundo'), exist_ok=True)
    os.makedirs(os.path.join(HOME, '.Trash'), exist_ok=True)

def run(command):
    """Execute a shell command, exiting if an error occurs."""
    if subprocess.call(command) != 0:
        exit(1)

def symlink(dotfiles, symlink_name=None):
    """Create symlinks for each dotfile in dotfiles that does not exist."""
    for dotfile in dotfiles:
        # Construct paths.
        if symlink_name is not None:
            symlink = symlink_name
        else:
            symlink = dotfile
        dotfile_path = os.path.join(HOME, '.dotfiles', dotfile)
        symlink_path = os.path.join(HOME, symlink)

        # Skip symlinks that have already been made.
        if os.path.islink(symlink_path):
            continue

        # Create the symlink.
        os.symlink(dotfile_path, symlink_path)
        print('New symlink: ~/' + symlink)

def get(packages, package_manager):
    """Install packages using the system's package manager."""
    # Skip packages that have already been installed.
    packages_to_install = []
    for package in packages:
        if 'cask' in package_manager and not os.path.islink(os.path.join(
            HOME, 'Applications', package[0] + '.app')):
                packages_to_install.append(package[1])
        else:
            if shutil.which(package[0]) == None:
                packages_to_install.append(package[1])

    if len(packages_to_install) > 0:
        # Install packages.
        command = package_manager + ['install'] + packages_to_install
        run(command)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit(1)
