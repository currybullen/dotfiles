# Source system-wide bashrc
if [ -f /etc/bash.bashrc ]; then
	. /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ "$NAME" == "fedora-toolbox" ]]; then
	HISTFILE=~/.bash_history.toolbox
	return
fi

###############################################################################
# Completion
###############################################################################
shopt -s no_empty_cmd_completion
if [[ -f /usr/share/fzf/completion.bash ]]; then
	. /usr/share/fzf/completion.bash
fi

if command -v doctl &> /dev/null; then
	. <(doctl completion bash)
fi

if command -v kubectl &> /dev/null; then
	. <(kubectl completion bash)
fi

if command -v terraform &> /dev/null; then
	complete -C terraform terraform
fi

###############################################################################
# Globbing
###############################################################################
shopt -s extglob
shopt -s globstar

###############################################################################
# Prompt
###############################################################################
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

###############################################################################
# History
###############################################################################
HISTTIMEFORMAT="%d/%m/%y %T "
HISTFILE=~/.bash_history.$HOSTNAME
HISTSIZE=10000
HISTFILESIZE=1000000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='ls:clear:history[ \t]*|.*'
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

###############################################################################
# Better cd navigation
###############################################################################
shopt -s autocd
shopt -s cdspell

###############################################################################
# Colors
###############################################################################
alias ls='ls --color'

###############################################################################
# Aliases / functions
###############################################################################
alias ll='ls -ahl'
alias less='less -R'
alias view='nvim -R'
alias vimdiff="nvim -d"
alias rm='rm -i'
alias ..='cd ..'
alias c='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias e=nvim
alias vim=nvim
alias g=git
alias vgs='nvim -c ":Git|:only"'

fzf_select_branch() {
	local branches branch
	branches=$(git --no-pager branch -vv) &&
	branch=$(echo "$branches" | fzf +m) &&
	echo "$branch" | awk '{if ($1=="*") $1=$2; print $1}' | sed "s/.* //"
}

fbr() {
	local branch
	branch=$(fzf_select_branch) &&
	git checkout "$branch"
}

gr() { cd $(git rev-parse --show-toplevel); }

flo() {
        local branch="$(fzf_select_branch)" &&
        nvim -c ":0Git log $branch $*"
}

bluon() {
	sudo sh -c 'systemctl unmask --runtime bluetooth && systemctl start bluetooth'
}

bluoff() {
	sudo systemctl mask --now --runtime bluetooth
}

if grep -q '^ID=fedora$' /etc/os-release; then
	alias pacsyu="sudo dnf upgrade"
	pacs() { sudo dnf install "$@"; }
	pacss() { dnf search "$1"; }
	pacsi() { dnf info "$1"; }
	pacrs() { sudo dnf remove "$1"; }
	pacf() { dnf provides "$1"; }
	pacfl() { dnf repoquery -l "$1"; }
	pacqs() { rpm -qa "*$1*"; }
	pacql() { rpm -ql "$1"; }
	pacqi() { rpm -qi "$1"; }
	pacqo() { rpm -qf "$1"; }
elif grep -q '^ID=archarm$' /etc/os-release; then
	alias pacsyu="sudo pacman -Syu"
	pacs() { sudo pacman -S "$@"; }
	pacss() { pacman -Ss "$1"; }
	pacsi() { pacman -Si "$1"; }
	pacrs() { sudo pacman -Rs "$1"; }
	pacf() { pacman -F "$1"; }
	pacfl() { pacman -Fl "$1"; }
	pacqs() { pacman -Qs "$1"; }
	pacql() { pacman -Ql "$1"; }
	pacqi() { pacman -Qi "$1"; }
	pacqo() { pacman -Qo "$1"; }
fi

###############################################################################
# Key bindings
###############################################################################
stty -ixon # Disable flow control so it doesn't interfere with C-s
if [[ -f /usr/share/fzf/shell/key-bindings.bash ]]; then
	. /usr/share/fzf/shell/key-bindings.bash
elif [[ -f /usr/share/fzf/key-bindings.bash ]]; then
	. /usr/share/fzf/key-bindings.bash
fi

###############################################################################
# Misc
###############################################################################

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
