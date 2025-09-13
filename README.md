# dotfiles

This repository manages dotfiles using GNU Stow with full XDG Base Directory specification support.

## Quick Start

```sh
# Clone and setup everything automatically
git clone https://github.com/tomoya-k31/dotfiles.git
cd dotfiles
make init
```

## Available Commands

| Command | Description |
|---------|-------------|
| `make init` | Complete installation (dependencies + dotfiles) |
| `make install` | Install dotfiles only (requires dependencies) |
| `make install-deps` | Install required dependencies (stow, sheldon) |
| `make install-check` | Dry-run to preview stow operations |
| `make encrypt` | Encrypt sensitive files |
| `make decrypt` | Decrypt sensitive files |
| `make sync` | Sync configuration files |

## Manual Installation

If you prefer manual setup:

```sh
# 1. Install dependencies
brew install stow sheldon

# 2. Create XDG directories
mkdir -p $HOME/.config/ $HOME/.cache/ $HOME/.local/share/ $HOME/.local/state/

# 3. Deploy dotfiles
stow -t ~ --no-folding zsh bash config
```

## Directory Structure

```
dotfiles/
├── bash/
│   ├── .bash_profile
│   └── .bashrc
├── config/
│   └── .config/
│       ├── alacritty/        # Terminal emulator
│       ├── fd/               # Fast file finder
│       ├── gh-copilot/       # GitHub Copilot CLI
│       ├── git/              # Git configuration
│       ├── lazygit/          # Terminal UI for git
│       ├── mise/             # Development environment manager
│       ├── sheldon/          # Shell plugin manager
│       ├── starship/         # Cross-shell prompt
│       ├── tmux/             # Terminal multiplexer
│       ├── zed/              # Code editor
│       └── zsh/              # Zsh configuration
├── scripts/
│   ├── decrypt-files.sh      # Decrypt sensitive files
│   ├── encrypt-files.sh      # Encrypt sensitive files
│   ├── setup-sops-key.sh     # Setup SOPS encryption key
│   ├── sync.sh               # Sync configuration files
│   ├── ui-helpers.sh         # UI helper functions
│   └── update-gitignore.sh   # Update gitignore automatically
├── zsh/
│   └── .zshenv               # Zsh environment (must be in $HOME)
├── CLAUDE.md                 # AI assistant instructions
├── Makefile                  # Installation automation
└── README.md                 # This file
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

