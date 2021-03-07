if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Completion
shopt -s no_empty_cmd_completion
if [[ -f /etc/bash_completion.d/fzf ]]; then
	. /etc/bash_completion.d/fzf
elif [[ -f /usr/share/fzf/completion.bash ]]; then
	. /usr/share/fzf/completion.bash
fi

# Globbing
shopt -s extglob
shopt -s globstar

# Prompt
if [[ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]]; then
	. /usr/share/git-core/contrib/completion/git-prompt.sh
elif [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
	. /usr/share/git/completion/git-prompt.sh
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

PS1="\[$GY\](\[$Y\]\A\[$GY\]) [\[$G\]\u@\h \[$CY\]\W\$(__git_ps1 \"\[$GY\]|\[$Y\]%s\")\[$GY\]]\n \[\$(ret_color)\]$\[$RE\] "

# History
HISTTIMEFORMAT="%d/%m/%y %T "
HISTFILE=~/.bash_history.$HOSTNAME
HISTSIZE=10000
HISTFILESIZE=1000000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:clear:history[ \t]*|.*'
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

# Better cd navigation
shopt -s autocd
shopt -s cdspell

# Colors
alias ls='ls --color'

# Aliases
if [[ -f /usr/bin/vimx ]]; then
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
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
. ~/.git_aliases

# Key bindings
if [[ -f /usr/share/fzf/shell/key-bindings.bash ]]; then
	. /usr/share/fzf/shell/key-bindings.bash
elif [[ -f /usr/share/fzf/key-bindings.bash ]]; then
	. /usr/share/fzf/key-bindings.bash
fi

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
