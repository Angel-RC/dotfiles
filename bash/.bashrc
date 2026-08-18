# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# wrapper for yazi
# press q to quit and you'll see the CWD changed. Sometimes, you don't want to change, press Q to quit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function pubkey() {
    file=$(ls -1 --sort=time ~/.ssh | grep .pub | fzf --layout=reverse --header="Selecciona la clave publica que quieres copiar")
    cat ~/.ssh/$file | wl-copy && echo '=> Public key copied to clipboard.'
}

# Send files to ~/.local/share/Trash instead eliminate
alias rm='trash'

. "$HOME/.local/share/../bin/env"

