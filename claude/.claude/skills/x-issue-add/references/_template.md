# <宛先名> — <用途>

<!-- このファイルを references/<宛先名>.md に写して埋める。private.md が記入例。
     private.md と _template.md 以外は .gitignore 済み（dotfiles は public）。
     足したら dotfiles で stow を掛け直す（--no-folding なのでファイル単位の symlink が要る）。 -->

## GitHub Project の場合

- アカウント: `<gh の login>`（`gh auth status` で確認）
- board: `<owner>` の `<user|org>` project **<番号>**
- 起票先 repo: `<owner>/<repo>`（複数なら選び方も書く）
- issue template: `.github/ISSUE_TEMPLATE/` の有無と、あれば踏襲する見出し

| 内容 | Status | label | assignee |
|---|---|---|---|
| アイデア・新機能 | `<選択肢名>` | `<label>` | |
| 不具合 | `<選択肢名>` | `<label>` | |
| もう決まっている作業 | `<選択肢名>` | | |
| 既存の PR | `<選択肢名>` | | `@me` |

```bash
url=$(gh issue create --repo <owner>/<repo> --title "<title>" [--label <label>] [--assignee @me] --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-project.sh <owner> <番号> "$url" "<Status>" [<Status 欄の名前>]
```

Status 欄の名前が `Status` でなければ 5 つ目の引数で渡す。選択肢名は emoji と空白まで一致させる
（一覧: `gh project field-list <番号> --owner <owner>`）。

## Notion の場合

Notion MCP で読み書きする。

- データベース: `<URL か ID>`
- タイトルのプロパティ名: `<名前>`
- ステータスのプロパティ名: `<名前>`（種類: status / select）

| 内容 | ステータス | その他のプロパティ |
|---|---|---|
| アイデア・新機能 | `<選択肢名>` | |
| 不具合 | `<選択肢名>` | |
| もう決まっている作業 | `<選択肢名>` | |
| 既存の PR | `<選択肢名>` | `<PR リンクを入れるプロパティ。無ければ本文に書く>` |

選択肢名は emoji と空白まで一致させる（データベースを MCP で取得するとスキーマが見られる）。
