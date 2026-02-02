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

export EMPTY_COMMAND='' # If an empty command is entered, this command will be run instead

export FZF_COMPLETION_OPTS=""
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_DIR_COMMAND='find . -type d -not -path "*/.git/*" -not -path "*/.git"'

export CC="clang-20"
export CXX="clang++-20"

export PATH="$PATH:$HOME/go/bin:/usr/local/go/bin:/opt:$HOME/bin:/opt/homebrew/bin"

# Defaults
export EDITOR="$(which nvim)"
export PAGER="less"
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

# Set tab size
tabs -2
#}}}

#{{{ *functions*

# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  rg --files --hidden
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  eval $FZF_DEFAULT_DIR_COMMAND
}
#}}}

#{{{ *aliases* 
alias nv="nvim"
alias run="scripts"

alias ls="ls -G --color"
alias la="ls -A"
alias ll="ls -Al"
alias lll="ls -l | tail -n \$(( \$(ls -l | wc -l) - 1 )) | awk '{print \$NF}'"

alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."
alias -g ......="../../../../.."

alias unzip-all="find . -maxdepth 1 -name '*.zip' | parallel unzip '{}' -d '{.}'"

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

if which xdg-open > /dev/null
then
  alias open=xdg-open
fi

alias -g Cerr="2>&1 > /dev/null | yank"
alias -g Ln="| getLine"
alias -g Last="| awk '{print \$NF}'"

# }}}

#{{{ *line_editor*

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
bindkey -v
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
PROMPT_EOL_MARK=''
PROMPT_POSITION='bottom' # This is managed by the pin prompt plugin

# Make up & down keys search based on what's already entered
bindkey '^N' history-beginning-search-forward
bindkey '^P' history-beginning-search-backward
case $(uname -s) in
'Darwin')
;&
'MacOS')
  bindkey '\e[A' history-beginning-search-backward
  bindkey '\e[B' history-beginning-search-forward
;;
'Linux')
  bindkey "^[OA" history-beginning-search-backward
  bindkey "^[OB" history-beginning-search-forward
;;
esac

zle-keymap-select() {
	if [[ $KEYMAP == vicmd ]]; then
		bindkey -M vicmd 'j' history-beginning-search-forward
		bindkey -M vicmd 'k' history-beginning-search-backward
	else
		bindkey -M main 'j' self-insert
		bindkey -M main 'k' self-insert
	fi
}

zle -N zle-keymap-select

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
#}}}

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

source <(fzf --zsh)
 # }}}

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [[ "$TERM" == "xterm-kitty" ]]; then
  alias ssh='kitty +kitten ssh'
fi

# vim: foldmethod=marker foldlevel=99

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# opencode
export PATH=/home/ashley/.opencode/bin:$PATH
