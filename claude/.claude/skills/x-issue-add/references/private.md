# private — 個人用

GitHub、アカウントは `tomoya-k31`。GitHub Project は user project **6**。

起票先は `tomoya-k31` の repo。内容から選び、決められなければ聞く（PR なら PR の repo）。

## Type

| Type | Status | label | assignee |
|---|---|---|---|
| `feature` | `📋 Ready` | `enhancement` | @me |
| `bug` | `📋 Ready` | `bug` | @me |
| `refactor` | `📋 Ready` |  | @me |
| `docs` | `📋 Ready` | `documentation` | @me |
| `investigation` | `📋 Ready` |  | @me |
| `ops` | `📋 Ready` |  | @me |
| `incident` | `📋 Ready` | `bug` | @me |
| `deps` | `📋 Ready` |  | @me |
| `security` | `📋 Ready` |  | @me |
| `ci` | `📋 Ready` |  | @me |

## Case

Type 表より優先する。

| Case | When | Status | assignee |
|---|---|---|---|
| `existing-pr` | A PR already exists but no issue / task (e.g. renovate) | `📋 Ready` | `@me` |
| `planned` | Steps are already written; an agent can start right away | `🤖 Building` | |

```bash
url=$(gh issue create --repo tomoya-k31/<repo> --title "<title>" [--label <label>] [--assignee @me] --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-gh-project.sh tomoya-k31 6 "$url" "<Status>"
```

Status は emoji と半角スペースまで一致させる（一覧: `gh project field-list 6 --owner tomoya-k31`）。
