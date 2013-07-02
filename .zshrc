# Set up the prompt

#autoload -Uz promptinit 
#promptinit
#prompt adam1

setopt histignorealldups sharehistory

# Use Vim keybindings
bindkey -v

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Aliases
alias ls='ls --color=auto'

alias py=python3.2

alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout'
alias gp='git push'
alias gpu='git pull'
alias gk='gitk --all&'
alias gx='gitx --all'
alias gh='git hist'

alias lock='i3lock -t -i /home/ajclisso/Dropbox/Work/Pictures/Backgrounds/Largo.PNG'

alias grep='grep --color=auto'
cdls() { cd "$@" && ls; }
alias cd='cdls'

alias splay='spotify_control.py -c pp'
alias spause='spotify_control.py -c pp'
alias snext='spotify_control.py -c next'
alias sprevious='spotify_control.py -c previous'
alias sstop='spotify_control.py -c stop'

alias javadoc7='/opt/jdk1.7.0_21/bin/javadoc'

alias portlet='cd ~/Code/portlet_degreeprogress/src/main/java/org/jasig/portlet'

alias secs='ssh ajclisso@login.secs.oakland.edu'
alias tomcat='/etc/init.d/uportal'
alias uportal='cd /home/ajclisso/uportal/uPortal'
alias builduportal='/home/ajclisso/Code/Scripts/builduportal.sh'
alias buildportlets='/home/ajclisso/Code/Scripts/buildportlets.sh'
alias redo='/home/ajclisso/Code/Scripts/redo.sh'

# Key bindings for zsh-history-substring-search
for keycode in '[' 'O'; do
  bindkey "^[${keycode}A" history-substring-search-up
  bindkey "^[${keycode}B" history-substring-search-down
done
unset keycode

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Environment variables
export M2_HOME=/home/ajclisso/uportal/maven
export M2=$M2_HOME/bin
export PATH=$M2:$PATH

export JAVA_HOME=/opt/jdk1.6.0_45
export PATH=$JAVA_HOME/bin:$PATH

export ANT_HOME=/home/ajclisso/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

export TOMCAT_HOME=/home/ajclisso/uportal/tomcat
export PATH=$PATH:$TOMCAT_HOME
export JAVA_OPTS="-server -XX:MaxPermSize=512m -Xms1024m -Xmx2048m"

export GROOVY_HOME=/home/ajclisso/uportal/groovy
export PATH=$PATH:$GROOVY_HOME/bin

export PGDATA=/opt/PostgreSQL/9.2/
export PATH=$PATH:$PGDATA/bin

export PYTHONPATH='/usr/bin/python3.2'

export GOROOT=/opt/go/
export PATH=$PATH:$GOROOT/bin
export GOPATH=/home/ajclisso/Code/Go/
export PATH=$PATH:$GOPATH/src

export PATH=$PATH:/home/ajclisso/Code/Scripts/PySpotifyInfo

# Prompt format
function spotify() {
    echo `python ~/Code/Scripts/PySpotifyInfo/spotify_control.py -d title artist -m " ~ "`
}
precmd() {
    PROMPT='%B%~%b$(git_super_status) %# '
    if [[ $(spotify) != "SPOTIFY"  ]]
    then
        RPROMPT="$(spotify)"
    else
        RPROMPT=""
    fi
}

# Default text editor
export EDITOR=/usr/bin/vim

# Enable Vim-bindings
bindkey -v

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
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/git-prompt/zshrc.sh
