#!/usr/bin/env bash

set -euo pipefail

TPM_REPO="https://github.com/tmux-plugins/tpm.git"
TPM_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm"

if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux not found in PATH" >&2
    exit 1
fi

# tpm 本体。tmux.conf 末尾の `run '${XDG_CONFIG_HOME}/tmux/plugins/tpm/tpm'` が読む。
# plugins/ は stow 対象外（--no-folding で ~/.config/tmux は実体ディレクトリ、
# 中身のファイルだけが symlink）なので、ここで clone する。
# 既にある場合は触らない。tpm 自体の更新は `prefix + U` などで明示的に行う。
if [ ! -d "$TPM_PATH" ]; then
    echo "Cloning tpm into $TPM_PATH..."
    git clone "$TPM_REPO" "$TPM_PATH"
fi

# tpm はプラグインの clone 先を tmux のグローバル環境変数 TMUX_PLUGIN_MANAGER_PATH から
# 取得する。この変数は tmux.conf 末尾の `run '.../tpm/tpm'` が実行されて初めて設定されるため、
# tpm 導入前から起動しっぱなしのサーバーに対して実行すると
# "FATAL: Tmux Plugin Manager not configured in tmux.conf" で落ちる。
# 既存サーバーの状態に依存しないよう、専用ソケットで一時サーバーを起動し、
# そこで tmux.conf を読み直させる。
#
# ソケットパスは sockaddr_un の 104 バイト制限に収まる必要があるので /tmp 直下に作る
# （長いパスだと bind に失敗し、上と同じ FATAL に化ける）。
SOCKET_DIR="$(mktemp -d /tmp/dotfiles-tpm.XXXXXX)"

cleanup() {
    TMUX_TMPDIR="$SOCKET_DIR" tmux kill-server 2>/dev/null || true
    rm -rf "$SOCKET_DIR"
}
trap cleanup EXIT

# tmux 内から実行された場合、$TMUX があるとクライアントが親サーバーのソケットを
# 参照してしまい TMUX_TMPDIR が無視されるため落としておく。
unset TMUX
export TMUX_TMPDIR="$SOCKET_DIR"

echo "Installing tmux plugins..."
"$TPM_PATH/bin/install_plugins"

echo "Done. Reload your running tmux with 'prefix + I' or ':source-file' to pick them up."
