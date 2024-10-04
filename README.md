# My Dotfiles

## HowTo

Define a function `dtf`

```sh
dtf () {
	git --git-dir="$DOTFILES" --work-tree="$HOME" "$@"
}
```

