g Private dotfiles

## Preparation

- [brew](https://brew.sh/)

```sh
brew install git zsh tmux bat tmuxinator vim neovim wget
```

```
xz binutils coreutils findutils gawk jq peco toilet direnv gnu-sed watch tree fd git-secrets ansible
```

- Change shell

```sh
chsh -s /usr/local/bin/zsh
```

- install [Starship](https://starship.rs/)

```sh
curl -fsSL https://starship.rs/install.sh | bash
```

```sh
mkdir -p ~/.config
```

- install Hack font (patched nerdfonts)
  https://www.nerdfonts.com/font-downloads

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

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

- install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

```sh
git clone https://github.com/tmux-plugins/tpm ${XDG_CONFIG_HOME}/tmux/plugins/tpm
```

- install tmux plugin

```sh
# Updated Xcode lastest.
brew install reattach-to-user-namespace

# tmuxinator completion
wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O /usr/local/share/zsh/site-functions/_tmuxinator
```

## setup dotfiles

```sh
git clone git@github.com:tomoya-k31/dotfiles-private.git ~/.dotfiles-private
git clone git@github.com:tomoya-k31/dotfiles.git ~/.dotfiles

# シンボリックリンク
cd $HOME/.dotfiles
./install.sh

source ~/.zshrc
./alacritty/install.sh
./starship/install.sh
./tmux/install.sh
./fd/install.sh
./nvim/install.sh

cd $HOME/.dotfiles-private
./tmuxinator/install.sh
./git/install.sh
```

## iTerm2

Preferences -> Profiles -> Report Terminal Type [xterm-256color]

Color theme [参照](https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Neutron.itermcolors)

## Others

- iTerm color theme

https://iterm2colorschemes.com/

- pokemonsay

```sh
brew tap possatti/possatti
brew install pokemonsay
```

## Troubleshooting

- [WARN] zsh compinit: insecure directories, run compaudit for list.

```
compaudit | xargs chmod g-w,o-w
```

## Changelog

- 21/1/7
  `fd` `neovim` の追加

- [Git 2.27~の git pull 時の warning 抑制](https://qiita.com/tearoom6/items/0237080aaf2ad46b1963)

```sh
git config --global pull.rebase false
```

- tmux 3.1b から設定ファイルが XDG Base Directory 対応のため以下削除

```sh
rm -f ~/.tmux.conf
rm -rf ~/.tmux
```
