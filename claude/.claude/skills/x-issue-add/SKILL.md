---
name: x-issue-add
description: "思いついたこと・不具合・やるべき作業を GitHub Project か Notion のタスクとして書き留める。/x-issue-add に続けて宛先（private / personal / mikasa / gesoten / light）と内容を渡す。トリガー: 「issue にして」「起票して」「タスクにして」「メモっておいて」「アイデアがある」「あとでやる」、および会話の中で「これはやったほうがいい」と決まったとき。totsuka はタスクが無いと動かないので、迷ったらこのスキルで書き留めておく。"
disable-model-invocation: true
arguments: [project]
---

# タスクを書き留める

宛先は `$project`（最初の引数）。内容は `$ARGUMENTS` から最初の語を除いた残り。

    /x-issue-add $project <内容>
    /x-issue-add private  <内容>

内容が空なら直前の会話から拾う。宛先が無い、または `references/` に定義ファイルが無い語なら、
あるファイル名を一覧で見せて聞く。
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
2. **`references/$project.md` を読む。** 起票先・label・初期ステータスがそこにある（下の「宛先の定義」）
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

## 宛先の定義

宛先ごとの定義（GitHub か Notion か、board の番号、起票先 repo、Status と label の対応）は
**`references/$project.md`** にある。宛先ごとにファイルを分けているのは、個人 PC と会社 PC で
定義が違うから — 同じ SKILL.md を使いながら、その PC にあるファイルだけが有効になる。

- **ファイルが無ければ、その宛先はこの PC では未設定。** `references/` にあるファイル名を
  一覧で見せて聞く。勝手に別の宛先へ起票しない
- 宛先の候補: `private`（個人用）、`personal`（仕事用・個人）、`mikasa` / `gesoten`
  （仕事用・チーム、GitHub）、`light`（仕事用・チーム、Notion）
- 新しい宛先を足すときは `references/_template.md` を写して埋める。`private.md` と
  `_template.md` 以外は `.gitignore` 済みなので、仕事用の定義は dotfiles（public）に載らない。
  足したら dotfiles で stow を掛け直す（`--no-folding` なのでファイル単位の symlink が要る）
