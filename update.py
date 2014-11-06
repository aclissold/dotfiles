#!/usr/bin/env python3

# Creates symbolic links to all files contained within this repository to the
# correct locations, e.g. when setting up a new machine. This is harmless to
# run if files or symlinks already exist where these ones belong.

import os
import platform
import subprocess

HOME = os.environ['HOME']

dotfiles = ['.gitconfig', '.gitignore', '.tmux.conf', '.pylintrc', '.pythonrc',
    '.vim', '.vimrc', '.zsh', '.zshrc', '.irbrc']

if platform.system() == 'Darwin':
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
    if platform.system() == 'Darwin':
        symlink(['.terminfodarwin'], '.terminfo')
    else:
        symlink(['.terminfolinux'], '.terminfo')

    # Ensure these directories exist.
    os.makedirs(os.path.join(HOME, '.vimundo'), exist_ok=True)
    os.makedirs(os.path.join(HOME, '.Trash'), exist_ok=True)

    # Clone and/or update Vim and Zsh plugins.
    run(['git', 'submodule', 'update', '--init'])

def run(command):
    """Execute a shell command, printing its output."""
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

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        exit(1)

# get () {
#     for package in $@
#     do
#         # Skip packages that have already been installed.
#         if ! hash $package 2>/dev/null
#         then
#             if [[ $(uname) == 'Darwin' ]]
#             then
#                 brew install $package
#             else
#                 sudo apt-get install $package
#             fi
#         fi
#     done
# }
#
# get autojump bash cloc colordiff cowsay git tmux tree vim zsh
