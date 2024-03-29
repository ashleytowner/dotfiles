# *bashrc*
#|exports|
#|line-editor|
#|functions|
#|aliases|
#|external|

# |exports|
# XDG Standards
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export COWPATH=/usr/local/share/cows:$XDG_DATA_HOME/cows
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home
export ANDROID_SDK_ROOT=~/Library/Android/sdk
export TASKRC=$XDG_CONFIG_HOME/taskwarrior/taskrc
export FZF_DEFAULT_COMMAND='rg --ignore --hidden --files'
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/opt/inetutils/libexec/gnubin:/opt/apache-maven-3.6.3/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/lib/node_modules:~/bin:~/Library/Android/sdk/platform-tools

# |line-editor|
PS1="$ "
PS2="> "
PS3="3 "
PS4="4 "

# |functions|

# Get one specific line of stdin
function getLine() {
  head -n $1 | tail -n 1
}

# |aliases| 
# Commands
alias py="python3"
function weather() {
  curl v2.wttr.in/$1
}
alias vim="nvim"
alias ovim="/usr/bin/vim"
alias src="source ~/.bashrc"

# directories
alias ls="ls -G"
alias la="ls -A"
alias ll="ls -Al"
alias ...="cd ../.."
alias ....="cd ../../.."

## Spotify
alias sfy="spotify"
alias next="spotify next"
alias prev="spotify prev"
alias pause="spotify pause"
alias play="spotify play"

## Terminal tabbing
alias split="split_tab"
alias vsplit="vsplit_tab"

## 1password
alias opg="op get"
alias opgi="op get item"

# |external|

if [ -d "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi
#. "$HOME/.cargo/env"
