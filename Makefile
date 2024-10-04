# Makefile to easily copy the correct packages to linux, osx, etc systems.

osx:
	stow --verbose --restow --target $$HOME */

linux:
	echo linux

# Remove all stowed links
delete:
    stow --verbose --target=$$HOME --delete */
