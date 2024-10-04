# My Dotfiles

This directory contains the dotfiles I like to share between the *nix systems I use.

## Requirements

### Git

### Stow

## HowTo

Define a function `dtf`

```sh
dtf () {
	git --git-dir="$DOTFILES" --work-tree="$HOME" "$@"
}
```

### Stow

First, check out the fotfiles repo in the $HOME directory using git

```sh
cd code
git clone git@github.com/wookiesh/dotfiles.git
cd dotfiles
```

then use GNU stow to create symlinks

```sh
stow . --target=$HOME
```
## TODO

- [x] Create a makefile for linux, osx to stow the correct packages
- [ ] Have a look at [Chez Moi](https://www.chezmoi.io/quick-start/)

## Reference
- [still don't have a title](https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html)
- [Manage Your Dotfiles Like a Superhero](https://www.jakewiesler.com/blog/managing-dotfiles)
- [How I manage my dotfiles using GNU Stow](https://dev.to/spacerockmedia/how-i-manage-my-dotfiles-using-gnu-stow-4l59)
