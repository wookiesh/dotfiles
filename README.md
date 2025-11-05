# My dotfiles

This repository contains my dotfiles and configuration that I share between the *nix systems I use (Linux and macOS).

## Overview

The goal is to version and deploy configuration files (zsh, vim, tmux, git, etc.) organized in directories at the repository root. The typical workflow uses GNU Stow to create symbolic links in $HOME.

## Prerequisites

On Debian/Ubuntu (or derivatives):

```sh
sudo apt update
sudo apt install -y git stow make eza
```

On macOS (with Homebrew):

```sh
brew update
brew install git stow make eza
```

Note: I prefer `eza` (a modern `ls` replacement), but it is optional.

## Installation

1. Clone the repository (for example into `~/code`):

```sh
mkdir -p ~/code && cd ~/code
git clone git@github.com:wookiesh/dotfiles.git
cd dotfiles
```

2. Deploy the packages you want using the appropriate Make target.

Assumption: the provided `Makefile` contains targets such as `make linux` and `make macos` (or `make osx`) that call `stow` for the correct packages. If those targets are not present you can use Stow manually (see next section).

```sh
# for Linux
make linux

# for macOS
make macos
```

## Using GNU Stow (manual)

GNU Stow lets you organize dotfiles by package directories (e.g. `zsh/`, `git/`, `vim/`) and create symlinks into `$HOME`.

Examples:

```sh
# run from the repository root
stow -v -t ~ zsh
stow -v -t ~ git
```

If files already exist in `$HOME`, Stow will fail — back them up or remove them first.

## Repository structure

The main folders in this repository include:

- `ansible/` — Ansible roles/playbooks
- `git/` — Git configuration (e.g. `.gitconfig`)
- `zsh/` — Zsh configuration
- `vim/` — Vim configuration
- `tmux/`, `wezterm/`, `starship/`, `gnupg/` — other configurations
- `bootstrap.sh` — installation/initialization script (if present)

Adapt the list to the packages you want to deploy.

## Troubleshooting

- Issue: "existing file or directory" when running `stow` — back up or remove the existing file in `$HOME`, then re-run `stow`.
- Issue: wrong target — use `stow -t ~ <package>` to force the target directory.
- Tip: run `stow -n` (dry-run) first to see what would be done.

```sh
stow -n -v -t ~ zsh
```

## Contributing

- Add a new directory for your package (e.g. `alacritty/`) containing the files to be linked.
- Update the `Makefile` if you add a new target that groups packages.
- Open a pull request with a clear description of your changes.

## TODO

- [x] Create `Makefile` target(s) for Linux and macOS to automatically stow the appropriate packages
- [ ] Test and document integration with [chezmoi](https://www.chezmoi.io/quick-start/)

## References

- Managing dotfiles with GNU Stow — https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html
- Manage Your Dotfiles Like a Superhero — https://www.jakewiesler.com/blog/managing-dotfiles
- How I manage my dotfiles using GNU Stow — https://dev.to/spacerockmedia/how-i-manage-my-dotfiles-using-gnu-stow-4l59

---

If you'd like, I can:

- check the `Makefile` and adapt the instructions if targets differ,
- add a minimal example `Makefile` target if needed,
- add a `CONTRIBUTING.md` template or a license.
