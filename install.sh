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

# Install packages

# Homebrew
if [[ $(uname -s) = 'MacOS' || $(uname -s) = 'Darwin' && $(which brew > /dev/null) -eq 0 ]]; then
  if (confirm "Do you want to install homebrew packages?"); then
    echo "Installing homebrew packages..." \
    && brew bundle \
    && "Installed homebrew packages"
  else
    echo "Skipping"
  fi
fi

# APT
if [[ $(uname -s) = 'Linux' && $(which apt > /dev/null) ]]; then
  if (confirm "Do you want to install apt packages?"); then
    echo "Installing apt packages..." \
    && xargs sudo apt install <Aptfile \
    && echo "Installed apt packages"
  else
    echo "Skipping"
  fi
fi

# npm
if which npm > /dev/null; then
  if (confirm "Do you want to install npm packages?"); then
    echo "Installing npm packages..." \
    && xargs -I{} npm i -g {} <Npmfile \
    && echo "Installed npm packages"
  else
    echo "Skipping"
  fi
fi

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

# Source zshrc
[ -f ~/.config/zsh/.zshrc ] && echo "Sourcing zshrc" && source ~/.config/zsh/.zshrc

popd

echo "Installation successful"
echo "For more information about this configuration, read the README.md file"
