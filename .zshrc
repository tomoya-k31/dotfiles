# users generic .zshrc file

# LANG
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

if echo "$ITERM_PROFILE" | grep "EUC" > /dev/null ; then
    export LANG=ja_JP.eucJP
fi

## Backspace key
bindkey "^?" backward-delete-char

## Default shell configuration
# set prompt
# colors enables us to idenfity color by $fg[red].
autoload -Uz colors
colors

case ${UID} in
    0)
        PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
        PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
        SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
            PROMPT="%{${fg[cyan]}%}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
        ;;
    *)
        #
        # Color
        #
        DEFAULT=$'%{\e[1;0m%}'
        RESET="%{${reset_color}%}"
        #GREEN="%{${fg[green]}%}"
        #BLUE="%{${fg[blue]}%}"
        #RED="%{${fg[red]}%}"
        #CYAN="%{${fg[cyan]}%}"
        #WHITE="%{${fg[white]}%}"

        #RESET=$'%{\e[1;m%}'
        GREEN=$'%{\e[1;32m%}'
        BLUE=$'%{\e[1;34m%}'
        RED=$'%{\e[1;31m%}'
        CYAN=$'%{\e[1;36m%}'
        WHITE=$'%{\e[1;37m%}'

        LIGHT_GRAY=$'%{\e[1;37m%}'
        LIGHT_RED=$'%{\e[1;31m%}'
        LIGHT_GREEN=$'%{\e[1;32m%}'
        LIGHT_BLUE=$'%{\e[1;34m%}'
        LIGHT_PURPLE=$'%{\e[1;35m%}'
        LIGHT_CYAN=$'%{\e[1;36m%}'
        DARK_GRAY=$'%{\e[1;30m%}'
        #
        # Prompt
        #
        setopt prompt_subst
        PROMPT='${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}'
#        RPROMPT='${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}'
        RPROMPT='${RESET}${WHITE}[${CYAN}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}'

        VAR_PROMPT='${RESET}${green}${WINDOW:+"[$WINDOW]"}${RESET}${LIGHT_PURPLE}${USER} ${RESET}${LIGHT_BLUE}✘  ${RESET}${LIGHT_PURPLE}%m ${RESET}${white}$ ${RESET}'
        if echo "$ITERM_PROFILE" | grep "EUC" > /dev/null ; then
            VAR_PROMPT='${RESET}${green}${WINDOW:+"[$WINDOW]"}${RESET}${LIGHT_PURPLE}${USER} ${RESET}${LIGHT_BLUE}- ${RESET}${LIGHT_PURPLE}%m ${RESET}${white}$ ${RESET}'
        fi

        PROMPT=$VAR_PROMPT
        #
        # Vi入力モードでPROMPTの色を変える
        # http://memo.officebrook.net/20090226.html
        function zle-line-init zle-keymap-select {
        case $KEYMAP in
            vicmd)
                # PROMPT="${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}%{$fg_bold[cyan]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}"
                PROMPT=$VAR_PROMPT
                ;;
            main|viins)
                # PROMPT="${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}%{$fg_bold[blue]%}${USER}@%m ${RESET}${WHITE}$ ${RESET}"
                PROMPT=$VAR_PROMPT
                ;;
        esac
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select

    # 直前のコマンドの終了ステータスが0以外のときは赤くする。
    # ${MY_MY_PROMPT_COLOR}はprecmdで変化させている数値。
    local MY_COLOR="$ESCX"'%(0?.${MY_PROMPT_COLOR}.31)'m
    local NORMAL_COLOR="$ESCX"m


    # Show git branch when you are in git repository
    # http://d.hatena.ne.jp/mollifier/20100906/p1

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' formats '(%s)-[%b]'
    zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
    zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
    zstyle ':vcs_info:bzr:*' use-simple true

    autoload -Uz is-at-least
    if is-at-least 4.3.10; then
        # この check-for-changes が今回の設定するところ
        zstyle ':vcs_info:git:*' check-for-changes true
        zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
        zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
        zstyle ':vcs_info:git:*' formats '(%s)-[%c%u%b]'
        zstyle ':vcs_info:git:*' actionformats '(%s)-[%c%u%b|%a]'
    fi

    function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[2]=$(_git_not_pushed)
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

