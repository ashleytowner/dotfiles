#!/bin/zsh

source .confirm.sh

if which git > /dev/null; then
  if (confirm "Do you want to update this repository?"); then
    git pull
  fi
fi

# Make sure we are in the correct directory
basedir=$(dirname "$0")

pushd "$basedir"

# Install git submodules
git submodule update --init

# Stow everything that needs stowing
stow_dirs=("${(@f)$(cat .stowable)}")

for d in $stow_dirs
do
  if (confirm "Do you want to stow ${d}?"); then
    stow $d
    echo "$d stowed"
  else
    echo "Skipping"
  fi
done

# Install homebrew
if [[ $(uname -s) = 'MacOS' || $(uname -s) = 'Darwin' && $(which brew > /dev/null) -gt 0 ]]; then
  echo "Homebrew not installed."
  if (confirm "Do you want to install it?"); then
    which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed"
  else
    echo "Skipping"
  fi
else
  echo "Homebrew installed; skipping"
fi

# Install node
if which nvm > /dev/null; then
	if (confirm "Do you want to install nvm and node?"); then
		echo "Installing nvm" \
		&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
		&& echo "Installed nvm"
		echo "Installing node v18" \
		&& nvm install v18 \
		&& echo "Installed node v18"
	else
		echo "Skipping"
	fi
fi

popd

echo "Installation successful"
echo "You can install other dependencies by running ./install-dependencies.sh"
echo "For more information about this configuration, read the README.md file"
