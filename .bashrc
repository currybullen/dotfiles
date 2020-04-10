# TODO:
# * Set up git aliases
# * Set git pager settings, change aliases accordingly
# * Remove terminal color codes when bat 0.12.0 drops

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Completion
shopt -s no_empty_cmd_completion
. /etc/bash_completion.d/fzf

# Globbing
shopt -s extglob
shopt -s globstar

# Prompt
. /usr/share/git-core/contrib/completion/git-prompt.sh
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

PS1="\[$GY\](\[$Y\]\A\[$GY\]) [\[$G\]\u@\h \[$CY\]\W\$(__git_ps1 \"\[$GY\]|\[$Y\]%s\")\[$GY\]]\n \[\$(ret_color)\]$\[$RE\] "

# History
HISTTIMEFORMAT="%d/%m/%y %T "
HISTFILE=~/.bash_history.$HOSTNAME
HISTSIZE=10000
HISTFILESIZE=1000000
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
if [[ ! -f /usr/bin/vim ]]; then
	alias vim=vimx
fi
alias ll='ls -ahl'
alias less='less -R'
alias view='vim -R'
alias vimdiff="vim -d"
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# Maybe remove these in favor of Ctrl-T/~~<TAB>?
fzfb() { fzf --preview "bat --color=always {} | head -500" ; }
fzfv() { vim $(fzfb) < /dev/tty ; }
fzfr() { vim $(rg --files-with-matches "$@" | fzfb) < /dev/tty ; }
vrg() { vim -c "Rg $@"; }
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
. ~/.git_aliases

irg() {
        local match path line
        match=$(rg --color always --line-number "$@" \
                | fzf --ansi --no-multi --delimiter=: --preview 'bat --color always {1} \
                | head -500') && \
        path=$(echo $match | awk --field-separator : '{print $1}') && \
        line=$(echo $match | awk --field-separator : '{print $2}') && \
        idea.sh --line $line "$path"
	#TODO: Add something to focus IntelliJ
}

# Key bindings
. /usr/share/fzf/shell/key-bindings.bash

# Use fd for path completion, include hidden
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd for dir completion, include hidden
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Switch term type when SSHing from tmux
ssh() {
	if [ "$TERM" = tmux-256color ]; then
		TERM=xterm-256color command ssh "$@"
	else
		command ssh "$@"
	fi
}

if [ -f ~/.bashrc.$HOSTNAME ]; then
	. ~/.bashrc.$HOSTNAME
fi
