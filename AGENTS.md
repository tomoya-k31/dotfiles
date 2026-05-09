# AGENTS.md

## Repo overview

GNU Stow-based dotfiles manager with full XDG Base Directory support. macOS only (Homebrew deps). No CI, no tests, no lint — it's a config repo.

## Setup and deploy

| Command | What it does |
|---------|-------------|
| `make init` | Full setup: install deps (stow, sheldon) → stow dotfiles → VS Code symlink |
| `make install` | Stow dotfiles only (deps must already be installed) |
| `make install-check` | Dry-run: preview what stow would do |
| `make unstow` | Remove all symlinks created by stow |
| `make vscode-setup` | Create VS Code settings symlink (macOS only) |

Stow packages (4): `zsh`, `bash`, `config`, `claude`. Target is `~`. Uses `--no-folding --adopt`.

## Critical constraints

- **`.zshenv` must be in `$HOME`** — it sets `ZDOTDIR=$XDG_CONFIG_HOME/zsh` before any other zsh config loads. This is why `zsh/` is a separate stow package from `config/`.
- **XDG dirs must exist before stow** — `make install-deps` creates them.
- **`.stowrc` ignores** `*.encrypted`, `.git/`, `.gitignore`, `README.md`, `LICENSE`, `.DS_Store`.
- Stow ignores are defined in `.stowrc`, not passed as CLI flags in the Makefile.

## Encrypted files (SOPS + age)

Two files are encrypted with SOPS (age key in `.sops.yaml`):
- `config/.config/git/config` — contains personal git config (signing key, user info)
- `claude/.claude/settings.json` — Claude Code settings

| Command | What it does |
|---------|-------------|
| `make decrypt` | Decrypt `.encrypted` files → plain source files |
| `make encrypt` | Encrypt changed source files → `.encrypted` files |
| `make sync` | Update gitignore + run sync script |

Encrypted files (`.encrypted` suffix) and decrypted sources are both in `.gitignore`. Only the `.encrypted` versions should be committed.

## Shell environment

- **Locale**: `en_US.UTF-8` (Japanese input supported)
- **Plugin manager**: Sheldon (`config/.config/sheldon/plugins.toml`). Most plugins use deferred loading via `zsh-defer`.
- **Custom plugins**: `config/.config/zsh/plugins/` — loaded via Sheldon's `local` plugin entry.
- **Key bindings**: `Ctrl+F,Ctrl+F` = fzf cd widget, `Option+W` = git worktree manager (requires `git-gtr` + `gum`).
- **Aliases**: `cc`/`cc-yolo`/`cc-discord` (Claude CLI), `claude-yolo`, `vi`/`vim` → `nvim`, `ls`/`la`/`ll` → `eza`.

## Tool versions

Managed by mise (`config/.config/mise/config.toml`): Go, Java, Node, Python, Ruby, plus gcloud/uv/pnpm/bun.

## Directory ownership

| Path | Purpose |
|------|---------|
| `zsh/` | `.zshenv` only (must land in `$HOME`) |
| `bash/` | `.bash_profile`, `.bashrc` |
| `config/.config/` | All XDG config files (zshrc, git, tmux, starship, sheldon, mise, editors, etc.) |
| `claude/.claude/` | Claude Code settings (encrypted) |
| `scripts/` | Encryption, sync, and utility scripts |
| `.worktrees/` | Git worktree runner directory (configured in git config) |

## Adding new tools or config

1. **New tool**: Add to `config/.config/mise/config.toml`
2. **New zsh plugin**: Add to `config/.config/sheldon/plugins.toml` (use `apply = ["defer"]` when possible)
3. **New config file**: Place under `config/.config/<tool>/`, then run `make install-check` to verify no conflicts before `make install`
4. **New stow package**: Create directory with home-relative structure, add to Makefile stow commands
