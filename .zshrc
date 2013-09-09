setopt histignorealldups sharehistory

#############################
# Index:                    #
#   * Keybindings           #
#   * History               #
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
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

# zsh-history-substring-search
zmodload zsh/terminfo
if [[ `uname` == 'Darwin' ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
else
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
fi
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
if [[ `uname` == 'Darwin' ]]; then
    cd() { builtin cd "$@"; ls -G }
else
    cd() { builtin cd "$@"; ls --color=auto }
fi

# Colors!
if [[ `uname` == 'Darwin' ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias tree='tree -C'

# Python
alias py=python3.3

# Quick up-a-level alias
alias sdf='cd ..'

# SSH
alias secs='ssh ajclisso@login.secs.oakland.edu'

# Tomcat start/stop/restart (usage: uportal/myportal/picknetid start/stop/restart)
alias uportal='export CATALINA_BASE=/home/ajclisso/uportal/uPortaltomcat; /etc/init.d/tomcat'
alias myportal='export CATALINA_BASE=/home/ajclisso/uportal/myPortaltomcat; /etc/init.d/tomcat'
alias picknetid='export CATALINA_BASE=/home/ajclisso/uportal/picknetidtomcat; /etc/init.d/tomcat'

# tail catalina.out
alias cattail='rainbowize tail -f $CATALINA_BASE/logs/catalina.out'

# My minification script
alias minify='$HOME/Code/Scripts/minify.sh'

# Lockscreen command
alias lock='i3lock -i /home/ajclisso/Dropbox/Work/Pictures/Backgrounds/RedLock.png && xset r rate 200 60'

# Git
alias ga='git add '
alias gb='git branch '
alias gc='git commit'
alias gco='git checkout '
alias gd='git diff'
alias gh='git hist'
alias gm='git merge'
alias gp='git push'
alias gpu='git pull'
alias gs='git status '

# Java 7
alias java7='/opt/jdk1.7.0_25/bin/java'
alias javac7='/opt/jdk1.7.0_25/bin/javac'
alias javadoc7='/opt/jdk1.7.0_25/bin/javadoc'

#############
# Functions #
#############

# Quickly go to a directory
#
# Layout of command:
#     cd `find -maxdepth 5 ...
#
#     (excluded directories and files)
#
#     ... -type d -name $1 | head -1`
goto() {
    builtin cd `find ~ -maxdepth 5       \
                                         \
    ! -path '*/.*/*'                     \
    ! -path '*/uPortal/*'                \
    ! -path '*/tomcat/webapps/*'         \
    ! -path '*/uportal/overlay/admin/*'  \
    ! -name '.*'                         \
                                         \
    -type d -name $1 | head -1`
}

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
      cp -Rp "$src" .
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

# Logical equivalent to the built-in "unzip" command
function untar {
    tar -xvf $@
}

# Strip git clone of boilerplate
function clone {
    if [[ `hostname` == 'ajclisso-Latitude-D630' ]]; then
        git clone git@github.com:$@
    else
        git clone https://github.com/$@
    fi
}

# Usage: build [(portlet)|uportal]
function build {
    cwd=$(pwd)
    builtin cd ~/uportal/myPortal
    for arg in "$@"
    do
        if [[ $arg == "uportal" ]]; then
            tomcat stop
            groovy -Dbuild.portlets.skip=true build.groovy &&
            tomcat start
        elif [[ $arg == "portlets" ]]; then
            groovy -Dbuild.portal.skip=true build.groovy
        else
            groovy -Dbuild.target.portlet=$arg build.groovy
        fi
    done
    builtin cd $cwd
}

# Open files in Chrome without generating libpeerconnection.log
function chrome {
    for i in "$@"; do
        google-chrome $(pwd)/$i > /dev/null
    done
}

# Move file or directory to ~/.trash
function del {
    mv "$@" ~/.trash
}

# Yup
function emptytrash {
    rm -rf ~/.trash/*
}

# Grep through specific file extensions
function greptype {
    if [[ $# != 2 ]] then;
        # filetype should be "java", not ".java" or "*.java"
        echo 'Usage: greptype <filetype> <pattern>'
    else
        find . -type f -name "*.$1" -exec grep --color=auto "$2" {} + 2>/dev/null
    fi
}

#########################
# Environment Variables #
#########################
if [[ `uname` == 'Darwin' ]]; then
    export M2_HOME=/usr/share/maven
else
    export M2_HOME=/home/ajclisso/uportal/maven
fi
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

if [[ `uname` != 'Darwin' ]]; then
    export JAVA_HOME=/usr/lib/jvm/default-java
    export PATH=$JAVA_HOME/bin:$PATH
fi

export ANT_HOME=/home/ajclisso/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

export CATALINA_HOME=/home/ajclisso/uportal/tomcat
export PATH=$PATH:$CATALINA_HOME

export GROOVY_HOME=/home/ajclisso/uportal/groovy
export PATH=$PATH:$GROOVY_HOME/bin

export PGDATA=/opt/PostgreSQL/9.2/
export PATH=$PATH:$PGDATA/bin

export JAVA_OPTS='-server -XX:MaxPermSize=512m -Xms1024m -Xmx2048m'

export GOROOT=/usr/local/go/
export GOPATH=$HOME/Code/Go/
export MYGO=$HOME/Code/Go/src/github.com/ajclisso/
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH=$PATH:/usr/local/ch/bin

export PATH=$PATH:/opt/eclipse

################
# Miscellaneous #
#################

# Set the prompt!
precmd() { PROMPT='%B%~%b$(git_super_status) ' }

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

# Plugin sourcing (order matters for some)
if [[ `uname` != 'Darwin' ]]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
source ~/.dotfiles/zsh-history-substring-search.zsh
source ~/.zsh/git-prompt/zshrc.sh

# Safe cp
alias cp='cp -i'
