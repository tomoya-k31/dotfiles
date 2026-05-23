@RTK.md

# Interaction logging

When presenting the user with a choice (yes/no, A/B, multi-option) — **always** use the `AskUserQuestion` tool instead of writing options as plain markdown text (e.g. "1. ... / 2. ...").

**Why**: The `interaction-logger` plugin's hooks log `AskUserQuestion` questions and answers as structured JSONL (`ai_offered_options` + `user_selected_option`). Plain-text choices answered with a short reply ("2", "yes") leave the log with no context about what was chosen, making the audit trail unrecoverable.

**How to apply**: Any time the response would contain enumerated options the user is expected to pick from, route it through `AskUserQuestion`. Free-form explanations and recommendations stay as text — only the *selection* itself must be structured.


# Shell / 環境前提（XDG・mise）

ローカル環境について次は前提にしてよい（確認のための `ls` や `which` は不要）：

- OS は darwin、シェルは zsh
- XDG Base Directory に準拠している（`~/.config/`, `~/.local/share/`, `~/.cache/` が存在し利用可能）
- 言語/ツールバージョンは **mise** で管理されている（`mise exec` や `mise x` で実行可、グローバル設定は `~/.config/mise/config.toml`）
- dotfiles は GNU Stow で管理されており、`~/.zshenv` などホーム直下のドットファイルは symlink である可能性が高い

**Why**: 環境探索のための無駄なツール呼び出しを削減し、トークン消費とレイテンシを下げる。`asdf` や `nvm` ではなく `mise` であることを毎回確認させない。

**How to apply**: 設定ファイルを探す際はまず `~/.config/<tool>/` を見る。Node/Python/Go などの言語ツールを呼ぶ場合は mise 管理前提で良い。dotfile を編集する場合は symlink 先（`~/Workspace/github/tomoya-k31/dotfiles/` 以下）を直接編集する。
