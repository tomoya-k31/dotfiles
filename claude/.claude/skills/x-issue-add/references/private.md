# private — 個人用

GitHub、アカウントは `tomoya-k31`。GitHub Project は user project **6**。

起票先は `tomoya-k31` の repo。内容から選び、決められなければ聞く（PR なら PR の repo）。

| 内容 | Status | label | assignee |
|---|---|---|---|
| アイデア・新機能 | `📥 Inbox` | `enhancement` | |
| 不具合 | `📥 Inbox` | `bug` | |
| もう決まっている作業 | `🤖 Building` | | |
| 既存の PR | `📋 Ready` | | `@me` |

`🤖 Building` に入れると **totsuka がそのまま実装を始める**。手順が書けていないものは入れず、
迷ったら `📥 Inbox`。

```bash
url=$(gh issue create --repo tomoya-k31/<repo> --title "<title>" [--label <label>] [--assignee @me] --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-project.sh tomoya-k31 6 "$url" "<Status>"
```

Status は emoji と半角スペースまで一致させる（一覧: `gh project field-list 6 --owner tomoya-k31`）。
