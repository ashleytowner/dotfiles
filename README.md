# Dotfiles

Version-controlled configuration files for my personal computers.

## Installation

```zsh
# Download the repo

git clone https://github.com/ashleytowner/dotfiles 
cd dotfiles

# Run the install script
chmod +x install.sh
./install.sh
```

## Local Overriding

Sometimes you may want to have some specific overrides on each machine that you don't want to commit to the central repo. To do this, you can use local override files which will be loaded at the end of various dotfiles. Below is a list of the currently configured override files: 

| Program | Local Override File                        |
| :-----: | :----------------------------------------- |
|   zsh   | `~/.config/local_override/zsh/.zshrc`      |
|   git   | `~/.config/local_override/git/.gitconfig`  |
|  nvim   | `~/.config/local_override/nvim/init.vim`   |
|  tmux   | `~/.config/local_override/tmux/.tmux.conf` |
