# *zshrc*
# ============ Table of Contents ===================
#
#|exports| Exported Variables
#|modules| Modules
#|options| Set Options |line_editor| Settings for the line editor
#|functions| Custom functions
#|aliases| Command aliases
#|external| Externally loaded files
#
# ==================================================

#{{{ *exports*
# XDG Standards
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export COWPATH=/usr/local/share/cows:$XDG_DATA_HOME/cows
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home
export ANDROID_SDK_ROOT=~/Library/Android/sdk
export TASKRC=$XDG_CONFIG_HOME/taskwarrior/taskrc
export TIMERC=$XDG_CONFIG_HOME/timewarrior/timerc
export FZF_DEFAULT_COMMAND='fd -H --type f'
export EMPTY_COMMAND='' # If an empty command is entered, this command will be run instead
export PATH=/usr/local/opt/ruby/bin:/usr/local/bin:/sbin:/usr/local/sbin:/usr/local/opt/inetutils/libexec/gnubin:/opt/apache-maven-3.6.3/bin:/usr/bin:/bin:/usr/sbin:/usr/local/lib/node_modules:~/bin:~/Library/Android/sdk/platform-tools:~/.cargo/bin:~/go/bin:~/.local/bin
export EDITOR="nvim"
export TASKDDATA=~/.local/share/taskd
export RANGER_LOAD_DEFAULT_RC=false
#}}}

#{{{ *modules*
zmodload zsh/zpty
zmodload zsh/complete
zmodload zsh/complist
zmodload zsh/computil
#}}}

#{{{ *options*
autoload -Uz compinit && compinit
autoload -U colors && colors
setopt autocd
setopt AUTO_PUSHD
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:git:*' user-commands fco:'description for foo'
#}}}

#{{{ *line_editor*

# function prompt() { 
#     echo "%{$fg[blue]%}%~ %{$fg[magenta]%}$(git branch --show-current 2> /dev/null)%{$reset_color%} \n$ "
# }
# setopt PROMPT_SUBST
# export PS1="\$(prompt)"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
bindkey -v
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
PROMPT_EOL_MARK=''
PROMPT_POSITION='bottom' # This is managed by the pin prompt plugin

# Make up & down keys search based on what's already entered
case $(uname -s) in
'Darwin')
;&
'MacOS')
  bindkey '\e[A' history-beginning-search-backward
  bindkey '\e[B' history-beginning-search-forward
  alias fdfind=fd
;;
'Linux')
  bindkey "^[OA" history-beginning-search-backward
  bindkey "^[OB" history-beginning-search-forward
;;
esac
#}}}

#{{{ *functions*

function dev-tmux() {
  tmux new-session -s $1 \; rename-window 'server' \; new-window \; rename-window 'editor' \; new-window \; rename-window 'tunnel' \; attach
}

# alias findfunction=$(which fd > /dev/null && echo "fd" || which fdfind > /dev/null && echo "fdfind")
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fdfind --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fdfind --type d --hidden --follow --exclude ".git" . "$1"
}
#}}}

#{{{ *aliases* 
alias py="python3"
function weather() {
  curl v2.wttr.in/$1
}
alias vim="nvim"
alias vimm="nvim -M"
alias ovim="/usr/bin/vim"
alias vims="nvim -S $XDG_DATA_HOME/nvim/sessions/\$(ls $XDG_DATA_HOME/nvim/sessions | fzf)"
alias src="source $ZDOTDIR.zshrc"
alias reload="exec zsh -l"
alias run="scripts"
alias lag="ag --pager 'less -R'"
alias vag="ag --vimgrep"

alias ls="ls -G"
alias la="ls -A"
alias ll="ls -Al"
alias lll="ls -l | tail -n \$(( \$(ls -l | wc -l) - 1 )) | awk '{print \$NF}'"
alias -g ...="../.."
alias -g ....="../../.."

alias sfy="spotify"
alias next="spotify next"
alias prev="spotify prev"
alias pause="spotify pause"
alias play="spotify play"

alias split="split_tab"
alias vsplit="vsplit_tab"

alias opg="op get"
alias opgi="op get item"

# Set a yank & put command
if which xclip > /dev/null
then
    function yank() {
      input=$(cat)
      echo ${input}
      echo ${input} | xclip -i -selection clipboard
    }
    alias put="xclip -o -sel clip"
fi

if which pbcopy > /dev/null && which pbpaste > /dev/null
then
    function yank() {
      input=$(cat)
      echo ${input}
      echo ${input} | pbcopy
    }
    alias put="pbpaste"
fi

alias -s txt=vim
alias -s yaml=vim
alias -s yml=vim
alias -s md=vim
alias -s js=node
alias -s ts=ts-node
alias -s py=python3

alias -g L="| less"
alias -g Cerr="2>&1 > /dev/null | yank"
alias -g H="| head -n"
alias -g T="| tail -n"
alias -g F="| ag"
alias -g Ln="| getLine"
alias -g Last="| awk '{print \$NF}'"

# }}}

# {{{ *external*

# Autoload directory
for file in ~/.config/zsh/autoload/*; do
	if [ $(echo "$file" | grep -vE ".disable$") ]; then
		source "$file"
	fi
done

# Source local changes to zshrc
if [ -f $XDG_CONFIG_HOME/local_override/zsh/.zshrc ]; then
  source $XDG_CONFIG_HOME/local_override/zsh/.zshrc
fi

[ -f $XDG_CONFIG_HOME/fzf/.fzf.zsh ] && source $XDG_CONFIG_HOME/fzf/.fzf.zsh
 # }}}


# If the shell is just starting up, clear to position the prompt
if [ ! $FIRST_RUN ]
then
  clear
fi
export FIRST_RUN=true

function nvm_use() {
  if type nvm &> /dev/null
  then
    if [ -f .nvmrc ]
    then
      nvm use
    fi
  fi
}

function chpwd() {
  type onLeaveDir > /dev/null && onLeaveDir
  type onLeaveDir > /dev/null && unset -f onLeaveDir
  type onEnterDir > /dev/null && unset -f onEnterDir
  [ -f ./.zshrc ] && source ./.zshrc
  type onEnterDir > /dev/null && onEnterDir
  nvm_use
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
