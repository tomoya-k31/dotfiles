### ls-colors
# export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32"

# confirm commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# vi
alias vi='nvim'
alias vim='nvim'

# eza
alias ls='eza -g --icons'
alias la='eza -lTHhag -L1 --icons --time-style=relative'
alias ll='eza -lTHhg -L1 --icons --time-style=relative'
alias tree='eza --group-directories-first --git --icons --tree'

# bat
export MANPAGER="sh -c 'col -bx | bat --color=always --language=man --plain'"
export BAT_THEME="Dracula"
export BAT_STYLE="numbers,changes,header"
alias cat='bat'

# httpie
alias https='http --default-scheme=https'
