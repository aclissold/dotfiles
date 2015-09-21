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

# ['command name', 'install name', 'linux command name']
PACKAGES = [['clang', 'clang'],
            ['cloc', 'cloc'],
            ['colordiff', 'colordiff'],
            ['cowsay', 'cowsay'],
            ['curl', 'curl'],
            ['gist', 'gist', 'gist-paste'],
            ['git', 'git'],
            ['convert', 'imagemagick'],
            ['indent', 'indent'],
            ['make', 'make'],
            ['ssh-copy-id', 'ssh-copy-id'],
            ['tmux', 'tmux'],
            ['tree', 'tree'],
            ['vim', 'vim'],
            ['zsh', 'zsh']]

CASKS = [['Skim', 'skim'],
         ['Firefox', 'firefox'],
         ['Slate', 'slate'],
         ['Alfred 2', 'alfred'],
         ['Spotify', 'spotify']]

if SYSTEM == 'Darwin':
    DOTFILES.append('.slate.js')
    PACKAGES.append(['cliclick', 'cliclick'])
    PACKAGES.append(['reattach-to-user-namespace',
                     'reattach-to-user-namespace'])
else:
    DOTFILES.append('.fonts.conf')
    PACKAGES.append(['xclip', 'xclip'])
    PACKAGES.append(['valgrind', 'valgrind'])

def main():
    """Set up or synchronize dotfiles."""
    validate_cwd()
    run(['git', 'pull'])
    run(['git', 'submodule', 'update', '--init'])
    create_symlinks()
    get_packages()
    make_directories()
    set_login_shell()

# MARK: Main Functions

def validate_cwd():
    """Abort if not run from the root of the repository."""
    if os.getcwd() != os.path.join(HOME, '.dotfiles'):
        usage = ('Update failed. Please ensure that\n' +
                 '\t1) this repository exists at ~/.dotfiles, and\n' +
                 '\t2) this command is being executed from within that' +
                 'directory.')
        print(usage)
        exit(1)

def create_symlinks():
    """Create symlinks to all dotfiles that don't yet have symlinks."""
    symlink(DOTFILES)

    if SYSTEM == 'Darwin':
        symlink(['.terminfodarwin'], '.terminfo')
        symlink(['.vimrc'], '.xvimrc')
    else:
        symlink(['.terminfolinux'], '.terminfo')

    symlink_xcode_colortheme()

def symlink_xcode_colortheme():
    """Symlink Xcode colortheme (special case)."""
    if SYSTEM == 'Darwin':
        symlink_path = os.path.join(HOME, 'Library', 'Developer', 'Xcode',
                                    'UserData', 'FontAndColorThemes')
        os.makedirs(symlink_path, exist_ok=True)
        symlink_path = os.path.join(symlink_path, 'Lunarized.dvtcolortheme')
        if not os.path.exists(symlink_path):
            dotfile_path = os.path.join(HOME, '.dotfiles', '.vim', 'bundle',
                                        'lunarized-syntax',
                                        'Lunarized.dvtcolortheme')
            os.symlink(dotfile_path, symlink_path)

def get_packages():
    """Install commonly used packages."""
    if SYSTEM == 'Darwin':
        get(PACKAGES, ['brew'])
        get(CASKS, ['brew', 'cask'])
    else:
        get(PACKAGES, ['sudo', 'apt-get'])

def set_login_shell():
    """Change login shell to zsh if necessary."""
    if 'bash' in os.environ['SHELL']:
        print('Changing the login shell to zsh…')
        run(['chsh', '-s', '/bin/zsh'])

def make_directories():
    """Ensure certain directories exist."""
    os.makedirs(os.path.join(HOME, '.vimundo'), exist_ok=True)
    os.makedirs(os.path.join(HOME, '.Trash'), exist_ok=True)

# MARK: Helper Functions

def run(command):
    """Execute a shell command, exiting if an error occurs."""
    if subprocess.call(command) != 0:
        exit(1)

def symlink(dotfiles, symlink_name=None):
    """Create symlinks for each dotfile in dotfiles that does not exist."""
    for dotfile in dotfiles:
        # Construct paths.
        if symlink_name is not None:
            link = symlink_name
        else:
            link = dotfile
        dotfile_path = os.path.join(HOME, '.dotfiles', dotfile)
        symlink_path = os.path.join(HOME, link)

        # Skip symlinks that have already been made.
        if os.path.islink(symlink_path):
            continue

        # Create the symlink.
        os.symlink(dotfile_path, symlink_path)
        print('New symlink: ~/' + link)

def get(packages, package_manager):
    """Install packages using the system's package manager."""
    # Skip packages that have already been installed.
    packages_to_install = []
    for package in packages:
        install_name = package[1]
        if len(package) == 3:
            name = package[len(package)-1]
        else:
            name = package[0]

        path = os.path.join(HOME, 'Applications', name + '.app')
        if 'cask' in package_manager and not os.path.islink(path):
            packages_to_install.append(install_name)
        elif shutil.which(name) == None:
            packages_to_install.append(install_name)
        else:
            pass # already installed

    if len(packages_to_install) > 0:
        # Install packages.
        command = package_manager + ['install'] + packages_to_install
        run(command)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit(1)
