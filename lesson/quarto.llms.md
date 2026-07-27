# Appendix B — Quarto

Code

## B.1 Quarto とは

[![](../static/img/quarto/quarto-flow.svg)](../static/img/quarto/quarto-flow.svg)

Quartoはプログラミングコードを含んだレポートやスライドを作成するためのツールです. これによって, 研究者が再現可能なドキュメントを簡単に作成できるようになっています. Quartoは, `.qmd` という拡張子のファイルにあるコードを実行し, Markdown (`.md`) 形式のドキュメントを生成します. さらに, [pandoc](https://pandoc.org) というツールを使って, HTMLやPDF, Microsoft Word, Typstなどの様々な形式に変換することができます.

## B.2 Markdown 記法

コードの実行については後の章で説明しますが, まずはMarkdown記法について簡単に説明します.

### Heading (見出し)

**Input**

    # Heading 1

    ## Heading 2

    ### Heading 3

**Output**

# Heading 1

## Heading 2

### Heading 3

`#` の個数で見出しのレベルが決まります. HTMLのルールとして, `h1` はそのページのタイトルに使うことが推奨されているため, 通常は `h2` 以降を見出しとして使います. Quartoの場合は, 後に紹介するYAMLフロントマターで指定したタイトルが `h1` として扱われるため, 基本的には `h2` 以降を使ってください.[^1]

### 改行とパラグラフ

アカデミックな文章では, 改行は段落の区切りを意味します. Markdownでは, パラグラフを明示的に区切るために, 空行を入れる必要があります. 逆に, markdown上で改行しているだけでは, 出力上では改行されません.

**Input**

    吾輩は猫である.
    名前はまだない.

    どこで生れたかとんと見当がつかぬ.

**Output**

吾輩は猫である. 名前はまだない.

どこで生れたかとんと見当がつかぬ.

### 強調

Markdownでは必要最小限の以下の三つの装飾が用意されています.

**Input**

    **太字** か __太字__ と書きます.

    *斜体* か _斜体_ と書きます.

    ***太字かつ斜体*** か ___太字かつ斜体___

    ~~打ち消し線~~ はあまり使いません.

**Output**

**太字** か **太字** と書きます.

*斜体* か *斜体* と書きます.

***太字かつ斜体*** か ***太字かつ斜体***

~~打ち消し線~~ はあまり使いません.

### リンク

**Input**

    [Google](https://google.com) へのリンク

**Output**

[Google](https://google.com) へのリンク

### 箇条書き

番号付きでないものは `-` や `*` を使って箇条書きにできます. ネストも可能です.

**Input**

    - 項目1
    - 項目2
        - 項目2.1
        - 項目2.2
    - 項目3

**Output**

- 項目1
- 項目2
  - 項目2.1
  - 項目2.2
- 項目3

番号つきのものは, 数字を使います. なお, 全ての行で `1.` と書いても, 出力上では正しい番号になります.

**Input**

    1. 項目1
    1. 項目2
        1. 項目2.1
        1. 項目2.2
    1. 項目3

**Output**

1.  項目1
2.  項目2
    1.  項目2.1
    2.  項目2.2
3.  項目3

### 図の挿入

**Input**

    ![図のタイトル](path/to/image.png)

**Output**

[![図のタイトル](../static/img/quarto/hokusai_kanagawa.jpg)](../static/img/quarto/hokusai_kanagawa.jpg "図のタイトル")

図のタイトル

ここでパスという概念が重要になります. Quartoでは, ドキュメントのルートディレクトリを基準にして画像ファイルを指定します. 基本的には, `.qmd` ファイルと同じ階層に `img` というフォルダを作り, そこに画像ファイルを入れるのが一般的です. 例えば, `report.qmd` と同じ階層に `img/hokusai_kanagawa.jpg` というファイルがある場合は, `![図のタイトル](img/hokusai_kanagawa.jpg)` と書くことで画像を挿入できます.

### 表の挿入

**Input**

    | Default | Left | Right | Center |
    |---------|:-----|------:|:------:|
    | 12      | 12   |    12 |   12   |
    | 123     | 123  |   123 |  123   |

    : 表のタイトル

**Output**

| Default | Left | Right | Center |
|---------|:-----|------:|:------:|
| 12      | 12   |    12 |   12   |
| 123     | 123  |   123 |  123   |

表のタイトル {.caption-top .table}

Markdownでは, `|` と `-` を使って表を作ることができます. さらに, `:` を使うことで, 列の位置を指定することもできます. デフォルトでは, 列は全て左寄せになりますが, `:---` と書くと左寄せ, `---:` と書くと右寄せ, `:---:` と書くと中央寄せになります. GUIツールで表を作ってmarkdwon形式でエクスポートするサービスとして, [Tables Generator](https://www.tablesgenerator.com/markdown_tables) などがあります.

## B.3 \\\LaTeX\\ Math 記法

Markdownでは \\\LaTeX\\ という組版ソフトの数式記法を使って数式を表現することができます. 数式は, `$...$` で囲むとインライン数式, `$$...$$` で囲むとブロック数式 (改行して中央揃え) になります.

**Input**

    $e^{i\pi} + 1 = 0$ は最も美しい数式だ.

**Output**

\\e^{i\pi} + 1 = 0\\ は最も美しい数式だ.

## Input

    ラマヌジャンの円周率公式は次の通り:

    $$
    \frac{1}{\pi}=\frac{2 \sqrt{2}}{99^2}
    \sum_{n=0}^{\infty} \frac{(4 n)!}{(n!)^4}
    \frac{26390 n+1103}{396^{4 n}}
    $$

## Output

ラマヌジャンの円周率公式は次の通り:

\\ \frac{1}{\pi}=\frac{2 \sqrt{2}}{99^2} \sum\_{n=0}^{\infty} \frac{(4 n)!}{(n!)^4} \frac{26390 n+1103}{396^{4 n}} \\

## B.4 Quarto 記法

ここからは Quarto独自の記法についての説明です. 引用と文献情報については [文献と引用](../lesson/literature.llms.md) の章で説明します.

### Front Matter

``` yaml
---
title: タイトル
author: 著者名
date: 2026-04-01
format: typst
---

ここから本文
```

Quartoのドキュメントでは, 冒頭に `---` で囲まれたYAML形式のフロントマターを置くことができます. ここには, ドキュメントのタイトルや著者名, 日付などのメタデータを記述することができます. また, `format` というフィールドで, 出力形式を指定することもできます. 例えば, `format: typst` と書くと, Typst形式で出力されるようになります.

### 相互参照 (Cross Reference)

スライドでは必須ではありませんが, レポートなどを書く場合は, 図表番号や節番号を自動で管理できると便利です. Quartoでは, `fig-xxxx`, `tbl-xxx`, `sec-xxx` などの特別なラベルを貼ることで, それらの番号を自動で管理することができます.

## Input

    ![神奈川沖浪裏](img/hokusai_kanagawa.jpg){#fig-kanagawa}

    @fig-kanagawa は葛飾北斎の有名な浮世絵である.

## Output

[![](../static/img/quarto/hokusai_kanagawa.jpg)](../static/img/quarto/hokusai_kanagawa.jpg "Figure B.1: 神奈川沖浪裏")

Figure B.1: 神奈川沖浪裏

[Figure fig-kanagawa](#fig-kanagawa) は葛飾北斎の有名な浮世絵である.

## Input

    | fruit  | price  |
    |--------|--------|
    | apple  | 2.05   |
    | pear   | 1.37   |
    | orange | 3.09   |

    : Fruit prices {#tbl-fruit}

    @tbl-fruit は果物の値段を表している.

## Output

| fruit  | price |
|--------|-------|
| apple  | 2.05  |
| pear   | 1.37  |
| orange | 3.09  |

Table B.1: Fruit prices

[Table tbl-fruit](#tbl-fruit) は果物の値段を表している.

基本的には, 特別な prefix (`fig-`, `tbl-`, `sec-` など) をつけたラベルを `{#label}` という形式で指定し, 本文中では `@label` と書くことで, その要素の番号を自動で参照することができます. その他の要素 (式や命題など) も同様の方法で参照できるので [Quartoのドキュメント](https://quarto.org/docs/authoring/cross-references.html) を参照してください.

## B.5 コードの実行

Quartoの最大の特徴は, ドキュメントの中にコードを埋め込んで実行できることです. コードは, ```` ```{r} ```` で始まり ```` ``` ```` で終わる コードチャンク (code chunk) の中に書きます. コンパイルのたびにQuartoがそのコードを実行し, コードと結果をドキュメントに挿入します.[^2]

```` markdown
```{r}
1 + 1
```
````

    ## [1] 2

チャンクの冒頭にある `#|` で始まる行は, チャンクオプション (chunk option) です. YAML形式で, そのチャンクの挙動を細かく制御します. 例えば次のチャンクには `label` と `eval` の2つのオプションが付いています.

```` markdown
```{r}
#| label: install-example
#| eval: false
install.packages("ggplot2")
```
````

`eval: false` を指定しているので, このコードは表示されるだけで実行されません. `install.packages()` のように, コンパイルのたびに走らせたくないコードを載せるときに便利です. 実際, 上のチャンクには結果が表示されていないことを確かめてください. よく使うオプションは次の通りです.

- `label`: チャンクにつける名前. 後述の相互参照で使います.
- `echo`: コード自体を出力に表示するか (`true` / `false`). 結果だけ見せたいときは `false` にします.
- `eval`: コードを実行するか. `false` にすると, 上の例のように, コードは表示されるだけで実行されません.
- `include`: コードも結果も出力に含めるか. `false` にすると, 実行はされますが何も表示されません (パッケージの読み込みなど, 裏方の処理に使います).
- `warning` / `message`: 警告やメッセージを表示するか.

## B.6 コードと相互参照

前の「相互参照」の節では, 手で書いた画像やMarkdownの表に番号を振りました. コードが生成する図や表にも, 同じ仕組みがそのまま使えます.

### `ggplot2` による図

コードで生成する図には, チャンクオプションの `#| label:` を `fig-` で始め, `#| fig-cap:` でキャプションを付けます. 図そのものに `{#...}` を付ける必要はありません.

```` markdown
```{r}
#| label: fig-penguins
#| fig-cap: "くちばしの長さとひれの長さの関係"
penguins |>
  ggplot(aes(x = flipper_len, y = bill_len, color = species)) +
  geom_point() +
  labs(
    x = "Flipper length (mm)",
    y = "Bill length (mm)",
    color = "Species"
  )
```
````

[![](quarto_files/figure-html/fig-penguins-1.svg)](quarto_files/figure-html/fig-penguins-1.svg "Figure B.2: くちばしの長さとひれの長さの関係")

Figure B.2: くちばしの長さとひれの長さの関係

本文で `@fig-penguins` と書くと [Figure fig-penguins](#fig-penguins) のように参照できます. 図番号は出現順に自動で振られるので, 図を増やしたり順番を入れ替えたりしても番号がずれません.

### `tinytable` による表

表も同様に, チャンクラベルを `tbl-` で始め, `#| tbl-cap:` でキャプションを付けます. `tinytable` では `tt(caption = ...)` よりも, このチャンクオプションを使う方が相互参照が確実に効きます.

```` markdown
```{r}
#| label: tbl-penguins
#| tbl-cap: "ペンギンの種類ごとの平均値"
penguins |>
  summarize(
    bill_len = mean(bill_len, na.rm = TRUE),
    flipper_len = mean(flipper_len, na.rm = TRUE),
    .by = species
  ) |>
  tt()
```
````

| species   | bill_len | flipper_len |
|-----------|----------|-------------|
| Adelie    | 38.79139 | 189.9536    |
| Gentoo    | 47.50488 | 217.1870    |
| Chinstrap | 48.83382 | 195.8235    |

Table B.2: ペンギンの種類ごとの平均値

本文で `@tbl-penguins` と書くと [Table tbl-penguins](#tbl-penguins) のように参照できます.

## B.7 インラインコード

文章の途中に計算結果を埋め込みたいときは, インラインコード (inline code) を使います. バッククォートの中で `r` に続けて式を書くと, コンパイル時にその評価結果が文章に挿入されます.

**Input**

    円周率はおよそ `r round(pi, 2)` です.

**Output**

円周率はおよそ 3.14 です.

数値を直接書く代わりにインラインコードで書いておくと, データが変わっても本文中の数値が自動で更新されます. 例えば「ペンギンのサンプルサイズは 344 である」のように書いておけば, データを差し替えたときに数値が追従するので, 書き間違いや更新漏れを防げます.

## 演習問題

この章の演習は, 実際に小さな `.qmd` を書きながら進めます. VSCode か RStudio で `report.qmd` という新しいファイルを作り, 各問題の指示にそって少しずつ書き足していきましょう. 一区切りごとにレンダリングして, 意図した見た目になっているかを確認してください. レンダリングは, RStudio や VSCode の Render ボタンを押すか, ターミナルで `quarto render report.qmd` を実行します. 解答例は畳んであるので, 開く前にまず自分で書いてみましょう.

まず, ドキュメントの骨組みを作ります. `report.qmd` の冒頭に, タイトル・著者名・日付を持つ YAML フロントマターを書き, 出力形式を HTML に指定してください. その下に見出しを1つと短い段落を1つ書いて, HTML にレンダリングしてみましょう.

> **TIP:**
>
>     ---
>     title: ペンギンデータの分析
>     author: 山田太郎
>     date: 2026-04-01
>     format: html
>     ---
>
>     ## はじめに
>
>     このレポートでは, Palmer ペンギンのデータを分析します.
>
> `format: html` の代わりに `format: pdf` や `format: typst` と書けば, 同じ原稿から別の形式で出力できます. タイトルはフロントマターの `title` が `h1` として扱われるので, 本文の見出しは `##` (h2) から始めます.

次に, Markdown 記法の練習です. さきほどの段落に続けて, 太字とリンクを1つずつ含む文と, 3項目の箇条書きを書いてください. 箇条書きのうち1項目は, さらにネストした子項目を持たせてみましょう.

> **TIP:**
>
>     このデータは [Palmer Station LTER](https://pallter.marine.rutgers.edu/) が収集した **実データ** です. 次の3種のペンギンが含まれます.
>
>     - Adelie
>     - Chinstrap
>     - Gentoo
>         - Biscoe 島でのみ観測されます
>
> 太字は `**...**`, リンクは `[表示テキスト](URL)` でした. ネストは, 親項目の下でスペース4つ分字下げします.

コードが生成する図に, 番号を振って相互参照します. `penguins` データで, くちばしの長さとひれの長さの散布図を描くコードチャンクを追加してください. チャンクラベルを `fig-` で始め, `fig-cap` でキャプションを付け, 本文から `@` で参照しましょう.

> **TIP:**
>
> チャンクの冒頭 (`setup` チャンクなど) で `library(dplyr)` と `library(ggplot2)` を読み込んでおきます. そのうえで, 次のチャンクを本文に追加します.
>
> ```` markdown
> ```{r}
> #| label: fig-penguins-scatter
> #| fig-cap: "くちばしの長さとひれの長さの関係"
> penguins |>
>   ggplot(aes(x = flipper_len, y = bill_len, color = species)) +
>   geom_point() +
>   labs(
>     x = "Flipper length (mm)",
>     y = "Bill length (mm)",
>     color = "Species"
>   )
> ```
> ````
>
> 本文には「散布図を `@fig-penguins-scatter` に示します.」のように書きます. ラベルを `fig-` で始めるのが約束で, 図番号は出現順に自動で振られます.

最後に, 集計表とインラインコードを足します. 種ごとの平均値を `tinytable` で表にし, `tbl-` ラベルを付けて相互参照してください. さらに, サンプルサイズを本文にインラインコードで埋め込みましょう.

> **TIP:**
>
> `setup` チャンクで `library(tinytable)` も読み込んでおき, 次のチャンクを追加します.
>
> ```` markdown
> ```{r}
> #| label: tbl-penguins-mean
> #| tbl-cap: "種ごとの平均値"
> penguins |>
>   summarize(
>     bill_len = mean(bill_len, na.rm = TRUE),
>     flipper_len = mean(flipper_len, na.rm = TRUE),
>     .by = species
>   ) |>
>   tt()
> ```
> ````
>
> 本文には次のように書きます.
>
>     種ごとの平均値を @tbl-penguins-mean にまとめました. 分析に使ったサンプルサイズは 344 です.
>
> 表番号も `tbl-` ラベルで自動管理され, インラインコードの `344` はレンダリング時に実際の行数へ置き換わります. データを差し替えても, 図・表・本文中の数値がすべて自動で追従します.

[^1]: 論文の場合は, `h1` を節ごとに使うこともありますが, その場合はQuartoが`##` を `h1` に自動で変換するため, 基本的には `##` 以降を見出しとして使うと覚えておくと良いでしょう.

[^2]: ここでは `{r}` と書いてR言語を使っていますが, `{python}` や `{julia}` に変えれば, それぞれの言語のコードも実行できます. 一つのドキュメントの中で複数の言語を混在させることも可能です.
