@RTK.md

# Interaction logging

When presenting the user with a choice (yes/no, A/B, multi-option) — **always** use the `AskUserQuestion` tool instead of writing options as plain markdown text (e.g. "1. ... / 2. ...").

**Why**: The `interaction-logger` plugin's hooks log `AskUserQuestion` questions and answers as structured JSONL (`ai_offered_options` + `user_selected_option`). Plain-text choices answered with a short reply ("2", "yes") leave the log with no context about what was chosen, making the audit trail unrecoverable.

**How to apply**: Any time the response would contain enumerated options the user is expected to pick from, route it through `AskUserQuestion`. Free-form explanations and recommendations stay as text — only the *selection* itself must be structured.


# Shell / 環境前提（XDG・mise）

ローカル環境について次は前提にしてよい（確認のための `ls` や `which` は不要）：

- OS は darwin、シェルは zsh
- XDG Base Directory に準拠している（`~/.config/`, `~/.local/share/`, `~/.cache/` が存在し利用可能）
- 言語/ツールバージョンは **mise** で管理されている（グローバル設定は `~/.config/mise/config.toml`）。`.zshenv` で `mise activate` 済みなので、エージェントの非インタラクティブシェルでも素の `node` / `bun` / `pnpm` 等が cwd ベースで mise 管理版に解決される（`mise x --` プレフィックスは不要）
- dotfiles は GNU Stow で管理されており、`~/.zshenv` などホーム直下のドットファイルは symlink である可能性が高い

**Why**: 環境探索のための無駄なツール呼び出しを削減し、トークン消費とレイテンシを下げる。`asdf` や `nvm` ではなく `mise` であることを毎回確認させない。

**How to apply**: 設定ファイルを探す際はまず `~/.config/<tool>/` を見る。Node/Python/Go などの言語ツールを呼ぶ場合は mise 管理前提で良い。dotfile を編集する場合は symlink 先（`~/Workspace/github/tomoya-k31/dotfiles/` 以下）を直接編集する。





# Shell / 環境前提（XDG・mise・Stow）

## 実行シェルの前提（重要）
- ユーザーの対話シェルは zsh。エージェントがコマンドを実行するシェルは非インタラクティブだが、
  zsh は非インタラクティブでも **`.zshenv` を必ず読む**。その `.zshenv` で `mise activate` 済みなので、
  素の `node` / `python` / `go` / `bun` / `pnpm` 等が **そのまま mise 管理版に解決される**（`mise x --` プレフィックスは不要）。
  注意: `.zshrc` の alias・関数はインタラクティブ専用なので、これらは依然読み込まれない前提でよい。
- 各 Bash 呼び出しは新規シェルが cwd で `.zshenv` を読み直すため、**コマンドの開始 cwd ごとに正しいプロジェクト版へ自動切り替え**される。
- 例外: `mise activate` の解決はシェル起動時（フック）依存なので、**1 つのコマンド内で `cd` して別バージョンのプロジェクトへ移っても切り替わらない**。
  跨ぐ必要があるときは、対象ディレクトリで別 Bash 呼び出しにするか、その箇所だけ `mise x -- <cmd>` を使う。
- `mise.toml` の `[env]` 変数も同じくフック解決依存。env が必要な作業を跨ぎ `cd` で行う場合は `mise x --` を使う。
- `mise` バイナリ自体は PATH 上にある前提でよい（確認のための `which mise` は不要）。

## OS / ディレクトリ
- OS は darwin。
- XDG Base Directory 準拠（`~/.config/`, `~/.local/share/`, `~/.cache/`, `~/.local/state/` が利用可能）。

## mise（バージョン管理）
- 言語/ツールバージョンは mise 管理。`asdf` / `nvm` ではない（毎回の確認不要）。
- 実行は基本そのまま素のコマンドでよい（`.zshenv` の `mise activate` が cwd ベースで解決）。明示的に別バージョンを当てたいときだけ `mise x node@22 -- node ...` のように `mise x -- <cmd>` を使う。
- **設定はディレクトリ単位**。mise は cwd から親方向へ辿って設定を発見・マージし、cwd に近いものを優先：
  - グローバル: `~/.config/mise/config.toml`
  - プロジェクト: 各ディレクトリの `mise.toml` / `.mise.toml`（git 管理外の上書きは `mise.local.toml`）
