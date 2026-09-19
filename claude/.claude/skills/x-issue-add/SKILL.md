---
name: x-issue-add
description: "思いつき・不具合・やるべき作業、または既にある PR（renovate など）を、GitHub Project か Notion のタスクとして書き留める。/x-issue-add <宛先> <内容 or PR URL>。宛先は private / personal / mikasa / gesoten / light。"
disable-model-invocation: true
arguments: [project]
---

# タスクを書き留める

    /x-issue-add private <内容>
    /x-issue-add private https://github.com/tomoya-k31/zenn-blog/pull/59

宛先は `$project`（最初の引数）。残りが内容。内容が空なら直前の会話から拾う。

宛先の定義（GitHub か Notion か、board、起票先 repo、Status と label）は
`~/.claude/skills/x-issue-add/references/$project.md` にある。宛先が無い、またはファイルが無い
ときは `references/` のファイル名を見せて聞く。**勝手に別の宛先へ起票しない** — 他チームの
ボードに入った issue は、消す手間も気まずさも大きい。

宛先の候補: `private`（個人用）、`personal`（仕事用・個人）、`mikasa` / `gesoten`
（仕事用・チーム、GitHub）、`light`（仕事用・チーム、Notion）。ファイルが無い宛先はこの PC では未設定。

## 気軽さを守る

目的は「ネタを増やす」こと。1 行の思いつきを長文にしない。書いていない背景を想像で埋めず、
分からないことは「未確定」と一言残して先へ進む。調査や設計は起票後の工程の仕事で、ここで
時間をかけると次のネタが書かれなくなる。PR を渡されたときも同じで、追加対応が要るかの調査は
ここではしない。

目安: 思いつきは 3 行。不具合は再現手順と期待した動き。

## 手順

1. **`references/$project.md` を読む。**
2. **内容がどれか見分ける。** Status と label は定義ファイルの表から引く。
   - 思いつき・新機能 — まだ何も決まっていない
   - 不具合 — 再現手順と期待した動き
   - もう決まっている作業 — 手順が書け、エージェントがそのまま着手できる
   - **既存の PR**（内容が `https://github.com/<owner>/<repo>/pull/<n>`） — renovate のように
     issue より先に PR ができたもの。起票先はその PR の repo。`gh pr view <url>` でタイトルと
     変更の要点だけ拾い、本文は PR へのリンクと 1〜2 行にする
3. **起票先 repo を決め、issue template を見る**（下の「issue template」）。
4. **起票する。** タイトルは `type(scope): 説明`（Conventional Commits。PR なら PR のタイトルを
   そのまま使ってよい）。repo に `.claude/rules/` があれば本文の書き方はそれに従う。
5. **ボードに載せて Status を入れる。** `~/.claude/skills/x-issue-add/scripts/add-to-project.sh`
   が item-add・Status 設定・読み返しをまとめてやる。載っただけで Status が空、という失敗が
   実際に起きるので、スクリプトが非 0 で終わったら直してから終える。
6. 作った issue の URL を返す。

## issue template

`gh issue create --body-file` は template を通らない。template がある repo では、その形を本文で
再現する。

- `.github/ISSUE_TEMPLATE/*.yml`（フォーム型） — `body` の各 `label` を `## 見出し` にして同じ順に
  並べる。`required: true` の項目は空にしない。`labels:` があればその label も付ける
- `.github/ISSUE_TEMPLATE/*.md` — 見出しをそのまま使う

新しい宛先を足すときは `references/_template.md` を写して埋める。
