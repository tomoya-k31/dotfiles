TMP_HOME="${ZDOTDIR:-$HOME}"
# 標準Zshではない場合の保険
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "$TMP_HOME/.zprofile" ]]; then
  . "$TMP_HOME/.zprofile"
fi

# Rust
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "$TMP_HOME/.cargo/env" ]]; then
  . "$TMP_HOME/.cargo/env"
fi
. "$HOME/.cargo/env"
