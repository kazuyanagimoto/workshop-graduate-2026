# 9  スライド

Code

## 9.1 技術要件

アカデミックなスライドを作る際に次のようなアプリケーションやフレームワークの選択肢があると思います.

- **GUI**: PowerPoint, Keynote, Google Slides
- **LaTeX**: Beamer
- **Typst**: Touying, Polylux
- **Markdown**: Quarto (Reveal.js), Marp, Slidev

私は, このAI時代の中では Quarto + Touying の組み合わせがもっとも効率的だと思っています. その理由を以下にまとめます.

**GUI** AIにスライドを作成させるという観点から考えるとGUIベースのアプリケーションは不利です. AIから操作することもできますが, 大量のトークンを消費してしまい非効率です. その点, LaTeXやMarkdownはテキストベースであり, AIにとって扱いやすい形式です. さらに, LaTeXやMarkdownはスライドの内容をコードとして管理できるため, バージョン管理や再利用が容易です.

**HTMLスライド** Reveal.js, Marp, Slidev などはMarkdownで作成するものの, HTMLとして出力されます. しかし, HTMLスライドはアカデミックの文化とあまり相性が良くありません. それは結局PDFの提出を求められるからです. 学会発表の場やホームページへの掲載, クラウドストレージによる事前共有など, PDFでの配布が前提となる場面は多く, HTMLスライドはそのままでは使えません.

これらのフレームワークはPDFに変換することもできますが, レイアウトが崩れてしまったり, 数式が正しく表示されなかったりするといった問題が起こりやすいです. また, スライド内のハイパーリンクが効かなくなってしまうため, 参考文献や補足資料へのリンクを貼ることができなくなります.

**Quarto** 私は, 研究の途中経過を報告する場では, Quartoを用いるのが最善だと思っています. それは, 図表の作成や数値にインラインの変数を使うことができるからです. 研究の途中経過を報告する場合, 発表の前日までデータや分析結果が変わることはよくあります. その時に, Quartoを使えば, 更新された結果が自動で反映されるスライドを作ることが可能です.

**Touying** QuartoでPDFスライドを作る場合, Official では Beamer がサポートされています. しかし, Beamer はコンパイルが遅く, カスタマイズ性も低いです.[^1] Touying は Typst でスライドを作るためのフレームワークであり, Beamer とほぼ同等の機能を持ちながら, Typst の高速コンパイルを利用することができます.

以上を踏まえて, 私は Quarto + Touying の組み合わせでスライドを作っています. そのために以下のようなパッケージも開発しました.

