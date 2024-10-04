# Makefile to easily copy the correct packages to linux, osx, etc systems.

osx:
	stow -vv --restow --target $$HOME --simulate */

linux:
	echo linux
