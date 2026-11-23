
# 1Password: agent shells have no TTY, so route op through the service-account
# wrapper (~/.claude/bin/op) instead of re-prompting the desktop app every call.
[[ -n "$CLAUDECODE" ]] && export PATH="$HOME/.claude/bin:$PATH"
