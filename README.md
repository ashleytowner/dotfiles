# Dotfiles

Version-controlled configuration files for my personal computers.

## Installation

1. Install Dependencies
    - `git`
    - `curl`
    - `stow`
    - `zsh`
2. Run remote install script
    - `curl https://raw.githubusercontent.com/ashleytowner/dotfiles/main/install-remote.sh | sh`
3. Setup zsh
    - `chsh -s $(which zsh)`
    - `source ~/.zshrc`
4. Install other dependencies
    - with a script:
        - `./install-dependencies.sh`
    - manually:
        - `nvim`
            - `ripgrep`
            - `fd` / `fd_find`
            - `jq`
            - `npm i neovim`
        - `tmux`
        - `fzf` [installation instructions](https://github.com/junegunn/fzf#installation)

## Local Overriding

Sometimes you may want to have some specific overrides on each machine that you don't want to commit to the central repo. To do this, you can use local override files which will be loaded at the end of various dotfiles. Below is a list of the currently configured override files: 

| Program | Local Override File                        |
| :-----: | :----------------------------------------- |
|   zsh   | `~/.config/local_override/zsh/.zshrc`      |
|   git   | `~/.config/local_override/git/.gitconfig`  |
|  nvim   | `~/.config/local_override/nvim/init.lua`   |
|  tmux   | `~/.config/local_override/tmux/.tmux.conf` |

