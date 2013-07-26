setopt histignorealldups sharehistory

###############
# Keybindings #
###############

# Vim keybindings in Zsh
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# zsh-history-substring-search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

###########
# History #
###########

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

###########
# Aliases #
###########

# cdls
cd() { builtin cd "$@"; ls --color=auto }
# Python<3
alias py=python3.3
# Colored ls
alias ls='ls --color=auto'
# Colored grep
alias grep='grep --color=auto'
# Quick up-a-level alias
alias sdf='cd ..'
# SSH
alias secs='ssh ajclisso@login.secs.oakland.edu'
# Tomcat start/stop script
alias tomcat='/etc/init.d/uportal'
# My minification script
alias minify='$HOME/ajclisso/Code/Scripts/minify.sh'
# Lockscreen command
alias lock='i3lock -t -i $HOME/Dropbox/Work/Pictures/Backgrounds/Largo.PNG'

# Git
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gco='git checkout '
alias gd='git diff'
alias gh='git hist'
alias gp='git push'
alias gpu='git pull'
alias gs='git status '

# Java 7
alias java7='/opt/jdk1.7.0_25/bin/java'
alias javac7='/opt/jdk1.7.0_25/bin/javac'
alias javadoc7='/opt/jdk1.7.0_25/bin/javadoc'

#########################
# Environment variables #
#########################
export M2_HOME=/home/ajclisso/uportal/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

export JAVA_HOME=/opt/jdk1.6.0_45
export PATH=$JAVA_HOME/bin:$PATH

export ANT_HOME=/home/ajclisso/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

export TOMCAT_HOME=/home/ajclisso/uportal/tomcat
export PATH=$PATH:$TOMCAT_HOME
export JAVA_OPTS='-server -XX:MaxPermSize=512m -Xms1024m -Xmx2048m'

export GROOVY_HOME=/home/ajclisso/uportal/groovy
export PATH=$PATH:$GROOVY_HOME/bin

export PGDATA=/opt/PostgreSQL/9.2/
export PATH=$PATH:$PGDATA/bin

export PYTHONPATH='/usr/bin/python3.2'

export GOROOT=/opt/go/
export PATH=$PATH:$GOROOT/bin
export GOPATH=/home/ajclisso/Code/Go/
export PATH=$PATH:$GOPATH/src

export PATH=$PATH:/usr/local/ch/bin
#
#############
# Functions #
#############

# "Copy" file to ~/.clipboard
function yank {
    touch ~/.clipboard
    for i in "$@"; do
      if [[ $i != /* ]]; then i=$PWD/$i; fi
      i=${i//\\/\\\\}; i=${i//$'\n'/$'\\\n'}
      printf '%s\n' "$i"
    done >> ~/.clipboard
}

# "Paste" file from ~/.clipboard
function put {
    while IFS= read src; do
      cp -Rdp "$src" .
    done < ~/.clipboard
    rm ~/.clipboard
}

# Pretend "copy" was "cut"
function putrm {
    while IFS= read src; do
      mv "$src" .
    done < ~/.clipboard
    rm ~/.clipboard
}

# Strip git clone of boilerplate
function clone {
    if [[ $# != 1 ]]
    then
        echo 'Usage: clone username/repository'
    else
        git clone git@github.com:$1
    fi
}

# Open files in Chrome without generating libpeerconnection.log
function chrome {
    for i in "$@"; do
        google-chrome $i
    done
    rm libpeerconnection.log
}

# Move file or directory to ~/.trash
function del {
    mv "$@" ~/.trash
}

# Yup
function empty-trash {
    rm -rf ~/.trash/*
}


#################
# Miscellaneous #
#################

# Set the prompt!
precmd() { PROMPT='%B%~%b$(git_super_status) %# ' }

# Enable Python interpreter tab-complete
export PYTHONSTARTUP=~/.pythonrc

# Default text editor
export EDITOR=/usr/bin/vim

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
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

# Plugin sourcing (order matters for some)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.dotfiles/zsh-history-substring-search.zsh
source ~/.zsh/git-prompt/zshrc.sh
