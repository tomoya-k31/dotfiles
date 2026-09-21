# <ボード名> — <用途>

<!-- このファイルを references/<ボード名>.md に写して埋める。private.md が記入例。
     private.md と _template.md 以外は .gitignore 済み（dotfiles は public）。
     足したら dotfiles で stow を掛け直す（--no-folding なのでファイル単位の symlink が要る）。 -->

## GitHub Project の場合

- アカウント: `<gh の login>`（`gh auth status` で確認）
- GitHub Project: `<owner>` の `<user|org>` project **<番号>**
- 起票先 repo: `<owner>/<repo>`（複数なら選び方も書く）
- issue template: `.github/ISSUE_TEMPLATE/` の有無と、あれば踏襲する見出し

### Type

SKILL.md の Type ごとに埋める。label は GitHub 既定の `bug` / `enhancement` / `documentation` から。

| Type | Status | label | assignee |
|---|---|---|---|
| `feature` | `<option>` | `<label>` | |
| `bug` | `<option>` | `<label>` | |
| `refactor` | `<option>` |  | |
| `docs` | `<option>` | `<label>` | |
| `investigation` | `<option>` |  | |
| `ops` | `<option>` |  | |
| `incident` | `<option>` | `<label>` | |
| `deps` | `<option>` |  | |
| `security` | `<option>` |  | |
| `ci` | `<option>` |  | |

### Case

Type 表より優先する。

| Case | When | Status | assignee |
|---|---|---|---|
| `existing-pr` | A PR already exists (e.g. renovate); add the PR itself, no issue | `<option>` | `@me` |

```bash
url=$(gh issue create --repo <owner>/<repo> --title "<title>" [--label <label>] [--assignee @me] --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-gh-project.sh <owner> <番号> "$url" "<Status>" [<Status 欄の名前>]
# existing-pr は issue を作らず "<PR URL>" をそのまま渡す
```

Status 欄の名前が `Status` でなければ 5 つ目の引数で渡す。選択肢名は emoji と空白まで一致させる
（一覧: `gh project field-list <番号> --owner <owner>`）。

## Notion の場合

Notion MCP で読み書きする。

- データベース: `<URL か ID>`
- タイトルのプロパティ名: `<名前>`
- ステータスのプロパティ名: `<名前>`（種類: status / select）

### Type

| Type | Status | Other properties |
|---|---|---|
| `feature` | `<option>` | |
| `bug` | `<option>` | |
| `refactor` | `<option>` | |
| `docs` | `<option>` | |
| `investigation` | `<option>` | |
| `ops` | `<option>` | |
| `incident` | `<option>` | |
| `deps` | `<option>` | |
| `security` | `<option>` | |
| `ci` | `<option>` | |

### Case

| Case | When | Status | Other properties |
|---|---|---|---|
| `existing-pr` | A PR already exists but no task (e.g. renovate) | `<option>` | `<property for the PR link; otherwise put it in the body>` |

選択肢名は emoji と空白まで一致させる（データベースを MCP で取得するとスキーマが見られる）。
