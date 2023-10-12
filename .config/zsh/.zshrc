# +-------------------+
# | Prompt and colors |
# +-------------------+

# TODO move to file related topic as in old branch on github repo

# Enable colors and change prompt:
autoload -U colors && colors

# The best prompt
eval "$(starship init zsh)"

# +---------+
# | History |
# +---------+

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# +------------+
# | COMPLETION |
# +------------+

# Should be called before compinit
zmodload zsh/complist			# for menuselect

# Basic auto/tab complete:
fpath+=$ZDOTDIR/.zfunc
autoload -Uz compinit
zstyle ':completion:*' menu select

# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
setopt correct # spelling correction for commands
compinit
_comp_options+=(globdots)		# Include hidden files.

# +--------------+
# | COMMAND LINE |
# +--------------+

bindkey -v # vi mode
cursor_mode() {
    # See https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]] ||
            [[ $1 = 'beam' ]]; then
            echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}

cursor_mode
# bindkey -e # more natural..
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -v '^?' backward-delete-char
bindkey "^[^[[C" forward-word   # alt cursor right
bindkey "^[^[[D" backward-word  # alt cursor left

# Edit line in vim with ctrl-e:
# autoload edit-command-line; zle -N edit-command-line
# bindkey '^e' edit-command-line

# +-------------+
# | Other stuff |
# +-------------+
echo $HISTFILE

# Load aliases and shortcuts if existent.
[ -f "$ZDOTDIR/aliases" ] && source "$ZDOTDIR/aliases"
[ -f "$ZDOTDIR/functions" ] && source "$ZDOTDIR/functions"
[ -f "$ZDOTDIR/envs" ] && source "$ZDOTDIR/envs"

echo $HISTFILE
# Load bitwarden cli config
[ -f "$HOME/.config/bwcli" ] && source "$HOME/.config/bwcli"

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
# export PATH=$PATH:/opt/homebrew/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin

# Fuzzy searcher config and bindings
[ -f $ZDOTDIR/fzf ] && source $ZDOTDIR/fzf

# +--------------------+
# | Recent directories |
# +--------------------+

autoload -Uz add-zsh-hook

DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS	# Remove duplicate entries
setopt PUSHD_MINUS			# Reverts the +/- operators

# +----------------+
# | Git submodules |
# +----------------+

fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
