# +----------------------+
# | Miscelleanous things |
# +----------------------+

# Record the current time in milliseconds
# Use 'gdate' on macOS, and 'date' on Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
  date_cmd="gdate"
else
  date_cmd="date"
fi
start_time=$($date_cmd +%s%3N)

# Function to check if the file needs to be compiled and source the compiled version
zsh_compile_if_needed() {
  local src_file="$1"
  local compiled_file="${src_file}.zwc"

  # Check if the compiled file doesn't exist or if the source file is newer than the compiled file
  if [[ ! -f $compiled_file || $src_file -nt $compiled_file ]]; then
    echo "Compiling $src_file..."
    zcompile $src_file $compiled_file
  fi

  # Source the compiled file if it exists and is up-to-date
  if [[ -f $compiled_file ]]; then
    echo source $compiled_file
    source $compiled_file
    return  # Exit to prevent double sourcing
  fi
}
# Finally a great idea but does not seem to work,
# zmodload zsh/zprof && zprof can help to check for time bottlenecks

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

setopt EXTENDED_HISTORY # Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.

# +------------+
# | COMPLETION |
# +------------+

# Should be called before compinit
zmodload zsh/complist # for menuselect

# completion for tools installed with brew
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Basic auto/tab complete:
fpath+=$ZDOTDIR/completions
fpath=($ZDOTDIR/plugins/zsh-completions/src $fpath)

zstyle ':completion:*' menu select

# Enable caching for completion to improve performance.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
# Add useful and improved styles for various completions.
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:descriptions' format '%U%B%d%b%u' # Colorful descriptions
# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
setopt correct # spelling correction for commands
_comp_options+=(globdots) # Include hidden files.
autoload -Uz compinit && compinit

# +--------------+
# | COMMAND LINE |
# +--------------+

# bindkey -v # vi mode
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
bindkey -v '^?' backward-delete-char
bindkey -v
bindkey "^[^[[C" forward-word  # alt cursor right
bindkey "^[^[[D" backward-word # alt cursor left

# Edit line in vim with ctrl-e:
# autoload edit-command-line; zle -N edit-command-line
# bindkey '^e' edit-command-line

# +-------------+
# | Other stuff |
# +-------------+
zmodload zsh/zprof
# Load aliases and shortcuts
[ -f "$ZDOTDIR/aliases" ] && source "$ZDOTDIR/aliases"
[ -f "$ZDOTDIR/envs" ] && source "$ZDOTDIR/envs"
[ -f "$ZDOTDIR/functions" ] && source "$ZDOTDIR/functions"
# Local configuration for the running host only => Should not be stowed/committed
[ -f "$ZDOTDIR/local" ] && source "$ZDOTDIR/local"
# OSX specific bits and get bitwarden session
[ -f "$ZDOTDIR/osx" ] && [[ "$(uname -s)" == "Darwin" ]] && source "$ZDOTDIR/osx"

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
# export PATH=$PATH:/opt/homebrew/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin

# Fuzzy searcher config and bindings
[ -f $ZDOTDIR/fzf ] && source $ZDOTDIR/fzf

# +--------------------+
# | Recent directories |
# +--------------------+

autoload -Uz add-zsh-hook

# Define dirstack cache location
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
mkdir -p "$(dirname "$DIRSTACKFILE")"

# Restore dirstack from the file if it exists and dirstack is empty
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
    # Read the file and populate dirstack array
    dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")

    # Only `cd` if dirstack[1] exists and is a valid directory
    if [[ -n "${dirstack[1]}" && -d "${dirstack[1]}" ]]; then
        cd -- "${dirstack[1]}"
    else
        # Optional: Fallback to home directory if dirstack[1] is invalid
        cd ~
    fi
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS # Remove duplicate entries
setopt PUSHD_MINUS       # Reverts the +/- operators

# +----------------+
# | Other plugins |
# +----------------+

source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# # Fuzzy find
# if [[ "$OSTYPE" == "darwin"* ]]; then
#     [ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ] && source /opt/homebrew/opt/fzf/shell/completion.zsh || true
#     [ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh || true
# else
    # [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ] && source /usr/share/doc/fzf/examples/key-bindings.zsh || true
    # [ -f "/usr/share/doc/fzf/examples/completion.zsh" ] && source /usr/share/doc/fzf/examples/completion.zsh || true
# fi

# Atuin (brew install to get the hand on the config)
eval "$(atuin init zsh --disable-up-arrow)" # TODO: retirer fzf ?
# eval "$(atuin init zsh)" # TODO: retirer fzf ?

# Zoxide, a better cd
eval "$(zoxide init zsh)"
alias cd="z"

# and finally, calculate the elapsed time
end_time=$($date_cmd +%s%3N)
elapsed_time=$((end_time - start_time))
echo "Sourcing .zshrc took ${elapsed_time} milliseconds."
