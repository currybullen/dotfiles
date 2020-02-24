# TODO:
# * Set up git aliases
# * Set git pager settings, change aliases accordingly
# * Remove terminal color codes when bat 0.12.0 drops

. /home/$USER/.bashrc.$HOSTNAME

# Completion
shopt -s no_empty_cmd_completion
if [ -f /etc/fedora-release ]; then
	. /etc/bash_completion.d/fzf
elif [ -f /etc/debian_version]; then
	. /usr/share/bash-completion/completions/fzf
fi

# Globbing
shopt -s extglob
shopt -s globstar

# Prompt
if [ -f /etc/fedora-release ]; then
	. /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f /etc/debian_version]; then
	. /usr/lib/git-core/git-sh-prompt
fi
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=0
B='\e[1;38;5;4m'
CY='\e[1;38;5;6m'
G='\e[1;38;5;2m'
R='\e[1;38;5;1m'
Y='\e[1;38;5;3m'
GY='\e[1;38;5;7m'
RE='\e[0m'
function ret_color { 
    [ $? = 0 ] && echo -e "$G" || echo -e "$R"
}
PS1="\[$GY\][\[$G\]\u@\h \[$CY\]\W\$(__git_ps1 \"\[$GY\]|\[$Y\]%s\")\[$GY\]] \[\$(ret_color)\]$\[$RE\] "

# History
HISTFILE=/home/$USER/.bash_history.$HOSTNAME
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:clear'
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

# Better cd navigation
shopt -s autocd
shopt -s cdspell

# Colors
man() {
    LESS_TERMCAP_md=$'\e[01;38;5;4m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;38;5;3m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;38;5;2m' \
    command man "$@"
}
alias ls='ls --color'

# Aliases
alias ll='ls -ahl'
alias less='less -R'
alias view='vim -R'
alias vimdiff="vim -d"
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
fzfb() { fzf --preview "bat --color=always {} | head -500" ; }
fzfv() { vim $(fzfb) < /dev/tty ; }
fzfr() { vim $(rg --files-with-matches "$@" | fzfb) < /dev/tty ; }
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias gd='git diff --color=always'
alias gl='git log'
alias gs='git status'
alias gb='git branch'
gr() { cd $(git rev-parse --show-toplevel); }

# Key bindings
if [ -f /etc/fedora-release ]; then
	. /usr/share/fzf/shell/key-bindings.bash
elif [ -f /etc/debian_version]; then
	. /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Misc fzf settings
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
_fzf_setup_completion path bat
