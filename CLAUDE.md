# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

このリポジトリは、GNU StowとXDG Base Directory仕様を使用したdotfiles管理システムです。日本のユーザー向けに設定されており、モダンなシェル環境とツールチェーンを提供します。

## セットアップコマンド

```bash
# リポジトリクローン
git clone https://github.com/tomoya-k31/dotfiles.git
cd dotfiles

# 初期化
make init
```

## Makefile の主要ターゲット

- `make init`: 初期化（install-deps → install → vscode-setup）
- `make sync`: 上流取得 + 3-way merge による衝突検出（scripts/sync.sh）
- `make encrypt` / `make decrypt`: SOPS による機密ファイルの暗号/復号
- `make install-check`: 必要ツールの存在確認

## アーキテクチャと構成

### ディレクトリ構造
- `zsh/`: ホームディレクトリ配置用（.zshenv）
- `bash/`: Bash設定ファイル
- `config/`: XDG準拠設定ファイル群（.config/以下）
- `claude/`: Claude Code 設定（SOPS暗号化済み settings.json を含む）
- `scripts/`: 暗号/復号・sync・SOPSキーセットアップ等のヘルパー

### シェル環境の構成
- **XDG Base Directory仕様**: すべての設定ファイルが適切なXDGディレクトリに配置
- **ロケール設定**: UTF-8/英語環境（日本語入力対応）
- **プラグイン管理**: Sheldonによる遅延ロード対応
- **履歴管理**: hishtoryとfzfの統合、クロスデバイス同期対応

### 主要ツールの統合
- **mise**: 言語バージョン管理（実際のバージョンは @config/.config/mise/config.toml 参照）
- **Starship**: プロンプトカスタマイズ
- **zoxide**: 高速ディレクトリナビゲーション
- **eza**: lsの高機能代替
- **bat**: catの高機能代替

## 重要な設定ファイル

- `config/.config/zsh/.zshrc`: メインのZsh設定
- `zsh/.zshenv`: 環境変数とXDG設定
- `config/.config/sheldon/plugins.toml`: プラグイン定義
- `config/.config/mise/config.toml`: 言語環境とツール管理

## カスタム機能

### 略語とエイリアス
- `claude-yolo`: Claude CLI（権限スキップ付き）
- 各種lsエイリアス（eza使用）
- Git関連略語（zsh-abbrプラグイン使用）

### fzf統合機能
- `Ctrl+F,Ctrl+F`: ディレクトリ選択とcd
- hishtoryとの統合による高度なコマンド履歴検索

## 機密ファイルの取り扱い

- `git/config`, `claude/.claude/settings.json` は **SOPS+age で暗号化済み**（`.sops.yaml` 参照）
- 復号鍵は `~/.config/sops/age/keys.txt`
- 暗号/復号は `make encrypt` / `make decrypt`（sops 直叩き禁止）
- 復号後の平文を絶対にコミットしない（`.stowrc` で `*.encrypted` を除外しているが平文ファイル名は同名のため上書きに注意）
- 1Password 連携: `claude/.claude/.env.tpl` に `op://` 参照を記述、`op run --env-file=...` で注入

## メンテナンス時の注意点

1. `.zshenv`は必ずホームディレクトリに配置（ZDOTDIR設定のため）
2. XDGディレクトリが存在することを確認してからstow実行
3. 新しいツール追加時はmise設定ファイルの更新を検討
4. プラグイン追加時はSheldon設定を更新し遅延ロードを活用

## 関連ドキュメント

- @AGENTS.md: コーディングエージェント全般向けのリポジトリ概要（本ファイルと部分的に重複）
