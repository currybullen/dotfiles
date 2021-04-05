if test "$BASH"; then
	appendpath () {
	    case ":$PATH:" in
		*:"$1":*)
		    ;;
		*)
		    PATH="${PATH:+$PATH:}$1"
	    esac
	}

	if [ -f ~/.profile.$HOSTNAME ]; then
		. ~/.profile.$HOSTNAME
	fi

	export FZF_COMPLETION_TRIGGER="~~"
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
	export FZF_DEFAULT_OPTS="--multi \
		--bind ctrl-s:jump \
		--bind ctrl-u:preview-page-up \
		--bind ctrl-d:preview-page-down"
	export FZF_CTRL_T_OPTS="--preview 'bat --color always {} | head -500'"
	export EDITOR="$VISUAL"
	export BAT_PAGER="less -RF" # Probably only needed because of a bug
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	export MANROFFOPT="-c"
	export LESS="--ignore-case --RAW-CONTROL-CHARS"

	appendpath "$HOME/scripts"
	appendpath "$HOME/IntelliJ/bin"
	appendpath "$HOME/.cargo/bin"
	appendpath "$HOME/.cargo/env"

	case $- in
		*i*) . ~/.bashrc ;;
	esac
fi

