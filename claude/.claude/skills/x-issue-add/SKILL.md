---
name: x-issue-add
description: 思いついたこと・不具合・やるべき作業を GitHub Project か Notion のタスクとして書き留める。/x-issue-add に続けて宛先（private / personal / mikasa / gesoten / light）と内容を渡す。トリガー: 「issue にして」「起票して」「タスクにして」「メモっておいて」「アイデアがある」「あとでやる」、および会話の中で「これはやったほうがいい」と決まったとき。totsuka はタスクが無いと動かないので、迷ったらこのスキルで書き留めておく。
---

# タスクを書き留める

`$ARGUMENTS` の最初の語が宛先、残りが内容。

    /x-issue-add private  <内容>
    /x-issue-add mikasa   <内容>

内容が空なら直前の会話から拾う。宛先が無い、または下の一覧に無い語なら、一覧を見せて聞く。
**勝手に private と決めない** — 他チームのボードに入った issue は、消す手間も気まずさも大きい。

## 気軽さを守る

このスキルの目的は「ネタを増やす」こと。**1 行の思いつきを長文にしない。** 書いていない背景を
想像で埋めない。分からないことは「未確定」と一言残して先へ進む。詳しく調べるのは後の工程
（totsuka の設計・実装）の仕事で、ここで時間をかけると次のネタが書かれなくなる。

目安: 思いつきは 3 行。不具合は再現手順と期待した動き。

## 手順

1. **内容がどれか見分ける**
   - 思いつき・新機能 — まだ何も決まっていない
   - 不具合 — 再現手順と期待した動きを書く
   - もう決まっている作業 — 手順が書ける。エージェントがそのまま着手できる
2. **宛先の節を読む**（下）。起票先・label・初期ステータスがそこにある
3. **起票先 repo の issue template を見る**（下の「issue template」）
4. **起票する。** タイトルは `type(scope): 説明`（Conventional Commits）。repo に `.claude/rules/`
   があれば、本文の書き方はそれに従う
5. **ボードに載せて初期ステータスを入れ、読み返す。** `scripts/add-to-project.sh` がまとめてやる。
   載っただけでステータスが入っていない、という失敗が実際に起きるので、読み返しを飛ばさない

## issue template

`gh issue create` は template を通らない（`--body-file` で本文を直接渡すため）。template がある
repo では、その形を本文側で再現する。

- `.github/ISSUE_TEMPLATE/*.yml`（フォーム型） — `body` の各 `label` を `## 見出し` にして同じ順に
  並べる。`required: true` の項目は空にしない。`labels:` があればその label を付ける
- `.github/ISSUE_TEMPLATE/*.md` — 見出しをそのまま使う
- `config.yml` の `blank_issues_enabled: false` は Web UI だけの制約で、`gh` からは通る

例: totsuka の `feature_request.yml` は `Problem` / `Proposed solution` の 2 項目で
`labels: [enhancement]`。本文は `## Problem` と `## Proposed solution` の 2 節になる。

## 宛先

### private — 個人用

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

### personal — 仕事用（個人）

未設定。この宛先はまだ使えない。使えるようにするには、GitHub Project の owner と番号、ステータス欄
の名前と選択肢、起票先 repo、label の決め方をこの節に書く。gh のアカウントは private と同じ
`tomoya-k31` で届く。

### mikasa — 仕事用（チーム mikasa）

未設定。personal と同じ項目を書けば使える。

### gesoten — 仕事用（チーム gesoten）

未設定。personal と同じ項目を書けば使える。

### light — 仕事用（チーム light、Notion）

未設定。Notion のデータベース ID、ステータスのプロパティ名と選択肢をこの節に書く。
`ntn`（Notion CLI）はインストール済みで、トークンは `ntn auth token --plain` で取れる
（`ntn auth` は公開ドキュメントに載っていないので `ntn auth --help` が一次資料）。
