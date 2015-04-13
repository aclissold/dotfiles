setopt histignorealldups sharehistory

HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.zsh_history

#############################
# Index:                    #
#   * Keybindings           #
#   * Aliases               #
#   * Functions             #
#   * Environment Variables #
#   * Miscellaneous         #
#############################

###############
# Keybindings #
###############

# Vim keybindings in Zsh
bindkey -v

# cd .. easily
bindkey -s "\C-u" "cd ..\n"

# zsh-history-substring-search
zmodload zsh/terminfo
if [[ `uname` == 'Darwin' ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
else
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi

###########
# Aliases #
###########

# auto ls after cd
if [[ `uname` == 'Darwin' ]]; then
    cd() { builtin cd "$@" && ls -G }
    pushd() { builtin pushd "$@" && ls -G }
    popd() { builtin popd "$@" && ls -G }
else
    cd() { builtin cd "$@" && ls --color=auto }
    pushd() { builtin pushd "$@" && ls --color=auto }
    popd() { builtin popd "$@" && ls --color=auto }
fi

# Colors!
if [[ `uname` == 'Darwin' ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias tree='tree -C'

# Make OS X a little more GNU-ish
if [[ `uname` == 'Darwin' ]]; then
    alias tailf='tail -f'
    alias updatedb='sudo /usr/libexec/locate.updatedb'
fi

# Staying up-to-date
alias sag='sudo apt-get'
if [[ `uname` == 'Darwin' ]]; then
    alias uu='brew update && brew upgrade'
else
    alias uu='sudo apt-get update && sudo apt-get upgrade'
fi
alias dot='builtin cd ~/.dotfiles; ./update.py; builtin cd -'
alias uud='uu && dot'
alias sz='source ~/.zshrc'

# Muscle-memory
alias v='vim'
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gci='git commit -m "Initial commit"'
alias gco='git checkout'
alias gca='git commit --amend'
alias gcac='git commit --amend -C @'
alias gcar='git commit --amend --reset-author -C @'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gcpa='git cherry-pick --abort'
alias gd='git diff'
alias gdcw='git diff --color-words'
alias gdc='git diff --cached'
alias gdccw='git diff --cached --color-words'
alias gf='git fetch'
alias gg='git grep'
alias gh='git log --pretty=format:"%C(auto)%h %ad | %s%d %C(red)[%an]" --graph --date=short'
alias gi='git init'
alias gl='git log'
alias glo='git log --oneline'
alias gm='git merge'
alias gma='git merge --abort'
alias gmv='git mv'
alias gp='git push'
alias gpu='git pull'
alias gr='git reset'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbs='git rebase --skip'
alias grm='git rm'
alias grv='git revert'
alias gs='git status'
alias gsa='git stash'
alias gsh='git show'
alias gt='git tag'
alias gv='git version'

# Fix tmux colorscheme issues
alias tmux="TERM=screen-256color-bce tmux"

if [[ `uname` == 'Darwin' ]]; then
    alias night='diskutil eject External'
    alias morn='diskutil mountDisk External'
fi

#############
# Functions #
#############

# Make and cd into a dir
function mkcd() { mkdir -p $(pwd)/$@ && cd $(pwd)/$@ }

# Copy file contents to clipboard
function y {
    if [[ `uname` == 'Darwin' ]]; then
        cat "$@" | pbcopy
    else
        cat "$@" | xclip -sel clip
    fi
}

# Paste file contents from clipboard
if [[ `uname` == 'Darwin' ]]; then
    alias p='pbpaste'
else
    alias p='xclip -o'
fi

# Minimalist git clone
function clone {
    if [[ $@ == */* ]]; then
        repo=$@
        # truncate username / repo to username/repo
        repo=${repo/\ \/\ /\/}
        git clone git@github.com:${repo}
    else
        # No "/" found--assume it's my own repo
        git clone git@github.com:aclissold/$@
    fi
}

# Copy sha1sum to clipboard
function sha {
    if [[ `uname` == 'Darwin' ]]; then
        shasum $1 | awk '{print($1)}' | tr -d '\n' | pbcopy
    else
        sha1sum $1 | awk '{print($1)}' | tr -d '\n' | xclip -sel clip
    fi
}

# Human-readable disk usage of large files
function dug {
    du -h "$@" | grep "G\t"
}

# Find IP
function myip {
    dig +short myip.opendns.com @resolver1.opendns.com
}

# Trash commands
function d {
    mv -i "$@" ~/.Trash/
}
function emptytrash {
    rm -rf ~/.Trash/*
}

#########################
# Environment Variables #
#########################
if [[ `uname` == 'Darwin' ]]; then
    export M2_HOME=/usr/local/mvn
    export M2=$M2_HOME/bin
    export PATH=$M2:$PATH
    export XML_CATALOG_FILES=/usr/local/etc/xml/catalog # for asciidoc
    export FRAMEWORKS=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks
fi

export GOROOT=/usr/local/go
export GOPATH=$HOME/Code/Go
export MYGO=$HOME/Code/Go/src/github.com/aclissold
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$HOME/Code/Go/go_appengine:$PATH

export ANDROID_HOME=/usr/local/android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

export PATH=$PATH:$HOME/Code/Scripts

export PATH=$PATH:$HOME/.rvm/bin

################
# Miscellaneous #
#################

# Set the prompt!
autoload colors && colors
precmd() { PROMPT="%B%~%b$(git_super_status) " }
RPROMPT="%{$fg_no_bold[black]%}%t%{$reset_color%}"

# Enable Python interpreter tab-completion
export PYTHONSTARTUP=~/.pythonrc

# Default text editor
export EDITOR=/usr/bin/vim

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Famed Zsh autocompletion
autoload -Uz compinit
compinit -u

source ~/.zsh/zsh-history-substring-search.zsh
source ~/.zsh/git-prompt/zshrc.sh
source /usr/local/share/zsh/site-functions/_gibo &> /dev/null
source ~/.dotfiles/.zsh/go.zsh/go.zsh
