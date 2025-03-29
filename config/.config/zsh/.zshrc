# ~/.zshrc

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$XDG_DATA_HOME/zsh/history

# Create history file directory if it doesn't exist
[[ -d $XDG_DATA_HOME/zsh ]] || mkdir -p $XDG_DATA_HOME/zsh

# Enable command auto-correction
setopt correct

# Various zsh options
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Enable command completion
autoload -Uz compinit
if [[ -n $XDG_CACHE_HOME/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -d $XDG_CACHE_HOME/zsh/zcompdump
else
  [[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p $XDG_CACHE_HOME/zsh
  compinit -d $XDG_CACHE_HOME/zsh/zcompdump
fi

# User specific aliases and functions
alias ll='ls -la'
alias gs='git status'
alias la='ls -A'
alias l='ls -CF'
alias vi='vim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'




##### plugins #####
eval "$(sheldon source)"
