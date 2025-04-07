# Makefile to easily copy the correct packages to linux, osx, etc systems.

dev: # macbooks
	stow --verbose --stow --target $$HOME */

remote: # rpi, vps etc
	stow --verbose --stow --target $$HOME zsh vim tmux starship git

# Remove all stowed links
delete:
	stow --verbose --target=$$HOME --delete */
