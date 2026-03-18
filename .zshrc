# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load zsh options, keybindings, and completion
[[ -f /usr/share/omarchy-zsh/shell/zoptions ]] && source /usr/share/omarchy-zsh/shell/zoptions

# Load shared shell configuration (aliases, functions, environment, tool init)
[[ -f /usr/share/omarchy-zsh/shell/all ]] && source /usr/share/omarchy-zsh/shell/all

# Add your own customizations below
#
# Make an alias for invoking commands you use constantly
# alias p='python'
# alias cx="claude --permission-mode=plan --allow-dangerously-skip-permissions"


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
    file=$(ls -1 --sort=modified  ~/.ssh | grep .pub | fzf --layout=reverse --header="Selecciona la clave publica que quieres copiar")
    cat ~/.ssh/$file | wl-copy && echo '=> Public key copied to clipboard.'
}

# Send files to ~/.local/share/Trash instead eliminate
alias rm='trash'


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz compinit && compinit

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit ice blockf
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' file-list never
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'command eza --group-directories-first --color=always --no-icons -1 $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'command eza --group-directories-first --color=always --no-icons -1 $realpath'


