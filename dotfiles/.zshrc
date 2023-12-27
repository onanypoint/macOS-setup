#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#   #############################
#   CUSTOM CONFIG
#   #############################

#   -----------------------------
#   1.  MAKE TERMINAL BETTER
#   -----------------------------

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ~="cd ~"                                  # ~:    Go Home
alias c='clear'                                 # c:    Clear terminal display

#   -------------------------------
#   2.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

# Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#   ---------------------------
#   3.  SEARCHING
#   ---------------------------

alias qfind="find . -name "                     # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }          # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }      # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }      # ffe:      Find file whose name ends with a given string

#   ---------------------------------------
#  	4.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

#   4.0 EXTRA COMMANDS
#   ---------------------------------------

alias ts='tmux start-server; echo starting tmux server'
alias docker-rmi-all='docker rmi $(docker ps -q)'

#  	4.1 SPECIFICS
#  	---------------------------------------

if [ "$(uname)"=="Darwin" ]; then
    alias text='open -a TextEdit'
    alias preview='open -a Preview'

    # Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store|*:2eDS_Store' -ls -delete"

    # Show / Hide hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
    alias doty=finderShowHidden
    alias dotn=finderHideHidden

    alias spoofmac='sudo ifconfig en0 ether $(openssl rand -hex 6 | sed "s%\(..\)%\1:%g; s%.$%%")'

    alias nvramsetup="bash ~/.config.git/macos.nvram"

elif [ "$(expr substr $(uname -s) 1 5)"=="Linux" ]; then
    # Do something under GNU/Linux platform
fi


#   ---------------------------------------
#   5.  Config
#   ---------------------------------------

#   5.0 McFly
#   ---------------------------------------

export MCFLY_RESULTS_SORT=LAST_RUN
export MCFLY_DISABLE_MENU=TRUE
export MCFLY_INTERFACE_VIEW=TOP
eval "$(mcfly init zsh)"

#   5.1 Poetry
#   ---------------------------------------

export PATH="$HOME/.local/bin:$PATH"

#   5.2 Auto Env
#   https://github.com/hyperupcall/autoenv
#   ---------------------------------------

export AUTOENV_ENV_FILENAME=.autoenv
source $(brew --prefix autoenv)/activate.sh

#   5.3 Conda
#   ---------------------------------------

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

#   5.3 Java
#   ---------------------------------------

export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
