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


export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--multi'
export EDITOR="$VISUAL"
export MANROFFOPT="-c"

if grep -q Fedora /etc/os-release; then
	export BAT_PAGER="less -RF" # Probably only needed because of a bug
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	export PAGER='less --mouse'
fi

appendpath "$HOME/scripts"

case $- in
    *i*)
        if test "$BASH" && test -r ~/.bashrc; then
            . ~/.bashrc
        fi
        ;;
esac
