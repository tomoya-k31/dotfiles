# private — 個人用

GitHub、アカウントは `tomoya-k31`。board は user project **6**（Cairn）。

起票先 repo は **totsuka か dotfiles**。内容から選ぶ（totsuka 本体の話なら totsuka、シェル・
エディタ・Claude Code の設定なら dotfiles）。判断がつかなければ聞く。それ以外の repo に起票すると、
ボードに載っても totsuka が拾わない。

| 内容 | Status | label |
|---|---|---|
| 思いつき・新機能 | `📥 Inbox` | `enhancement` |
| 不具合 | `📥 Inbox` | `bug` |
| もう決まっている作業 | `🤖 Building` | なし |

`🤖 Building` に入れると **totsuka がそのまま実装を始める**。手順が書けていないものを入れない。
迷ったら `📥 Inbox`。

```bash
url=$(gh issue create --repo tomoya-k31/<repo> --title "<title>" --label <label> --body-file <file>)
~/.claude/skills/x-issue-add/scripts/add-to-project.sh tomoya-k31 6 "$url" "📥 Inbox"
```

Status の文字列は emoji と半角スペースまで board の選択肢と一致させる。違っていればスクリプトが
読み返しで止める。選択肢の一覧は `gh project field-list 6 --owner tomoya-k31`。
