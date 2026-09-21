# private — 個人用

GitHub、アカウントは `tomoya-k31`。GitHub Project は user project **6**。

起票先は `tomoya-k31` の repo。内容から選び、決められなければ聞く（PR なら PR の repo）。

## Type

| Type            | Status   | label           | assignee |
| --------------- | -------- | --------------- | -------- |
| `feature`       | `🤖 Spec` | `enhancement`   | @me      |
| `bug`           | `🤖 Spec` | `bug`           | @me      |
| `refactor`      | `🤖 Spec` |                 | @me      |
| `docs`          | `🤖 Spec` | `documentation` | @me      |
| `investigation` | `🤖 Spec` |                 | @me      |
| `ops`           | `🤖 Spec` |                 | @me      |
| `incident`      | `🤖 Spec` | `bug`           | @me      |
| `deps`          | `🤖 Spec` |                 | @me      |
| `security`      | `🤖 Spec` |                 | @me      |
| `ci`            | `🤖 Spec` |                 | @me      |

## Case

Type 表より優先する。

| Case          | When                                                     | Status       | assignee |
| ------------- | -------------------------------------------------------- | ------------ | -------- |
| `existing-pr` | A PR already exists (e.g. renovate); add the PR itself, no issue  | `🤖 Spec`     | `@me`    |
| `planned`     | Steps are already written; an agent can start right away | `🤖 Building` |          |

```bash
url=$(gh issue create --repo tomoya-k31/<repo> --title "<title>" [--label <label>] [--assignee @me] --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-gh-project.sh tomoya-k31 6 "$url" "<Status>"

# existing-pr: issue は作らず PR を直接載せる
~/.claude/skills/x-issue-add/scripts/add-to-gh-project.sh tomoya-k31 6 "<PR URL>" "🤖 Spec"
```

Status は emoji と半角スペースまで一致させる（一覧: `gh project field-list 6 --owner tomoya-k31`）。
