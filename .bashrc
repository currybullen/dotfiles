###############################################################################
# Initialization
###############################################################################
. /etc/bashrc

###############################################################################
# Prompt
###############################################################################
. /usr/share/git-core/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=0
FORMATTING_RESET='\e[0m'
function ret_color {
	local RETURN_CODE=$?
	local G='\e[1;38;5;2m'
	local R='\e[1;38;5;1m'
	[[ $RETURN_CODE -eq 0 ]] && echo -e "$G" || echo -e "$R"
}

FORMATTING_RESET='\e[0m'
PS1="(\A) [\u@\h \W\$(__git_ps1 \"|%s\")]\n \[\$(ret_color)\]$\[$FORMATTING_RESET\] "

###############################################################################
# History
###############################################################################
HISTTIMEFORMAT="%d/%m/%y %T "
HISTSIZE=10000
HISTFILESIZE=1000000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:clear:history[ \t]*|.*'
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

###############################################################################
# Aliases / functions
###############################################################################
alias less='less -R'
alias rm='rm -i'
alias ..='cd ..'
alias c='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias e=nvim

###############################################################################
# Key bindings
###############################################################################
stty -ixon # Disable flow control so it doesn't interfere with C-s

# Source fzf key bindings
. /usr/share/fzf/shell/key-bindings.bash

###############################################################################
# Misc
###############################################################################

# Switch term type when SSHing from tmux
ssh() {
	if [[ $TERM = tmux-256color ]]; then
		TERM=xterm-256color command ssh "$@"
	else
		command ssh "$@"
	fi
}
