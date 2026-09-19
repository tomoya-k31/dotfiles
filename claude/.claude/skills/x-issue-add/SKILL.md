---
name: x-issue-add
description: "アイデア・不具合・やるべき作業、または既にある PR（renovate など）を、GitHub Project か Notion のタスクとして書き留める。/x-issue-add <宛先> <内容 or PR URL>。宛先は private / personal / light / etc。"
disable-model-invocation: true
arguments: [project]
---

# タスクを書き留める

    /x-issue-add private <内容>
    /x-issue-add private https://github.com/tomoya-k31/zenn-blog/pull/59

宛先は `$project`（最初の引数）。残りが内容。内容が空なら直前の会話から拾う。

宛先の定義（GitHub か Notion か、board / データベース、起票先 repo、Status と label）は
`~/.claude/skills/x-issue-add/references/$project.md` にある。宛先が無い、またはファイルが無い
ときは `references/` のファイル名を見せて聞く。**勝手に別の宛先へ起票しない** — 他チームの
ボードに入った issue は、消す手間も気まずさも大きい。

宛先の候補: `private`（個人用、GitHub）、`personal`（仕事用・個人）、`light`（仕事用・チーム、Notion）
など。ファイルが無い宛先はこの PC では未設定。

## 気軽さを守る

目的は「ネタを増やす」こと。1 行のアイデアを長文にしない。書いていない背景を想像で埋めず、
分からないことは「未確定」と一言残して先へ進む。調査や設計は起票後の工程の仕事で、ここで
時間をかけると次のネタが書かれなくなる。PR を渡されたときも同じで、追加対応が要るかの調査は
ここではしない。

目安: アイデアは 3 行。不具合は再現手順と期待した動き。

## 手順

1. **`references/$project.md` を読む。** GitHub か Notion か、Status などはそこから引く。
2. **内容がどれか見分ける。** 定義ファイルの表のどの行に当たるかを決める。
   - アイデア・新機能 — まだ何も決まっていない
   - 不具合 — 再現手順と期待した動き
   - もう決まっている作業 — 手順が書け、エージェントがそのまま着手できる
   - **既存の PR**（内容が `https://github.com/<owner>/<repo>/pull/<n>`） — renovate のように
     タスクより先に PR ができたもの。`gh pr view <url>` でタイトルと変更の要点だけ拾い、
     本文は PR へのリンクと 1〜2 行にする
3. **宛先の種類に応じて起票する**（下の「GitHub Project」「Notion」）。タイトルは
   `type(scope): 説明`（Conventional Commits。PR なら PR のタイトルをそのまま使ってよい）。
4. **Status を読み返す。** 作っただけで Status が空・選択肢名が 1 文字違って入らない、という
   失敗が実際に起きる。期待した値でなければ直してから終える。
5. 作った issue / ページの URL を返す。

## GitHub Project

1. 起票先 repo を決め（PR ならその PR の repo）、issue template を見る（下の「issue template」）。
   repo に `.claude/rules/` があれば本文の書き方はそれに従う。
2. `gh issue create` で起票する。
3. `~/.claude/skills/x-issue-add/scripts/add-to-project.sh` でボードに載せる。item-add・Status
   設定・読み返しをまとめてやり、期待した Status が読めなければ非 0 で終わる。

## Notion

Notion MCP を使う（スクリプトは GitHub 専用）。

1. 定義ファイルのデータベースに、MCP のページ作成でページを作る。プロパティ名と選択肢名は
   定義ファイルのとおりに渡す。PR ならページ本文か URL プロパティに PR のリンクを入れる。
2. 作ったページを MCP で取得し直し、Status プロパティが期待した値か確かめる（手順 4）。
   プロパティ名や選択肢名が分からなくなったら、データベースを MCP で取得してスキーマを見る。

## issue template

`gh issue create --body-file` は template を通らない。template がある repo では、その形を本文で
再現する。

- `.github/ISSUE_TEMPLATE/*.yml`（フォーム型） — `body` の各 `label` を `## 見出し` にして同じ順に
  並べる。`required: true` の項目は空にしない。`labels:` があればその label も付ける
- `.github/ISSUE_TEMPLATE/*.md` — 見出しをそのまま使う

新しい宛先を足すときは `references/_template.md` を写して埋める。