- プロジェクト版を使うときは対象ディレクトリで実行する（cwd で解決されるため。ホームから叩くと global 版）。1 コマンド内で `cd` して跨ぐ場合だけ `mise x -- ...` を併用。
- インストール実体: `~/.local/share/mise/installs/<tool>/<version>/`、shims: `~/.local/share/mise/shims/`。
- trust: グローバル設定は自動 trust。プロジェクト設定は **未 trust だと読み込まれず警告**（ローカル版が効かず global に化ける典型原因）。未 trust 設定を勝手に `mise trust` せず、内容を確認しユーザー確認を取る。
- プロジェクトのバージョン設定を新規作成する場合、まず `git rev-parse --show-toplevel` で
  **git リポジトリのルート** を特定し、そこに `mise.toml` が無ければ作成する（サブディレクトリや $HOME に散らさない）。
- git 管理外で repo ルートを特定できない場合は、親を勝手に遡らず cwd を使うかユーザーに確認する。

### Node のパッケージマネージャ（pnpm / yarn）
- **corepack は使わず、mise で直接管理する。** `mise.toml` の `[tools]` に `pnpm = "<version>"`（必要なら`yarn = "<version>"`）を記載し `mise install`。pnpm/yarn は mise が PATH に供給する。
- corepack を有効化する postinstall フック（`corepack enable` 等）は追加しない。
  理由: mise と corepack で shim が二重化し競合するため／corepack は Node 25 以降同梱されなくなるため。
- `package.json` の `packageManager` フィールドはドキュメント/ヒントとして残してよいが、`mise.toml` の pnpm バージョンと一致させる。
- pnpm も素の `pnpm ...` でよい（cwd で解決）。


## dotfiles（GNU Stow）
- dotfiles は GNU Stow 管理。`~/.zshenv` などホーム直下、および `~/.config/` 配下のファイルは symlink の可能性が高い。
- dotfile を編集する場合、実体は repo（`~/Workspace/github/tomoya-k31/dotfiles/` 配下、Stow パッケージのサブディレクトリにネスト）にある。**パスを推測で組み立てず、対象ファイルのみ `readlink -f`（または `realpath`）で実体を解決してから repo 側を編集する**（これはピンポイント確認なので可）。
- 新規 dotfile を足す場合はホーム直下に直接作らず、repo 側に置いて再 stow する（symlink を壊さないため）。

**Why**: 環境探索のための無駄なツール呼び出しを削減し、トークン消費とレイテンシを下げる。加えて、非インタラクティブ実行・ディレクトリ単位設定・trust・Stow symlink という「ハマりどころ」を先回りし、バージョン取り違えや symlink 破壊を防ぐ。

**How to apply**:
- 設定を探すときはまず cwd 近傍の `mise.toml` / `.mise.toml`、なければ `~/.config/<tool>/`。
- 言語ツールは素のコマンドでよい（`.zshenv` の `mise activate` が cwd で解決）。プロジェクト版は対象ディレクトリで実行。1 コマンド内で `cd` 跨ぎ、または `[env]` 変数が要る場合だけ `mise x -- ...`。
- dotfile 編集は対象を `readlink -f` で解決してから repo 側の実体を編集。
- 不可逆操作（`mise trust`、symlink 差し替え、グローバル設定変更等）はユーザー確認を取る。


# GitHub Actions ワークフローファイル

**How to apply**: `.github/workflows/` 配下のワークフローファイルを新規作成・変更する際は、作業前に必ず `~/.claude/rules/github-action-sha.md` を読み込み、そこに書かれている SHA ピン留め・フォーマット規約に従うこと（新規作成かどうかに関わらず）。