function _git_not_pushed()
{
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        head="$(git rev-parse HEAD)"
        for x in $(git rev-parse --remotes)
        do
            if [ "$head" = "$x" ]; then
                return 0
            fi
        done
        echo "{?}"
    fi
    return 0
}

# RPROMPT="%1(v|%F${CYAN}%1v%2v%f|)${vcs_info_git_pushed}${RESET}${WHITE}[${BLUE}%(5~,%-2~/.../%2~,%~)% ${WHITE}]${WINDOW:+"[$WINDOW]"} ${RESET}"
RPROMPT="%1(v|%F${CYAN}%1v%2v%f|)${vcs_info_git_pushed}${RESET}${DARK_GRAY}[${RESET}${LIGHT_RED}%(5~,%-2~/.../%2~,%~)% ${DARK_GRAY}]${WINDOW:+"[$WINDOW]"} ${RESET}"

;;
esac


# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd
# cd でTabを押すとdir list を表示
setopt auto_pushd
# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups

# コマンドのスペルチェックをする
#setopt correct

# コマンドライン全てのスペルチェックをする
#setopt correct_all

# 上書きリダイレクトの禁止
setopt no_clobber

# 補完候補リストを詰めて表示
setopt list_packed

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# 補完候補が複数ある時に、一覧表示する
setopt auto_list

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl

# 補完キー（Tab,  Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios

# 最後がディレクトリ名で終わっている場合末尾の / を自動的に取り除かない
setopt noautoremoveslash

# beepを鳴らさないようにする
setopt nolistbeep

# Match without pattern
setopt extended_glob

## Keybind configuration
#
bindkey -v

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# glob(*)によるインクリメンタルサーチ
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## Command history configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 登録済コマンド行は古い方を削除
setopt hist_ignore_all_dups

# historyの共有
setopt share_history

# 余分な空白は詰める
setopt hist_reduce_blanks

# add history when command executed.
setopt inc_append_history

# history (fc -l) コマンドをヒストリリストから取り除く。
setopt hist_no_store

# コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt path_dirs


# ^でcd ..する
function cdup() {
echo
cd ..
zle reset-prompt
}
zle -N cdup

# ctrl-f, ctrl-bキーで単語移動
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

bindkey "^[[3~" delete-char

# back-wordでの単語境界の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# URLをコピペしたときに自動でエスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# 勝手にpushd
setopt autopushd

# エラーメッセージ本文出力に色付け
e_normal=`echo -e "¥033[0;30m"`
e_RED=`echo -e "¥033[1;31m"`
e_BLUE=`echo -e "¥033[1;36m"`

function make() {
LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
function cwaf() {
LANG=C command ./waf "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}

## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
#compinit -u
compinit


## zsh editor
#
autoload zed


## Prediction configuration
#
autoload predict-on
#predict-off

## Command Line Stack [Esc]-[q]
bindkey -a 'q' push-line


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls="gls --color=auto -alG"
        zle -N expand-to-home-or-insert
        bindkey "@"  expand-to-home-or-insert
        ;;
    linux*)
        alias la="ls -al"
        ;;
esac


case "${OSTYPE}" in
    # MacOSX
    darwin*)
    export PATH=$PATH:/opt/local/bin
    export PATH=$PATH:/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/
    ;;
freebsd*)
    case ${UID} in
        0)
            updateports()
            {
                if [ -f /usr/ports/.portsnap.INDEX ]
                then
                    portsnap fetch update
                else
                    portsnap fetch extract update
                fi
                (cd /usr/ports/; make index)

                portversion -v -l \<
            }
            alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
            ;;
    esac
    ;;
esac


## terminal configuration
# http://journal.mycom.co.jp/column/zsh/009/index.html
unset LSCOLORS

