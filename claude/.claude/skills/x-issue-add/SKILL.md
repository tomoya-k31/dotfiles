---
name: x-issue-add
description: "アイデア・不具合・やるべき作業、または既にある PR（renovate など）を、GitHub Project か Notion のタスクとして書き留める。/x-issue-add <ボード> <内容 or PR URL>。ボードは private / personal / light / etc。"
arguments: [board]
---

# タスクを書き留める

    /x-issue-add private <内容>
    /x-issue-add private https://github.com/tomoya-k31/zenn-blog/pull/59

ボードは `$board`（最初の引数）。残りが内容。内容が空なら直前の会話から拾う。

ボードの定義（GitHub Project か Notion データベースか、起票先 repo、Status と label）は
`~/.claude/skills/x-issue-add/references/$board.md` にある。ボードの指定が無い、またはファイルが
無いときは `references/` のファイル名を見せて聞く。**勝手に別のボードへ起票しない** — 他チームの
ボードに入った issue は、消す手間も気まずさも大きい。

ボードの候補: `private`（個人用、GitHub）、`personal`（仕事用・個人）、`light`（仕事用・チーム、Notion）
など。ファイルが無いボードはこの PC では未設定。

## 気軽さを守る

目的は「ネタを増やす」こと。1 行のアイデアを長文にしない。書いていない背景を想像で埋めず、
分からないことは「未確定」と一言残して先へ進む。調査や設計は起票後の工程の仕事で、ここで
時間をかけると次のネタが書かれなくなる。PR を渡されたときも同じで、追加対応が要るかの調査は
ここではしない。

目安: アイデアは 3 行。不具合は再現手順と期待した動き。

## Type

内容を 1 つの Type に分ける。Type ごとの Status・label・assignee は `references/$board.md` にある。

| Group | Type | Examples | Title type |
|---|---|---|---|
| Development | `feature` | New feature, UX improvement, idea | `feat` |
| | `bug` | Wrong behavior (write repro steps and expected behavior) | `fix` |
| | `refactor` | No behavior change: restructuring, performance, tests | `refactor` / `perf` / `test` |
| | `docs` | README, design notes, runbooks | `docs` |
| | `investigation` | Deliverable is a conclusion, not code (write the question and done-criteria) | `chore` |
| Operations | `ops` | Data fix, permission grant, config change, user inquiry | `chore` |
| | `incident` | Recurrence prevention after an outage, postmortem | `fix` / `docs` |
| Maintenance | `deps` | Dependency / runtime / EOL update | `chore(deps)` / `build` |
| | `security` | CVE, Dependabot alert, secret / certificate rotation | `fix` / `chore` |
| | `ci` | CI breakage, workflow fix, infra cost review | `ci` / `chore` |

## Case

Type とは別に、状況が `references/$board.md` の Case 表に当てはまれば、Status と assignee は
Case 表を優先する（label は Type のまま）。例: renovate の PR が既にあるなら Type `deps`、
Case `existing-pr`。

PR の URL（`https://github.com/<owner or organization>/<repo>/pull/<n>`）を渡されたときは
**issue を作らず、PR そのものをボードに載せる**（GitHub Project は PR を item にできる）。
`gh pr view <url>` は Type を決めるためにタイトルを見る程度でよい。

## 手順

1. **`references/$board.md` を読む。** GitHub か Notion か、Type / Case 表はそこにある。
2. **Type と Case を決め、Status・label・assignee を表から引く。**
3. **ボードの種類に応じて起票する**（下の「GitHub Project」「Notion」）。タイトルは
   `type(scope): 説明`（Conventional Commits。PR なら PR のタイトルをそのまま使ってよい）。
4. **Status を読み返す。** 作っただけで Status が空・選択肢名が 1 文字違って入らない、という
   失敗が実際に起きる。期待した値でなければ直してから終える。
5. 作った issue / ページ（PR ならボードに載せた PR）の URL を返す。

## GitHub Project

PR の URL を渡されたときは 1・2 を飛ばし、PR の URL をそのまま 3 に渡す。

1. 起票先 repo を決め、issue template を見る（下の「issue template」）。
   repo に `.claude/rules/` があれば本文の書き方はそれに従う。
2. `gh issue create` で起票する。表の label がその repo に無ければ付けずに起票する（label は作らない）。
3. `~/.claude/skills/x-issue-add/scripts/add-to-gh-project.sh` でボードに載せる。item-add・Status
   設定・読み返しをまとめてやり、期待した Status が読めなければ非 0 で終わる。

## Notion

Notion MCP を使う（スクリプトは GitHub 専用）。

1. 定義ファイルのデータベースに、MCP のページ作成でページを作る。プロパティ名と選択肢名は
   定義ファイルのとおりに渡す。PR ならページ本文か URL プロパティに PR のリンクを入れる。
2. 作ったページを MCP で取得し直し、Status プロパティが期待した値か確かめる（手順 4）。
   プロパティ名や選択肢名が分からなくなったら、データベースを MCP で取得してスキーマを見る。

## Github issue template

`gh issue create --body-file` は template を通らない。template がある repo では、その形を本文で
再現する。

- `.github/ISSUE_TEMPLATE/*.yml`（フォーム型） — `body` の各 `label` を `## 見出し` にして同じ順に
  並べる。`required: true` の項目は空にしない。`labels:` があればその label も付ける
- `.github/ISSUE_TEMPLATE/*.md` — 見出しをそのまま使う

新しいボードを足すときは `references/_template.md` を写して埋める。
