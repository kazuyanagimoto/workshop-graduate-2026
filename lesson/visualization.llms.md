# 8  可視化の技術

Code

この章では, データ可視化に関するいくつかのTipsを紹介します. しかし, これらのテクニックは次の一つの原則に基づいているに過ぎません.

> **TIP:**
>
> 図は主張をもち, その主張を最短時間で伝えられるようにデザインされなければならない.

これから紹介するテクニックは図の見た目を改善するためのものですが, それらは単に最短時間で図の主張を伝えるために手段であると言うことを忘れないでください.

``` r
library(dplyr)
library(ggplot2)
```

## 8.1 最少の要素

最短時間で図を伝えるためには, 過剰な情報を削ぎ落とすことが重要です. これを表した Tufte ([2001](#ref-tufte2001)) の有名な原則があります.

> **TIP:**
>
> 図においては次のデータインク比を最大化しなければならない:
>
> \\ \text{データインク比} := \frac{\text{データインク}}{\text{図に使用されたインクの総量}}. \\

ここでいうデータインクとは, 図の中でデータを表すために使われているインクの量のことであり, 基本的には図を構成するために最低限必要な要素のことを指します. ここから, 次のような規則も見出すことができます:

> **TIP:**
>
> 削除しても図の主張を損なわない要素は削除しなければならない.

この原則を, R に標準で付属する `penguins` データセットで確かめてみましょう. ここではペンギンの種 (`species`) ごとに, 性別 (`sex`) 別の個体数を数えた棒グラフを描きます. まずは何の工夫もしていない, デフォルトのグラフです.

``` r
penguins_bar <- penguins |>
  filter(!is.na(sex))

penguins_bar |>
  ggplot(aes(x = species, fill = sex)) +
  geom_bar(position = "dodge")
```

[![](visualization_files/figure-html/plot-penguins-bar-default-1.svg)](visualization_files/figure-html/plot-penguins-bar-default-1.svg)

このグラフには

- グレーの背景
- 縦横のグリッド線
- 自明な軸ラベル

など, データを表していないインクが多く含まれています. データインク比の原則に従って, これらの要素を削ぎ落とします.

``` r
penguins_bar |>
  ggplot(aes(x = species, fill = sex)) +
  geom_bar(position = "dodge") +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()
  )
```

[![](visualization_files/figure-html/plot-penguins-bar-minimal-1.svg)](visualization_files/figure-html/plot-penguins-bar-minimal-1.svg)

さらに可読性を高めるために, 棒を横向きにして凡例をパネル内の空白に移します. 横向きにするとカテゴリ名が水平に並ぶので, ラベルが長くなっても読みやすくなります. また, 凡例をパネル内の空白に移すことで, グラフ全体のバランスが良くなります.

``` r
penguins_bar |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.15),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))
```

[![](visualization_files/figure-html/plot-penguins-bar-flip-1.svg)](visualization_files/figure-html/plot-penguins-bar-flip-1.svg)

なお, 横向きに変えたことに伴って見づらくなってしまった点があるので

- `forcats::fct_rev()` 関数を使ってカテゴリの順番を逆にしています
- `guides(fill = guide_legend(reverse = TRUE))` を使って, 凡例の順番も逆にしています

## 8.2 色の選び方

色の選択は重要なテーマで様々な理論がありますが, ここでは深入りせずに用意されているカラーパレットを紹介します. 色彩論に関する簡単な解説は [sec-color](#sec-color) を参照してください.

### R Color Brewer’s Palettes

現代的なカラーパレット集として有名な [Color Brewer](https://colorbrewer2.org/) のパッケージとして, RColorBrewerが提供されています.

[![](https://r-graph-gallery.com/38-rcolorbrewers-palettes_files/figure-html/thecode-1.png)](https://r-graph-gallery.com/38-rcolorbrewers-palettes_files/figure-html/thecode-1.png)

``` r
penguins_bar |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.15),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))
```

[![](visualization_files/figure-html/plot-color-brewer-1.svg)](visualization_files/figure-html/plot-color-brewer-1.svg)

### カラー・セーフティ: Okabe-Ito パレット

色選択の一つの方針として, 色覚異常の人でも見分けやすい色を使う, という考え方があります. カラー・セーフティなパレットとして提案された中でも有名なカラーパレットがOkabe-Itoカラーパレットです.

``` r
penguins_bar |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  see::scale_fill_okabeito() +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.15),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))
```

[![](visualization_files/figure-html/plot-okabe-ito-1.svg)](visualization_files/figure-html/plot-okabe-ito-1.svg)

### MetBrewer パレット

[MetBrewer](https://github.com/BlakeRMills/MetBrewer) は, アメリカのメトロポリタン美術館のコレクションからインスピレーションを得たカラーパレットを提供するパッケージです.

``` r
# install.packages("MetBrewer")
library(MetBrewer)
```

ここでは, 赤・青・緑・橙がはっきり見分けられる Egypt のパレットを使ってみましょう.

[![](https://github.com/BlakeRMills/MetBrewer/blob/main/PaletteImages/Egypt.png?raw=true)](https://github.com/BlakeRMills/MetBrewer/blob/main/PaletteImages/Egypt.png?raw=true)

``` r
penguins_bar |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  scale_fill_manual(values = met.brewer("Egypt")) +
  theme_minimal() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.15),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))
```

[![](visualization_files/figure-html/plot-metbrewer-1.svg)](visualization_files/figure-html/plot-metbrewer-1.svg)

### alpha の活用

alpha は色の透明度 (opacity) を指定するパラメータで, 彩度とは別物です. それでも白い背景の上では, alpha を下げると色が淡くなるので, ひとつの色相の中に順序をつける道具として使えます. 具体的には, グループの違い (ここでは男女) を色相で, グループ内の順序 (正規 → 非正規 → 非就業) を alpha で表す, という二段構えです. こうすると各パネルは1色でまとまり, 凡例も中立的なグレーになります ([Figure fig-alpha-status](#fig-alpha-status)).

``` r
emp <- targets::tar_read(employment_status, store = here::here("_targets")) |>
  filter(status != "other_employed") |> # keep regular / non-regular / not in work
  mutate(
    sex = recode(sex, male = "Men", female = "Women"),
    status = recode(
      status,
      regular = "Regular",
      nonregular = "Non-regular",
      not_employed = "Not in work"
    ),
    status = factor(
      status,
      levels = c("Regular", "Non-regular", "Not in work")
    ),
    age_group = factor(
      age_group,
      levels = c("25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "Total")
    )
  )

ggplot(emp, aes(x = age_group, y = n, fill = sex, alpha = status)) +
  geom_col(position = position_fill(reverse = TRUE), width = 0.85) +
  facet_wrap(~sex) +
  scale_fill_manual(
    values = c(Men = "#217a6b", Women = "#8a4a9e"),
    guide = "none"
  ) +
  scale_alpha_manual(
    values = c("Regular" = 1, "Non-regular" = 0.55, "Not in work" = 0.25),
    name = NULL
  ) +
  scale_y_continuous(
    labels = scales::label_percent(),
    expand = expansion(c(0, 0.02))
  ) +
  labs(x = NULL, y = NULL) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(size = 8),
    legend.position = "bottom",
    strip.text = element_text(face = "bold", size = 13)
  )
```

[![](visualization_files/figure-html/fig-alpha-status-1.svg)](visualization_files/figure-html/fig-alpha-status-1.svg "Figure 8.1: 男女・年齢別にみた就業状態の構成")

Figure 8.1: 男女・年齢別にみた就業状態の構成

データは就業構造基本調査 (令和4年) の全国・総数で, 各年齢層の正規・非正規・非就業の構成比です (自営業主・会社役員などは除いています). 男性はほとんどが正規, 女性は年齢とともに非正規と非就業が増えるという違いが, 色相 (男女) と alpha (状態) の重ねがけで一目で読み取れます.

ただし alpha は背景と混色する指定なので, この見せ方が有効なのは背景が一様 (白) のときに限られます. 背景が濃い場合や図を重ねる場合は, alpha ではなく明度をそろえた色 (HCL / OKLCh) で段階を作る方が安全です ([sec-color](#sec-color)).

## 8.3 フォント

### フォントの種類

フォントには大きく分けて, セリフ体 (serif) とサンセリフ体 (sans-serif) の二種類があります. セリフ体は文字の端に装飾があるフォントで, サンセリフ体は装飾のないフォントです. 下の左の図で赤く示された, 文字の端の突起や飾りが「セリフ」です.

[![セリフ体 (serif)](https://upload.wikimedia.org/wikipedia/commons/2/26/Serif_and_sans-serif_03.svg)](https://upload.wikimedia.org/wikipedia/commons/2/26/Serif_and_sans-serif_03.svg "セリフ体 (serif)")

セリフ体 (serif)

[![サンセリフ体 (sans-serif)](https://upload.wikimedia.org/wikipedia/commons/9/99/Serif_and_sans-serif_01.svg)](https://upload.wikimedia.org/wikipedia/commons/9/99/Serif_and_sans-serif_01.svg "サンセリフ体 (sans-serif)")

サンセリフ体 (sans-serif)

日本語でも明朝体がセリフ体でゴシック体がサンセリフ体に相当します. 英語では, セリフ体は Times New Roman や Garamond などが有名で, サンセリフ体は Arial や Helvetica などが有名です.

### フォントの選び方

基本的に図表はサンセリフ体を使うことが推奨されます. これは, サンセリフ体の方が小さいサイズでも読みやすいからです. `ggplot2` では, デフォルトでサンセリフ体 (多くの場合のシステムに入っている Helvetica か Arial) が使われています.

ただし, 日本語でラベルを追加しようと思うと, Helvetica や Arial には日本語が含まれていないため, 日本語が豆腐化 (□) してしまいます. 日本語を表示するためには, 日本語が含まれているフォントを指定する必要があります. 例えば, Windows では Meiryo, Mac では Hiragino Kaku Gothic ProN などが日本語を含むサンセリフ体のフォントとしてよく使われます.

### フォントの指定方法

グラフのフォントを指定するには大きく2つの問題があります:

1.  **システムにフォントが入っているか**. コードを共有する相手のPCに, そのフォントが入っていないと, そのフォントは使えない場合があります. 例えば, Mac のヒラギノ系は有料フォントであるため, Mac ユーザ以外が持っていることは想定しないほうが良いです.
2.  **R がそのフォントを使えるか**. R の図はグラフィックデバイスとよばれる仕組みを通じて描かれており, フォントを見つけて出力に反映できるかどうかはデバイスごとに異なります (詳しくは [sec-graphics-device](#sec-graphics-device) を参照). 例えば, PDF デバイスではシステムのフォントを自動では参照せず, デバイスに登録された Type 1 フォントしか使えません. さらにデフォルトではフォントを埋め込まず, PDF にはフォント名だけが書き込まれるため, 閲覧環境に同じフォントがなければ表示が崩れます. 埋め込むには Ghostscript 経由の `embedFonts()` が別途必要です.

これらの問題をシンプルに解決するのが, `showtext` パッケージです.[^1] `showtext` は, 文字をフォントとしてではなくグリフのアウトライン (曲線) として描画することで, この問題をデバイスや閲覧環境によらず回避します. さらに `font_add_google()` を使えば, Google Fonts からフォントをダウンロードして登録できるため, フォントのインストール自体も不要になります.

``` r
library(showtext)

font_add_google("Noto Sans JP")
showtext_auto()
```

`showtext_auto()` は, この描画方法を以後に開かれるすべての描画デバイスで自動的に有効にするスイッチです. Quarto (knitr) はチャンクごとに新しいデバイスを開くため, これを最初に一度呼んでおかないと, チャンクごとに `showtext_begin()` と `showtext_end()` で囲む必要が出てきます.

``` r
penguins_bar |>
  mutate(
    species = recode(
      species,
      "Adelie" = "アデリー",
      "Chinstrap" = "ヒゲ",
      "Gentoo" = "ジェンツー"
    ),
    sex = recode(
      sex,
      "male" = "オス",
      "female" = "メス"
    )
  ) |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "ペンギンの種と性別ごとの個体数"
  ) +
  scale_fill_manual(values = met.brewer("Egypt")) +
  theme_minimal(base_family = "Noto Sans JP") +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.15),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))
```

[![](visualization_files/figure-html/plot-showtext-1.svg)](visualization_files/figure-html/plot-showtext-1.svg)

## 8.4 画像形式

レポートやスライドに図を載せる場合, 画像形式の選択が見栄えに影響を与えます. ここでは画像形式について最低限知っておくべきことを紹介します.

### ラスターとベクター

画像形式は, 大きく分けてラスター (raster) 形式とベクター (vector) 形式の2種類があります. ラスター形式はビットマップ (bitmap) とも呼ばれ, 画像を色のついたピクセル (画素) の格子として記録します. 一方, ベクター形式は画像を点・線・曲線・塗りといった図形の数式として記録します. この記録方法の違いが, 拡大したときの見え方とファイルサイズを大きく左右します.

同じ「1992」という文字を, ビットマップ (ラスター) とベクターのそれぞれで表してみましょう. 左はピクセルの格子, 右は輪郭を点とパスで定義したものです.

[![](visualization_files/figure-html/fig-bitmap-vector-1.svg)](visualization_files/figure-html/fig-bitmap-vector-1.svg "Figure 8.2 (a): Bitmap (raster)")

\(a\) Bitmap (raster)

[![](visualization_files/figure-html/fig-bitmap-vector-2.svg)](visualization_files/figure-html/fig-bitmap-vector-2.svg "Figure 8.2 (b): Vector")

\(b\) Vector

Figure 8.2: The number 1992 as a bitmap (pixels) versus a vector (points and paths).

左のビットマップは, 拡大するとピクセルのギザギザ (ジャギー) が目立ちます. きれいに見せるにはピクセル数を増やすしかなく, その分ファイルサイズも大きくなります. 一方, 右のベクターは輪郭を点 (アンカーポイント) とパスで定義しているので, どれだけ拡大しても滑らかなままで, ファイルサイズも解像度に依存しません.

### JPEG の非可逆圧縮

写真は本質的にラスター形式です. そして, ラスター形式のファイル形式のうち, JPEG は非可逆圧縮 (lossy compression) を採用しています. ファイルサイズを大きく減らせる代わりに, 圧縮を強めると輪郭のまわりにノイズ (アーティファクト) が生じます. 1枚の写真[^2] を高品質 (quality 90) と低品質 (quality 5) の JPEG で保存して, 同じ場所を拡大して比べてみます.

[![](visualization_files/figure-html/fig-jpeg-artifacts-1.png)](visualization_files/figure-html/fig-jpeg-artifacts-1.png "Figure 8.3 (a): JPEG quality 90")

\(a\) JPEG quality 90

[![](visualization_files/figure-html/fig-jpeg-artifacts-2.png)](visualization_files/figure-html/fig-jpeg-artifacts-2.png "Figure 8.3 (b): JPEG quality 5")

\(b\) JPEG quality 5

Figure 8.3: The same photo saved as high- and low-quality JPEG, magnified.

低品質の JPEG では, 8x8 ピクセルのブロック状のムラや, 輪郭の周りのにじみがはっきり見えます. 一方で, ファイルサイズは大きく変わります. 同じ写真を PNG (可逆圧縮) と2種類の JPEG で保存し, サイズを比べてみましょう.

| Format            | Size (KB) |
|-------------------|-----------|
| PNG               | 546       |
| JPEG (quality 90) | 95        |
| JPEG (quality 5)  | 5         |

Table 8.1: 同じ写真を各形式で保存したときのファイルサイズ

JPEG は, 写真のように色がなめらかに変化する画像にはとても効果的です. しかし, 輪郭のはっきりしたグラフや文字, ロゴでは, 線の周りに同じノイズが乗ってしまいます. そのため, グラフをラスター形式で保存するなら JPEG ではなく PNG を使い, 可能ならベクター形式を選びます.

### ベクター形式の利点

ベクター形式は図形を数式で記録するので, どれだけ拡大しても輪郭は滑らかなままで, ファイルサイズも解像度に依存しません. グラフは点・線・文字でできているので, ベクター形式と非常に相性が良いです. ggplot のグラフはベクター形式 (SVG や PDF) で出力できます.

[![](visualization_files/figure-html/fig-vector-graph-1.svg)](visualization_files/figure-html/fig-vector-graph-1.svg "Figure 8.4: A vector graphic stays sharp at any zoom level.")

Figure 8.4: A vector graphic stays sharp at any zoom level.

この図は SVG (ベクター形式) で埋め込まれているので, ブラウザで拡大しても曲線も文字も滑らかなまま保たれます.

### 画像形式の選び方

知っておくべきベクター形式は SVG と PDF です.

**SVG (Scalable Vector Graphics)** は Web 上で使われるベクター形式です. Web ブラウザでそのまま表示でき, 拡大しても画質が劣化しません. XML 形式のテキストなので, エディタやプログラムで後から編集できます.

**PDF (Portable Document Format)** は, 印刷や論文の図でよく使われるベクター形式です. 拡大しても劣化せず, LaTeX をはじめ多くのアプリケーションがそのまま扱えます.

知っておくべきラスター形式は PNG と JPEG です.

**PNG (Portable Network Graphics)** は, 可逆圧縮のラスター形式です. 圧縮で画質が劣化せず, 透明な背景もサポートするので, ベクターが使えない場面でのグラフ出力に向いています.

**JPEG (Joint Photographic Experts Group)** は, 非可逆圧縮のラスター形式です. 写真のような複雑な画像を小さなファイルサイズで保存できますが, グラフや文字のような単純な画像には不向きです.

これらを踏まえると, 図の用途ごとの選び方は次のようにまとめられます.

| 用途                           | 推奨形式 |
|--------------------------------|----------|
| 統計グラフ (Web)               | SVG      |
| 統計グラフ (印刷・論文)        | PDF      |
| ベクターが使えない場面のグラフ | PNG      |
| 写真                           | JPEG     |

統計グラフはほとんどの場合ベクター形式が適しています.

### ベクター形式が不向きな場合

ただし, 例外もあります. ベクター形式は図形を1つずつ記録するので, 描く図形の数が増えるほどファイルが大きくなります. 例として, ggplot2 に付属する `diamonds` データセットで, 53,940個のダイヤモンドの重さ (carat) と価格の散布図を描いてみます.

[![](visualization_files/figure-html/fig-too-many-points-1.png)](visualization_files/figure-html/fig-too-many-points-1.png "Figure 8.5: A scatter plot of 53,940 diamonds, embedded as a PNG.")

Figure 8.5: A scatter plot of 53,940 diamonds, embedded as a PNG.

この図を PNG, SVG, PDF のそれぞれで保存して, ファイルサイズを比べてみましょう.

| Format        | Pixels      | Size (MB) |
|---------------|-------------|-----------|
| PNG (200 dpi) | 1000 x 600  | 0.23      |
| PNG (600 dpi) | 3000 x 1800 | 1.48      |
| SVG           | \-          | 21.22     |
| PDF           | \-          | 1.36      |

Table 8.2: 点の多い散布図を各形式で保存したときのファイルサイズ

ラスター形式のファイルサイズは解像度に依存するので, 表には PNG のピクセル数を併記し, Web 表示には十分な 200 dpi と, 印刷にも耐える 600 dpi (このページに埋め込んだ図と同じ解像度) の2通りを載せています. SVG は約5.4万個の点を XML のテキストとして1つずつ記録するため, 高解像度の PNG と比べても1桁以上大きくなります. PDF は圧縮が効くため, ファイルサイズだけなら高解像度の PNG と同程度です. しかしベクター形式の問題はサイズだけではありません. ブラウザや PDF ビューアは表示のたびにすべての点を描画し直すので, 表示やスクロールが目に見えて遅くなります. 一方 PNG のファイルサイズと描画の重さは解像度だけで決まり, 点の数には依存しません. このように, データ点が非常に多い散布図では, ベクター形式ではなく高解像度の PNG を使う方が実用的です.

## 演習問題

前半は画像形式に関するクイズ, 後半は実際にグラフを改善する演習です. クイズは選択肢をクリックすると, その場で正誤が表示されます (複数選択の問題だけは, 選び終えてから「答え合わせ」を押してください).

### 画像形式

ベクター形式の画像は, どれだけ拡大しても輪郭が滑らかなままです. その理由はどれでしょうか.

画像を図形の数式として記録しているから  
可逆圧縮を使っているから  
ファイルサイズが大きいから  
ピクセルの数が十分に多いから  

次のうち, ベクター形式をすべて選んでください.

SVG  

PDF  

PNG  

JPEG  

LaTeX で執筆している論文に統計グラフを載せます. 推奨される画像形式はどれでしょうか.

JPEG  
PDF  
SVG  
PNG  

共同研究者から送られてきたスライドで, グラフの文字や線のまわりにもやもやしたノイズが見えます. 最も可能性の高い原因はどれでしょうか.

グラフを PNG で保存したことによる圧縮の劣化  
SVG の解像度が足りていない  
フォントが埋め込まれていない  
グラフを JPEG で保存したことによる非可逆圧縮のノイズ  

数百万個のデータ点をもつ散布図を SVG で保存したら, ファイルが数十 MB になり表示も重くなりました. どうするのが実用的でしょうか.

JPEG (quality 5) で保存する  
高解像度の PNG で保存する  
PDF に切り替える  
SVG の解像度を下げる  

### 見た目の悪いグラフの改善

次のグラフは, ggplot2 に付属する `mpg` データセット (アメリカで販売された自動車の燃費データ) を使って, メーカーごとの車種数を駆動方式 (`drv`: 4 = 四輪駆動, f = 前輪駆動, r = 後輪駆動) 別に数えたものです. お世辞にも見やすいとは言えません.

``` r
mpg |>
  ggplot(aes(x = manufacturer, fill = drv)) +
  geom_bar() +
  scale_fill_manual(values = c("red", "green", "blue")) +
  labs(
    x = "manufacturer of the car",
    y = "count of the cars",
    title = "Bar Chart of Manufacturer and drv"
  )
```

[![](visualization_files/figure-html/plot-ugly-1.svg)](visualization_files/figure-html/plot-ugly-1.svg)

このグラフの問題点をできるだけ多く列挙してください (少なくとも4つは見つかるはずです). そのうえで, この章で学んだテクニックを使って改善したグラフを描いてください.

> **TIP:**
>
> 問題点の例:
>
> - x 軸のメーカー名が重なっていて読めない
> - 赤と緑の組み合わせは色覚異常の人に区別しづらい
> - グレーの背景やグリッド線など, データを表さないインクが多い
> - 軸ラベルが自明な内容の繰り返しで, タイトルも図の内容を説明しているだけ
> - 凡例の 4 / f / r が何を意味するのか, 図だけを見てもわからない
> - メーカーがアルファベット順に並んでいて, 数の大小が比較しづらい
>
> これらを踏まえた改善例です.
>
> ``` r
> mpg |>
>   mutate(drv = recode(drv, "4" = "4WD", "f" = "Front", "r" = "Rear")) |>
>   ggplot(aes(
>     x = forcats::fct_rev(forcats::fct_infreq(manufacturer)),
>     fill = drv
>   )) +
>   geom_bar() +
>   coord_flip() +
>   see::scale_fill_okabeito() +
>   labs(
>     x = NULL,
>     y = NULL,
>     fill = NULL,
>     title = "Number of Car Models by Manufacturer and Drive Type"
>   ) +
>   theme_minimal() +
>   theme(
>     panel.grid.minor = element_blank(),
>     panel.grid.major.y = element_blank(),
>     legend.position = "inside",
>     legend.position.inside = c(0.85, 0.2),
>     plot.title.position = "plot"
>   )
> ```
>
> [![](visualization_files/figure-html/plot-ugly-improved-1.svg)](visualization_files/figure-html/plot-ugly-improved-1.svg)
>
> - 棒を横向きにしてメーカー名を水平に読めるようにし, `forcats::fct_infreq()` で車種数の多い順に並べ替えました
> - 色覚異常の人にも区別しやすい Okabe-Ito パレットに変えました
> - `theme_minimal()` と `theme()` で背景と不要なグリッド線を消しました
> - 自明な軸ラベルを消し, 凡例をパネル内の空白に移しました
> - `drv` の値を 4WD / Front / Rear と読めるラベルに変えました
>
> これはあくまで一例です. 大事なのは, まず図の主張を決め, その主張が最短時間で伝わるかどうかを基準にデザインを判断することです.

Tufte, Edward R. 2001. *The Visual Display of Quantitative Information*. 2nd ed. Graphics Press.

[^1]: 論文に適した図を作成する, 用途に応じて適切なグラフィックデバイスを選択する, といった観点では, `showtext` は厳密に言えば最適な解決策ではありません ([sec-graphics-device](#sec-graphics-device) 参照). しかし, フォントのインストールや埋め込みの手間を考えると, まずは `showtext` を使うのが最も簡単です.

[^2]: Kodak True Color Image Suite ([kodim23](https://r0k.us/graphics/kodak/kodim23.html)). 画像圧縮のベンチマークに広く使われている, 利用制限なしで公開されたテスト画像です.
