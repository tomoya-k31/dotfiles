# dotfiles

This repository is used to manage my dotfiles using GNU Stow, with support for XDG Base Directory specification.

## Installation

1. Install GNU Stow / Sheldon using Homebrew:
    ```sh
    brew install stow
    brew install sheldon
    ```

2. Clone this repository:
    ```sh
    git clone https://github.com/tomoya-k31/dotfiles.git
    cd dotfiles
    ```

3. Stow the dotfiles:
    ```sh
    # Create necessary XDG directories first
    mkdir -p $HOME/.config/ $HOME/.cache/ $HOME/.local/share/ $HOME/.local/state/
    
    # First stow zsh to get .zshenv in place
    stow -t ~ --no-folding zsh bash config aws
    ```

### Directory Structure

```
dotfiles/
├── bash/
│   ├── .bash_profile
│   └── .bashrc
├── zsh/
│   ├── .zshenv
├── aws/
│   ├── .aws/
│       └── config
├── config/
│   └── .config/
│       ├── nvim/
│       ├── git/
│       └── other XDG configs...
└── README.md
```

## XDG Base Directory Support

This dotfile setup enforces the XDG Base Directory specification:

- `$XDG_CONFIG_HOME`: `~/.config`
- `$XDG_DATA_HOME`: `~/.local/share`
- `$XDG_STATE_HOME`: `~/.local/state`
- `$XDG_CACHE_HOME`: `~/.cache`

## Special Notes

- `.zshenv` must be placed in your home directory to set `ZDOTDIR` before other zsh config files are loaded.
- The zsh configuration is split: `.zshenv` in $HOME and other files in `$ZDOTDIR` ($HOME/.config/zsh).

