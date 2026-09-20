#!/bin/sh
# PreToolUse(Bash): allow git push, but guard pushes straight to the
# repository's default branch (origin/HEAD, falling back to main/master).
# Source of truth = GitHub branch protection: protected branch -> deny
# (PR 運用のリポジトリ), unprotected -> allow. 判定できなければ ask。
set -u

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
case "$cmd" in
*git*push*) ;;
*) exit 0 ;;
esac

cd "$(printf '%s' "$input" | jq -r '.cwd // "."')" 2>/dev/null || exit 0

# `git -C <dir> push` / `cd <dir> && ... git push` は cwd ではなくそちらを見る
dir=$(printf '%s' "$cmd" | sed -n 's|.*git[[:space:]][[:space:]]*-C[[:space:]][[:space:]]*\([^[:space:]]*\).*|\1|p' | head -1)
[ -n "$dir" ] || dir=$(printf '%s' "$cmd" | sed -n 's|^[[:space:]]*cd[[:space:]][[:space:]]*\([^&;|]*\).*|\1|p' | head -1)
dir=$(printf '%s' "$dir" | sed 's|[[:space:]]*$||; s|^"\(.*\)"$|\1|; s|^'"'"'\(.*\)'"'"'$|\1|')
case "$dir" in "~"*) dir="$HOME${dir#\~}" ;; esac
[ -z "$dir" ] || cd "$dir" 2>/dev/null || exit 0

decide() { # <allow|deny|ask> <reason>
	[ "$1" = allow ] && exit 0
	printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
	exit 0
}

branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
if [ -z "$branch" ]; then
	if git rev-parse --quiet --verify main >/dev/null 2>&1; then
		branch=main
	else
		branch=master
	fi
fi

# explicit refspec wins (git push [flags] <remote> <refspec>), else current branch
target=$(printf '%s' "$cmd" | awk '
	/git[[:space:]]+(-[^ ]+[[:space:]]+)*push/ {
		for (i = 1; i <= NF; i++) if ($i == "push") { start = i + 1; break }
		n = 0
		for (i = start; i <= NF; i++) {
			if ($i ~ /^-/) continue
			if ($i == "&&" || $i == "||" || $i == ";" || $i == "|") break
			n++; arg[n] = $i
		}
		if (n >= 2) print arg[n]
		exit
	}')
target=${target##*:}
[ -n "$target" ] || target=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

[ "$target" = "$branch" ] || exit 0

url=$(git remote get-url origin 2>/dev/null)
slug=$(printf '%s' "${url%.git}" | sed -n 's|.*github\.com[:/]||p')
[ -n "$slug" ] || decide ask "$branch への直 push です (GitHub 以外のリモート: ${url:-none})"
command -v gh >/dev/null 2>&1 || decide ask "$branch への直 push です (gh が無く保護状態を確認できません)"

rules=$(gh api "repos/$slug/rules/branches/$branch" --jq 'length' 2>/dev/null)
case "${rules:-x}" in
0) ;;
[1-9]*) decide deny "$slug の $branch はルールセットで保護されています。ブランチを切って PR にしてください。" ;;
*) decide ask "$branch への直 push です ($slug の保護状態を確認できませんでした)" ;;
esac

case "$(gh api "repos/$slug/branches/$branch" --jq .protected 2>/dev/null)" in
true) decide deny "$slug の $branch はブランチ保護されています。ブランチを切って PR にしてください。" ;;
false) decide allow ;;
*) decide ask "$branch への直 push です ($slug の保護状態を確認できませんでした)" ;;
esac
