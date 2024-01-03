#!/bin/sh

cd
git clone https://github.com/ashleytowner/dotfiles
cd dotfiles
chmod +x install.sh
chmod +x uninstall.sh
chmod +x install-dependencies.sh
yes | ./install.sh