case "${TERM}" in
    xterm)
        export TERM=xterm-color

        ;;
    kterm)
        export TERM=kterm-color
        # set BackSpace control character

        stty erase
        ;;

    cons25)
        unset LANG
        export LSCOLORS=ExFxCxdxBxegedabagacad

        export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
        zstyle ':completion:*' list-colors \
            'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
        ;;

    kterm*|xterm*)
        export CLICOLOR=1
        export LSCOLORS=ExFxCxDxBxegedabagacad

        export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
        # https://github.com/seebi/dircolors-solarized
        if [ -f ~/.zsh/dircolors-solarized/dircolors.ansi-universal ]; then
            if type dircolors > /dev/null 2>&1; then
                eval $(dircolors ~/.zsh/dircolors-solarized/dircolors.ansi-universal)
            elif type gdircolors > /dev/null 2>&1; then
                eval $(gdircolors ~/.zsh/dircolors-solarized/dircolors.ansi-universal)
            fi
        fi

        zstyle ':completion:*' list-colors \
            'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
        ;;

    dumb)
        echo "Welcome Emacs Shell"
        ;;
esac



export EDITOR=vim
export PATH=$PATH:/usr/local/bin:/usr/local/share
export PATH=$PATH:$HOME/.zsh
export PATH=$PATH:/sbin:usr/local/bin
export MANPATH=$MANPATH:/usr/local/share/man
export NODE_PATH=/usr/local/lib/node_modules

expand-to-home-or-insert () {
    if [ "$LBUFFER" = "" -o "$LBUFFER[-1]" = " " ]; then
        LBUFFER+="~/"
    else
        zle self-insert
    fi
}

# autojump
alias j="autojump"
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh


# zsh の exntended_glob と HEAD^^^ を共存させる。
# http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154
typeset -A abbreviations
abbreviations=(
"L"    "| $PAGER"
"G"    "| grep"

"HEAD^"     "HEAD\\^"
"HEAD^^"    "HEAD\\^\\^"
"HEAD^^^"   "HEAD\\^\\^\\^"
"HEAD^^^^"  "HEAD\\^\\^\\^\\^\\^"
"HEAD^^^^^" "HEAD\\^\\^\\^\\^\\^"
)

magic-abbrev-expand () {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}

magic-abbrev-expand-and-insert () {
    magic-abbrev-expand
    zle self-insert
}

magic-abbrev-expand-and-accept () {
    magic-abbrev-expand
    zle accept-line
}

no-magic-abbrev-expand () {
    LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-accept
zle -N no-magic-abbrev-expand
bindkey "\r"  magic-abbrev-expand-and-accept # M-x RET はできなくなる
bindkey "^J"  accept-line # no magic
bindkey " "   magic-abbrev-expand-and-insert
bindkey "."   magic-abbrev-expand-and-insert
bindkey "^x " no-magic-abbrev-expand


function rmf(){
for file in $*
do
    __rm_single_file $file
done
}

function __rm_single_file(){
if ! [ -d ~/.Trash/ ]
then
    command /bin/mkdir ~/.Trash
fi

if ! [ $# -eq 1 ]
then
    echo "__rm_single_file: 1 argument required but $# passed."
    exit
fi

if [ -e $1 ]
then
    BASENAME=`basename $1`
    NAME=$BASENAME
    COUNT=0
    while [ -e ~/.Trash/$NAME ]
    do
        COUNT=$(($COUNT+1))
        NAME="$BASENAME.$COUNT"
    done

    command /bin/mv $1 ~/.Trash/$NAME
else
    echo "No such file or directory: $file"
fi
}

## alias設定

# ls
alias la="ls -a"
alias lf="ls -F"
alias ll="ls -l"

# process
# alias j="jobs -l"
alias 'ps?'='pgrep -l -f'
alias pk='pkill -f'

# du/df
alias du="du -h"
alias df="df -h"
alias duh="du -h ./ --max-depth=1"

# su
alias su="su -l"

# vim
alias 'src'='exec zsh'
alias -g V="| vim -"

# tmux
alias tm='tmux'
alias tma='tmux attach'
alias tml='tmux list-window'


#java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_17.jdk/Contents/Home/
alias javac='javac -J-Dfile.encoding=UTF-8'
alias java='java -Dfile.encoding=UTF-8'



## Mac(Unix)

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
# alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting


# source zsh-syntax-highlighting
#=============================
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


function ht {
    var=`defaults read com.apple.finder AppleShowAllFiles`
    if test ${var} = "TRUE"
    then
        defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
    else
        defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
    fi
}



# Path etc
source ~/.zshenv
