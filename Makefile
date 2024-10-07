# Makefile to easily copy the correct packages to linux, osx, etc systems.

osx:
	stow --verbose --stow --target $$HOME */

linux: osx

# Remove all stowed links
delete:
	stow --verbose --target=$$HOME --delete */
