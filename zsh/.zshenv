## Export all general environment variables here, it will be available in non interactive shells as well
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# zsh
export ZDOTDIR=$HOME/.config/zsh
export DOTFILES="$HOME/code/dotfiles"

# Ensure necessary dirs exist
mkdir -p "$HOME/{.config,.cache}/zsh"

# editor
export EDITOR="vim"
export VISUAL="vim"

# history
export HISTFILE=$HOME/.cache/zsh/history # History filepath
export HISTSIZE=10000                    # Maximum events for internal history
export SAVEHIST=10000                    # Maximum events in history file

# local path
path=("$HOME/.local/bin" "$path[@]")
typeset -Ux path PATH # Unique, eXport
