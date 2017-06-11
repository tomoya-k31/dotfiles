Set up
========

```sh
$ cd $HOME
$ git clone https://github.com/tomoya-k31/dotfiles .dotfiles && cd $HOME/.dotfiles
$ git clone https://github.com/seebi/dircolors-solarized.git
$ ln -s ~/.dotfiles/dircolors-solarized/dircolors.256dark ~/.dircolors
$ git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
$ git clone git://github.com/zsh-users/zsh-completions.git $HOME/.zsh/zsh-completions

## シンボリックリンクで繋ぐ
$ cd $HOME/.dotfiles
$ ./init.sh

# vimの設定
$ mkdir -p $HOME/.vim/bundle; cd $HOME/.vim/bundle
$ git clone git://github.com/Shougo/neobundle.vim.git
$ vim +":NeoBundleInstall" +:q
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
```

[themes for GNU](https://github.com/seebi/dircolors-solarized)
```sh
$ mkdir .zsh
$ cd .zsh/
$ git clone https://github.com/seebi/dircolors-solarized.git
```

[tmux color theme](https://github.com/seebi/tmux-colors-solarized)

## Ricty font

[参照](http://blog.forodin.com/2013/02/mac%E3%81%AB%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E7%94%A8%E3%83%95%E3%82%A9%E3%83%B3%E3%83%88-ricty%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%97/)


## Ｐｒｅｚｔｏのzshrcに以下を追記

```
source $HOME/.dotfiles/.zshrc.custom
```