[![GitHub avatar of kazuyanagimoto](https://github.com/kazuyanagimoto.png?size=120)](https://github.com/kazuyanagimoto/quarto-touying-typst)

kazuyanagimoto/quarto-touying-typst

A drop-in Quarto extension for Touying slides with selectable built-in themes

![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxNiAxNiIgd2lkdGg9IjE2IiBoZWlnaHQ9IjE2IiBmaWxsPSJjdXJyZW50Q29sb3IiIGFyaWEtaGlkZGVuPSJ0cnVlIj48cGF0aCBkPSJNOCAwYzQuNDIgMCA4IDMuNTggOCA4YTguMDEzIDguMDEzIDAgMCAxLTUuNDUgNy41OWMtLjQuMDgtLjU1LS4xNy0uNTUtLjM4IDAtLjI3LjAxLTEuMTMuMDEtMi4yIDAtLjc1LS4yNS0xLjIzLS41NC0xLjQ4IDEuNzgtLjIgMy42NS0uODggMy42NS0zLjk1IDAtLjg4LS4zMS0xLjU5LS44Mi0yLjE1LjA4LS4yLjM2LTEuMDItLjA4LTIuMTIgMCAwLS42Ny0uMjItMi4yLjgyLS42NC0uMTgtMS4zMi0uMjctMi0uMjctLjY4IDAtMS4zNi4wOS0yIC4yNy0xLjUzLTEuMDMtMi4yLS44Mi0yLjItLjgyLS40NCAxLjEtLjE2IDEuOTItLjA4IDIuMTItLjUxLjU2LS44MiAxLjI4LS44MiAyLjE1IDAgMy4wNiAxLjg2IDMuNzUgMy42NCAzLjk1LS4yMy4yLS40NC41NS0uNTEgMS4wNy0uNDYuMjEtMS42MS41NS0yLjMzLS42Ni0uMTUtLjI0LS42LS44My0xLjIzLS44Mi0uNjcuMDEtLjI3LjM4LjAxLjUzLjM0LjE5LjczLjkuODIgMS4xMy4xNi40NS42OCAxLjMxIDIuNjkuOTQgMCAuNjcuMDEgMS4zLjAxIDEuNDkgMCAuMjEtLjE1LjQ1LS41NS4zOEE3Ljk5NSA3Ljk5NSAwIDAgMSAwIDhjMC00LjQyIDMuNTgtOCA4LThaIiAvPjwvc3ZnPg==) GitHub Typst ★ 1

もちろん, 共著のプロジェクトでは Beamer を使わないといけない場合もありますが…

## 9.2 アンチパターン

経済学の発表を聞いていると, いくつか典型的なアンチパターンがあることに気づきます. ここでは, それらを紹介しながら, スライドの作り方の鉄則を学びましょう.

### 不必要な要素

スライドからは聴衆の注意をそらす要素はできるだけ排除すべきです. しかし, Beamer のデフォルトの設定ではスライドの右下にナビゲーション記号を表示します. これをクリックしてスライドを操作する人はおらず, 不必要です.

[![](../static/beamer/navigation-bad-1.svg)](../static/beamer/navigation-bad-1.svg "Figure 9.1: 不必要なナビゲーション")

Figure 9.1: 不必要なナビゲーション

ナビゲーション記号は, プリアンブルに次の一行を加えれば消せます.

``` latex
\setbeamertemplate{navigation symbols}{}
```

[![](../static/beamer/navigation-good-1.svg)](../static/beamer/navigation-good-1.svg "Figure 9.2: ナビゲーションを消したスライド")

Figure 9.2: ナビゲーションを消したスライド

### 4:3 vs. 16:9

Beamerのデフォルトのアスペクト比は4:3ですが, モニターでプレゼンする機会も多くなった現代では, 16:9のスライドの方が画面をより広く使えます.

[![モニターに写した4:3のスライド](../static/cetz/aspect-pillarbox.svg)](../static/cetz/aspect-pillarbox.svg "モニターに写した4:3のスライド")

モニターに写した4:3のスライド

16:9 にするには, プリアンブルのドキュメントクラスにオプションを加えます.

``` latex
\documentclass[aspectratio=169]{beamer}
```

16:9にするメリットは画面を大きく使えるだけでなく, 改行によるデザインの崩れを防ぐこともできます. 下の例では, 4:3だと幅が足りず一文が2行に折り返されてしまいますが, 16:9なら同じ一文が1行に収まります.

[![4:3: 幅が足りず折り返される](../static/beamer/aspect-bad-1.svg)](../static/beamer/aspect-bad-1.svg "4:3: 幅が足りず折り返される")

4:3: 幅が足りず折り返される

[![16:9: 同じ一文が1行に収まる](../static/beamer/aspect-good-1.svg)](../static/beamer/aspect-good-1.svg "16:9: 同じ一文が1行に収まる")

16:9: 同じ一文が1行に収まる

### 高すぎる彩度

Warsaw や Madrid といった Beamer の定番テーマは, 彩度の高い青がヘッダーやフッター, ブロックなど画面の広い面積を占めます. 色は聴衆の注意を誘導するための手段ですが, テーマ自体が強い色を使っていると, 本来注目してほしい図や数式よりも装飾に目が行ってしまいます.

対策はシンプルで, 彩度を抑えたアクセントカラーを1色決め, それ以外は白と黒 (グレー) だけで構成することです. 下の例では, 同じ内容のスライドを Warsaw テーマと, デフォルトテーマ + 落ち着いたアクセントカラーで作っています.

[![Warsaw Theme](../static/beamer/color-bad-1.svg)](../static/beamer/color-bad-1.svg "Warsaw Theme")

Warsaw Theme

[![落ち着いた配色](../static/beamer/color-good-1.svg)](../static/beamer/color-good-1.svg "落ち着いた配色")

落ち着いた配色

右のスライドは, プリアンブルで次のように設定しています. `structure` の色を変えると, フレームタイトルや箇条書きのマーカーなどの色がまとめて変わります.

``` latex
\usetheme{default}
\definecolor{accent}{HTML}{107895}
\usecolortheme[named=accent]{structure}
\setbeamercolor{block title}{fg=accent, bg=accent!8}
\setbeamercolor{block body}{bg=accent!4}
```

### 文字サイズが小さい

図の文字の小ささは, 経済学の発表で最もよく見るアンチパターンかもしれません. ggplot2 のデフォルトの文字サイズは論文や画面上の文書を想定した 11pt で, 図をスライドに縮小して貼ると, 軸や凡例の文字はほとんど読めなくなります.

下の比較では, 同じデータの図を同じ大きさでスライドに貼っています. 左はデフォルト設定のままの ggplot2, 右は [sec-visualization](#sec-visualization) で作った図に文字サイズの指定を加えたものです.

[![デフォルト設定 (base_size = 11)](../static/beamer/fontsize-bad-1.svg)](../static/beamer/fontsize-bad-1.svg "デフォルト設定 (base_size = 11)")

デフォルト設定 (base_size = 11)

[![sec-visualization (base_size = 20)](../static/beamer/fontsize-good-1.svg)](../static/beamer/fontsize-good-1.svg "sec-visualization (base_size = 20)")

[sec-visualization](#sec-visualization) (base_size = 20)

図の文字サイズは, `theme_*()` 関数の `base_size` 引数でまとめて変えられます. 右の図はこう指定しています.

``` r
theme_minimal(base_size = 20)
```

適切な値は図の保存サイズとスライドに貼る大きさに依存しますが, 目安として, 図中の文字がスライドの本文と同じくらいの大きさに見えれば, 会場の後ろの席からも読めます.

### 囲み線

回帰表をスライドで見せるとき, 注目してほしい係数を囲み線で囲んで強調するスライドをよく見かけます. しかし囲み線は, 見てほしい情報の周りにインクを足すだけで, 見なくてよい情報はそのまま残っています. 聴衆の視線は結局, 表全体に散らばってしまいます.

強調は「足す」よりも, 注目してほしくない要素を「弱める」方が効果的です. 下の右の例では, 注目してほしい係数以外の行をグレーアウトし, 係数の行を太字にしています. 表自体が視線を誘導するので, 囲み線は不要になります.

[![囲み線による強調](../static/beamer/highlight-bad-1.svg)](../static/beamer/highlight-bad-1.svg "囲み線による強調")

囲み線による強調

[![グレーアウトと太字による強調](../static/beamer/highlight-good-1.svg)](../static/beamer/highlight-good-1.svg "グレーアウトと太字による強調")

グレーアウトと太字による強調

この表は fixest と modelsummary で作っています. `msummary()` に `output = "tinytable"` を指定すると, 返ってきた表を `tinytable` の `style_tt()` でそのまま加工できます.

``` r
library(modelsummary)
library(tinytable)

tab <- msummary(models, output = "tinytable", stars = TRUE)
tab |>
  style_tt(i = c(1:2, 5:12), color = "#8f8f8f") |> # gray out all other rows
  style_tt(i = 3, bold = TRUE) # bold the Education estimate
```

## 9.3 Quarto + Touying

ここからは, [quarto-touying-typst](https://github.com/kazuyanagimoto/quarto-touying-typst) を使ってスライドを作る流れを一通り見ていきます. この節で扱うのは日常的に使う機能だけです. 完全なチュートリアルは公式ドキュメントの [Tutorial](https://kazuyanagimoto.com/quarto-touying-typst/tutorial.html) に, テーマごとの実際の見た目は [Gallery](https://kazuyanagimoto.com/quarto-touying-typst/gallery.html) にあります.

### セットアップ

Quartoプロジェクトのフォルダで以下を実行すると, 拡張が `_extensions/` 以下にインストールされます.

``` sh
quarto add kazuyanagimoto/quarto-touying-typst
```

ゼロから始める場合は, サンプルスライド付きのテンプレートを使うのが手軽です.

``` sh
quarto use template kazuyanagimoto/quarto-touying-typst
```

スライドの本体は, `format: touying-typst` を指定した通常の `.qmd` ファイルです. 最小限の例を示します.

``` yaml
---
title: My Talk
subtitle: A subtitle
format: touying-typst
theme: metropolis
author:
  - name: Your Name
    affiliations: Your Institution
date: today
---
```

`quarto render slides.qmd` でPDFが生成されます. タイトルスライドは, YAMLの `title`, `subtitle`, `author`, `date` から自動で作られます.

[![上のYAMLから生成されるタイトルスライド (metropolis テーマ)](../static/touying/basics-1.svg)](../static/touying/basics-1.svg "上のYAMLから生成されるタイトルスライド (metropolis テーマ)")

上のYAMLから生成されるタイトルスライド (metropolis テーマ)

Typst のコンパイルは高速なので, `quarto preview slides.qmd` としておけば, ファイルを保存するたびにほぼ即座にプレビューが更新されます. Beamer との一番の体感差はここです.

### スライドの区切り

Reveal.js と同じく, Markdown の見出しがスライドの区切りになります.

- `#` (レベル1見出し): セクションの区切りスライド
- `##` (レベル2見出し): 通常のスライド
- 水平線 `---`: 見出しなしで新しいスライドを始める

``` markdown
# In the morning

## Getting up

- Turn off alarm
- Get out of bed

---

A follow-up slide without a heading.
```

[![\# In the morning はセクションの区切りに](../static/touying/basics-2.svg)](../static/touying/basics-2.svg "# In the morning はセクションの区切りに")

`# In the morning` はセクションの区切りに

[![\## Getting up は通常のスライドに](../static/touying/basics-3.svg)](../static/touying/basics-3.svg "## Getting up は通常のスライドに")

`## Getting up` は通常のスライドに

### 段階的な表示

Beamer の `\pause` に相当するのが, 単独の行に書く `. . .` です.

``` markdown
First this shows.

. . .

Then this appears.
```

[![1ステップ目](../static/touying/incremental-2.svg)](../static/touying/incremental-2.svg "1ステップ目")

1ステップ目

[![2ステップ目](../static/touying/incremental-3.svg)](../static/touying/incremental-3.svg "2ステップ目")

2ステップ目

箇条書きを1項目ずつ表示するには, `.incremental` で囲みます.

``` markdown
::: {.incremental}
- First
- Then second
- Then third
:::
```

[![1項目ずつ現れ…](../static/touying/incremental-4.svg)](../static/touying/incremental-4.svg "1項目ずつ現れ…")

1項目ずつ現れ…

[![最後に全項目が揃う](../static/touying/incremental-6.svg)](../static/touying/incremental-6.svg "最後に全項目が揃う")

最後に全項目が揃う

特定のサブスライドだけで表示・非表示を切り替えるような細かい制御には `.only` / `.uncover` が使えます (詳細は公式チュートリアルを参照). また, YAML に `handout: true` を加えると, 段階表示をすべて畳んだ配布用のPDFになります.

### 2段組み

図と説明を並べるときは, `.columns` を使います.

``` markdown
:::: {.columns}
::: {.column width="45%"}
Left column:

- A bullet point
- Another bullet point
:::
::: {.column width="55%"}
Right column, a little wider:

$$y_i = \beta_0 + \beta_1 x_i + \varepsilon_i$$
:::
::::
```

[![.columns による2段組み](../static/touying/columns-2.svg)](../static/touying/columns-2.svg ".columns による2段組み")

`.columns` による2段組み

### 強調

インラインの強調用に, いくつかのクラスが用意されています.

| 記法                                         | 効果                      |
|----------------------------------------------|---------------------------|
| `[text]{.alert}`                             | アクセントカラーで強調    |
| `[text]{.fg options='fill: rgb("#5D639E")'}` | 任意の色の文字            |
| `[text]{.bg}`                                | マーカー風の背景色        |
| `[[Back]{.button}](#sec-results)`            | Beamer 風のジャンプボタン |
| `[text]{.small-cite}`                        | 小さくグレーの引用表記    |

[![強調クラスの表示例](../static/touying/emphasis-2.svg)](../static/touying/emphasis-2.svg "強調クラスの表示例")

強調クラスの表示例

使い方の方針は, アンチパターンの節で見たとおりです. 色はアクセントカラーを中心に絞り, `.alert` を「そのスライドで一番見てほしい一箇所」のために取っておくと, 視線誘導がよく効きます. `.button` は, 本編のスライドから補遺の詳細スライドへ飛ぶリンク (とその逆) に使います.

### Rチャンクと図表

通常の Quarto ドキュメントと同じく, Rチャンクがそのまま実行でき, スライドではソースコードはデフォルトで非表示になります. 図の文字サイズをスライド用に大きくするのを忘れないようにしましょう.

```` markdown
```{r}
#| fig-width: 10
#| fig-height: 4.5
ggplot(penguins, aes(bill_len, bill_dep, color = species, shape = species)) +
  geom_point() +
  theme_minimal(base_size = 20)
```
````

[![Rチャンクから生成された図のスライド](../static/touying/rchunk-2.svg)](../static/touying/rchunk-2.svg "Rチャンクから生成された図のスライド")

Rチャンクから生成された図のスライド

本文中のインラインコード (`` `r ` ``) も使えるため, 推定結果の数値をスライドの文章に直接埋め込めます. データや分析が発表直前に更新されても, レンダリングし直すだけで図表と本文の数値がすべて追随します. これが冒頭で述べた, 研究報告で Quarto を使う最大の理由です. 回帰表も, アンチパターンの節で作ったような `modelsummary` + `tinytable` の表がそのまま使えます.

### テーマとカスタマイズ

見た目は `theme:` の一行で切り替えられます. 組み込みテーマは `default`, `simple`, `metropolis`, `dewdrop`, `university`, `aqua`, `stargazer` の7つです.

色とフォントは, どのテーマでもYAMLから調整できます.

``` yaml
accent: "107895"   # primary color (hex, no leading #)
accent2: "9a2515"  # secondary color
jet: "131516"      # body text color
sansfont: "Fira Sans"
```

プロジェクトに `_brand.yml` があれば, その `color` / `typography` の設定が自動で反映されます (本書のWebサイトの配色と同じ仕組みです).

組み込み以外の Touying テーマも使えます. 自作のテーマファイルでも, [Typst Universe](https://typst.app/universe) で配布されているテーマでも, `include-in-header` でテーマ関数を読み込み, `theme-typst` でその名前を指定するだけです. たとえば私が開発した clean テーマは次のように読み込みます.

``` yaml
format:
  touying-typst:
    include-in-header:
      text: |
        #import "@preview/touying-quarto-clean:0.2.0": *
    theme-typst: clean-theme
```

clean テーマは, 所属・メールアドレス・ORCID を含む構造化された著者情報をタイトルスライドに表示できます. スライド全体の見た目は [Gallery の clean のページ](https://kazuyanagimoto.com/quarto-touying-typst/gallery/clean.html) で確認できます.

[![clean テーマのタイトルスライド](../static/touying/clean-1.svg)](../static/touying/clean-1.svg "clean テーマのタイトルスライド")

clean テーマのタイトルスライド

### Appendix

発表スライドの後ろには, 質疑に備えた appendix を付けるのが通例です. `appendix` ショートコードを置くと, それ以降のスライドはページカウンタが止まり, フッターの総ページ数が本編のページ数のまま固定されます.

``` markdown
{{< appendix >}}

## Robustness Check {#sec-robustness}

Details shown only if someone asks.
```

Appendix のスライドが何十枚あっても「本編は25枚中25枚で終わり」と見えるので, 聞いている人に余計なプレッシャーを与えずに済みます.

## 演習問題

この章の演習は, `quarto-touying-typst` で実際に小さなスライドを組み立てます. 空のフォルダを1つ作り, そこを作業場所にしてください. Quarto と Typst が使える環境が必要です. 解答例は畳んであるので, まず自分で書いてみましょう.

テンプレートからスライドの雛形を作り, タイトルスライドを自分のものに差し替えます. サンプル付きのテンプレートを取得し, YAML でタイトル・サブタイトル・著者・テーマを設定して, PDF にレンダリングしてください.

> **TIP:**
>
> 作業フォルダで, サンプルスライド付きのテンプレートを取得します.
>
> ``` sh
> quarto use template kazuyanagimoto/quarto-touying-typst
> ```
>
> 生成された `.qmd` のフロントマターを, 次のように書き換えます.
>
> ``` yaml
> ---
> title: My First Touying Slides
> subtitle: 研究の進捗報告
> format: touying-typst
> theme: metropolis
> author:
>   - name: 山田太郎
>     affiliations: 神戸大学
> date: today
> ---
> ```
>
> `quarto render` で PDF を作るか, `quarto preview` で保存のたびに更新されるプレビューを開きます. タイトルスライドは YAML の `title` などから自動で作られ, `theme:` の一行を変えれば見た目が切り替わります.

中身のスライドを追加します. セクションの区切りスライドを1枚, 箇条書きを1項目ずつ表示する通常スライドを1枚, 図の代わりに数式を右に置いた2段組みスライドを1枚, それぞれ作ってください.

> **TIP:**
>
> ``` markdown
> # 背景
>
> ## リサーチクエスチョン
>
> ::: {.incremental}
> - 何を知りたいのか
> - なぜ重要なのか
> - どう答えるのか
> :::
>
> ## 推定モデル
>
> :::: {.columns}
> ::: {.column width="45%"}
> 記号の定義:
>
> - $x_i$: 処置
> - $y_i$: アウトカム
> :::
> ::: {.column width="55%"}
> $$y_i = \beta_0 + \beta_1 x_i + \varepsilon_i$$
> :::
> ::::
> ```
>
> `#` はセクションの区切りスライド, `##` は通常のスライドになります. `.incremental` で囲むと箇条書きが1項目ずつ現れ, `.columns` と `.column` で2段組みになります.

最後に, R チャンクで作った図のスライドを足します. アンチパターンの節で見た文字サイズの問題を思い出し, スライドで読める大きさに調整してください.

> **TIP:**
>
> ```` markdown
> ```{r}
> #| fig-width: 10
> #| fig-height: 4.5
> library(ggplot2)
> ggplot(penguins, aes(bill_len, bill_dep, color = species)) +
>   geom_point() +
>   theme_minimal(base_size = 20)
> ```
> ````
>
> スライドでは R チャンクがそのまま実行され, ソースコードは既定で非表示になります. 重要なのは `theme_minimal(base_size = 20)` です. ggplot2 の既定の 11pt のままスライドに縮小して貼ると, 軸や凡例の文字がほとんど読めません. 図中の文字がスライドの本文と同じくらいに見えるよう `base_size` を大きくしておくと, 会場の後ろの席からも読めます. さらに, インラインコードで推定結果の数値を本文に埋め込んでおけば, 発表直前にデータが更新されても, レンダリングし直すだけで図も数値も追随します.

[^1]: 技術的には Beamer も Touying と同じだけのカスタマイズ性があるはずですが, LaTeX 独自の知識がないとカスタマイズが難しいです. またコンパイルが遅いので, 試行錯誤するだけでも時間がかかります.
