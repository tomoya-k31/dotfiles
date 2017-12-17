Set up
========

## install Prezto
- https://github.com/sorin-ionescu/prezto

```sh
$ cd $HOME
$ git clone https://github.com/tomoya-k31/dotfiles .dotfiles && cd $HOME/.dotfiles

## シンボリックリンクで繋ぐ
$ cd $HOME/.dotfiles
$ ./init.sh

# vimの設定
$ git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
$ vim +":NeoBundleInstall" +:q

# .zshrcに以下を追記
source $HOME/.zshrc.custom
```

## iTerm2
Preferences -> Profiles -> Report Terminal Type [xterm-256color]

Color theme [参照](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized)

## zsh
Macのlsは色が付かない。coreutilsをインストール。
その他、GNU版のコマンドツールを使うために以下をインストール。
```
$ brew install xz
$ brew install binutils
$ brew install coreutils
$ brew install findutils

# etc
wget
gawk
jq
peco
toilet
tmux
zsh
direnv
gnu-sed
watch
tree
```

- memo

```sh
$ brew list
ansible		binutils	direnv		gdbm		gnu-sed		libevent	mysql		openssl@1.1	pkg-config	rbenv		sqlite		toilet		wget
autoconf	carthage	findutils	gettext		jq		libyaml		oniguruma	pcre		python		readline	terraform	tree		xz
awscli		coreutils	gawk		gmp		libcaca		mpfr		openssl		peco		python3		ruby-build	tmux		watch		zsh
```

[themes for GNU](https://github.com/seebi/dircolors-solarized)
```sh
$ mkdir .zsh
$ cd .zsh/
$ git clone https://github.com/seebi/dircolors-solarized.git
```

[tmux color theme](https://github.com/seebi/tmux-colors-solarized)


```
source $HOME/.zshrc.custom
```


