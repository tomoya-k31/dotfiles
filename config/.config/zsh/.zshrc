# ~/.zshrc

# History configuration
HISTSIZE=100000
SAVEHIST=1000000
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
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p $XDG_CACHE_HOME/zsh
_zcompdump=$XDG_CACHE_HOME/zsh/zcompdump
if [[ -n $_zcompdump(#qN.mh+24) ]]; then
  compinit -d $_zcompdump
else
  compinit -C -d $_zcompdump
fi
unset _zcompdump

# Key bindings
bindkey "^[[1;3D" backward-word # Option + ←
bindkey "^[[1;3C" forward-word  # Option + →

##### plugins #####
eval "$(sheldon source)"
