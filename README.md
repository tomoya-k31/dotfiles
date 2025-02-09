g Private dotfiles

## Preparation

#### Font

- install Cica font (patched nerdfonts)

```
git clone https://github.com/miiton/Cica.git
cd Cica
docker-compose build ; docker-compose run --rm cica  # ./dist/ に出力される
```

- install Hack font (patched nerdfonts)
  https://www.nerdfonts.com/font-downloads

#### Alacritty (for Apple Silicon)

```sh
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Build Alacritty
mkdir -p ~/Workspace/app
cd ~/Workspace/app
git clone https://github.com/alacritty/alacritty
cd alacritty
make app
cp -r target/release/osx/Alacritty.app /Applications/
```

#### Terminal

- [brew](https://brew.sh/)

```sh
brew install git zsh tmux bat tmuxinator vim neovim wget exa zoxide
```

```
xz binutils coreutils findutils gawk jq peco toilet direnv gnu-sed watch tree fd git-secrets ansible
```

- Change shell

```sh
chsh -s /opt/homebrew/bin/zsh
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

```
# Zinit (https://github.com/zdharma-continuum/zinit#install)
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

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

# tmuxinator completion(brewでtmuxinatorインストール済みなら不要)
wget https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh -O $(brew --prefix)/share/zsh/site-functions/_tmuxinator
```

#### Installing plugins

1. Add new plugin to `~/.tmux.conf` with `set -g @plugin '...'`
2. Press `prefix + I` (capital i, as in Install) to fetch the plugin.

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
./zed/install.sh

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
