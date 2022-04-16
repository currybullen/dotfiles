# Basically only env variables and PATH definition goes here

if test "$BASH"; then
	if [[ "$NAME" == "fedora-toolbox" ]]; then
		return
	fi

	appendpath () {
		if [[ ! -e $1 ]]; then
			return
		fi

		case ":$PATH:" in
			*:"$1":*)
				;;
			*)
				PATH="${PATH:+$PATH:}$1"
		esac
	}

	if [[ -f ~/.profile.$HOSTNAME ]]; then
		. ~/.profile.$HOSTNAME
	fi

	export BAT_THEME="ansi"
	export FZF_COMPLETION_TRIGGER="~~"
	export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
	export FZF_DEFAULT_OPTS="--multi \
		--bind ctrl-s:jump \
		--bind ctrl-u:preview-page-up \
		--bind ctrl-d:preview-page-down"
	export FZF_CTRL_T_OPTS="--preview 'bat --color always {} | head -500'"
	export VISUAL="nvim"
	export EDITOR="$VISUAL"
	export LESS="--ignore-case --RAW-CONTROL-CHARS"

	appendpath "$HOME/.local/bin"
	appendpath "$HOME/scripts"
	appendpath "$HOME/IntelliJ/bin"
	appendpath "$HOME/.cargo/bin"
	appendpath "$HOME/.cargo/env"

	case $- in
		*i*) . ~/.bashrc ;;
	esac
fi

