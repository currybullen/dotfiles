appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

if [ -f /home/$USER/.profile.$HOSTNAME ]; then
	. /home/$USER/.profile.$HOSTNAME
fi

export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--multi'
export EDITOR="$VISUAL"
export BAT_PAGER="less -RF" # Probably only needed because of a bug
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

appendpath "/home/$USER/scripts"

case $- in
    *i*)
        if test "$BASH" && test -r /home/$USER/.bashrc; then
            . /home/$USER/.bashrc
        fi
        ;;
esac
