# Makefile to easily copy the correct packages to linux, osx, etc systems.

osx:
	stow --verbose --stow --target $$HOME */

linux:
	stow --verbose --stow --target $$HOME zsh vim tmux starship git

# Remove all stowed links
delete:
	stow --verbose --target=$$HOME --delete */
