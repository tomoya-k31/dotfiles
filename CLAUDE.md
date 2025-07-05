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

## アーキテクチャと構成

### ディレクトリ構造
- `zsh/`: ホームディレクトリ配置用（.zshenv）
- `bash/`: Bash設定ファイル
- `config/`: XDG準拠設定ファイル群（.config/以下）
- `aws/`: AWS CLI設定

### シェル環境の構成
- **XDG Base Directory仕様**: すべての設定ファイルが適切なXDGディレクトリに配置
- **ロケール設定**: UTF-8/英語環境（日本語入力対応）
- **プラグイン管理**: Sheldonによる遅延ロード対応
- **履歴管理**: hishtoryとfzfの統合、クロスデバイス同期対応

### 主要ツールの統合
- **mise**: 言語バージョン管理（Go 1.23, Node.js 23, Python 3.12）
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

## メンテナンス時の注意点

1. `.zshenv`は必ずホームディレクトリに配置（ZDOTDIR設定のため）
2. XDGディレクトリが存在することを確認してからstow実行
3. 新しいツール追加時はmise設定ファイルの更新を検討
4. プラグイン追加時はSheldon設定を更新し遅延ロードを活用
