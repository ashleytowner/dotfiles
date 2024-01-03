#!/bin/zsh

source .confirm.sh

# apt
if which apt > /dev/null; then
	if (confirm "Do you want to install apt dependencies?"); then
		sudo apt update
		sudo apt install -y $(cat .dependencies/apt)
	else
		echo "Skipping"
	fi
fi

# snap
if which snap > /dev/null; then
	if (confirm "Do you want to install snap dependencies?"); then
		sudo snap install nvim --classic
	else
		echo "Skipping"
	fi
fi

# brew
if which brew > /dev/null; then
	if (confirm "Do you want to install brew dependencies?"); then
		brew install $(cat .dependencies/brew)
	else
		echo "Skipping"
	fi
fi

# npm
if which npm > /dev/null; then
	if (confirm "Do you want to install npm dependencies?"); then
		npm install -g $(cat .dependencies/npm)
	else
		echo "Skipping"
	fi
fi
