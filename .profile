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
export BAT_PAGER="less -RF" # Probably only needed because of a bug
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PAGER='less --mouse'
export MANROFFOPT="-c"

appendpath "$HOME/scripts"

case $- in
    *i*)
        if test "$BASH" && test -r ~/.bashrc; then
            . ~/.bashrc
        fi
        ;;
esac
