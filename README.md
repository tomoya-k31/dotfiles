# Private dotfiles

## Preparation

- [brew](https://brew.sh/)

```sh
brew install git zsh tmux bat tmuxinator vim neovim
```

- install [Starship](https://starship.rs/)

```sh
curl -fsSL https://starship.rs/install.sh | bash
```

```sh
mkdir -p ~/.config
```

- install [oh my zsh](https://github.com/ohmyzsh/ohmyzsh)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

- install zsh plugin

```sh
# zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

- install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

- install tmux plugin

```sh
# Updated Xcode lastest.
brew install reattach-to-user-namespace
```





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

Mac の ls は色が付かない。coreutils をインストール。
その他、GNU 版のコマンドツールを使うために以下をインストール。

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
zsh
direnv
gnu-sed
watch
tree
bat
tmux
tmuxinator
```

- memo

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
