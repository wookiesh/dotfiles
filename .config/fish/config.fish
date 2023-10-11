# variables
set fish_greeting
set -gx PAGER less
set -gx EDITOR vim
set -gx VISUAL vim
set -gx LC_ALL fr_BE.UTF-8
set -gx BAT_THEME Dracula
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Prompt
source (/usr/local/bin/starship init fish --print-full-init | psub)

# Iterm Integration`
#test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish
