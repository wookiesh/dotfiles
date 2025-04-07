#!/usr/bin/env bash
set -euo pipefail

# Bootstrap dotfiles using GNU stow
# Usage: ./bootstrap.sh [dev|remote|delete]

ACTION=${1:-dev}
TARGET="$HOME"

function stow_packages() {
  local packages=("$@")
  for pkg in "${packages[@]}"; do
    echo "Stowing '$pkg'..."
    stow --verbose --stow --target "$TARGET" "$pkg"
  done
}

function delete_packages() {
  local packages=("$@")
  for pkg in "${packages[@]}"; do
    echo "Unstowing '$pkg'..."
    stow --verbose --target "$TARGET" --delete "$pkg"
  done
}

case "$ACTION" in
dev)
  # Automatically detect all folders (except some common ones to exclude)
  pkgs=()
  for dir in */; do
    [[ "$dir" =~ ^(\.git|scripts|README|bootstrap.sh) ]] && continue
    pkgs+=("${dir%/}")
  done
  stow_packages "${pkgs[@]}"
  ;;
remote)
  stow_packages zsh vim tmux starship git editorConfig
  ;;
delete)
  # Delete all folders in current dir
  pkgs=()
  for dir in */; do
    pkgs+=("${dir%/}")
  done
  delete_packages "${pkgs[@]}"
  ;;
*)
  echo "Usage: ./bootstrap.sh [dev|remote|delete]"
  exit 1
  ;;
esac
