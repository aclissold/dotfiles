#!/usr/bin/env python3

# Creates symbolic links to all files contained within this repository to the
# correct locations, e.g. when setting up a new machine. This is harmless to
# run if files or symlinks already exist where these ones belong.

import os
import platform
import shutil
import subprocess

HOME = os.environ['HOME']
SYSTEM = platform.system()

dotfiles = ['.gitconfig', '.gitignore', '.tmux.conf', '.pylintrc', '.pythonrc',
    '.vim', '.vimrc', '.zsh', '.zshrc', '.irbrc']

# TODO: handle adding PPAs.
# ['command name', 'install name']
packages = [
        ['cloc', 'cloc'],
        ['colordiff', 'colordiff'],
        ['cowsay', 'cowsay'],
        ['git', 'git'],
        ['convert', 'imagemagick'],
        ['tmux', 'tmux'],
        ['tree', 'tree'],
        ['vim', 'vim'],
        ['zsh', 'zsh']
    ]

if SYSTEM == 'Darwin':
    dotfiles.append('.slate')
else:
    dotfiles.append('.fonts.conf')

def main():
    """Set up or synchronize dotfiles."""
    # Abort if not run from the root of the repository.
    if os.getcwd() != os.path.join(HOME, '.dotfiles'):
        usage = ('Update failed. Please ensure that\n' +
        '\t1) this repository exists at ~/.dotfiles, and\n' +
        '\t2) this command is being executed from within that directory.')

        print(usage)
        exit(1)

    # Merge in the latest changes, if any.
    run(['git', 'pull'])

    # Create symlinks for non-platform-specific dotfiles.
    symlink(dotfiles)

    # Create symlinks for platform-specific dotfiles.
    if SYSTEM == 'Darwin':
        symlink(['.terminfodarwin'], '.terminfo')
    else:
        symlink(['.terminfolinux'], '.terminfo')

    # Install commonly used packages.
    get(packages)

    # Clone and/or update Vim and Zsh plugins.
    run(['git', 'submodule', 'update', '--init'])

    # Ensure these directories exist.
    os.makedirs(os.path.join(HOME, '.vimundo'), exist_ok=True)
    os.makedirs(os.path.join(HOME, '.Trash'), exist_ok=True)

def run(command):
    """Execute a shell command, exiting if an error occurs."""
    if subprocess.call(command) != 0: exit(1)

def symlink(dotfiles, symlink_name=None):
    """Create symlinks for each dotfile in dotfiles that does not exist."""
    for dotfile in dotfiles:
        # Construct paths.
        if symlink_name is None:
            symlink_name = dotfile
        dotfile_path = os.path.join(HOME, '.dotfiles', dotfile)
        symlink_path = os.path.join(HOME, symlink_name)

        # Skip symlinks that have already been made.
        if os.path.islink(symlink_path):
            continue

        # Create the symlink.
        os.symlink(dotfile_path, symlink_path)
        print('New symlink: ~/' + symlink_name)

def get(packages):
    """Install packages using the system's package manager."""
    if SYSTEM == 'Darwin':
        package_manager = ['brew']
    else:
        package_manager = ['sudo', 'apt-get']

    # Skip packages that have already been installed.
    packages_to_install = []
    for package in packages:
        if shutil.which(package[0]) == None:
            packages_to_install.append(package[1])
    if len(packages_to_install) > 0:
        command = package_manager + ['install'] + packages_to_install
        run(command)

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit(1)
