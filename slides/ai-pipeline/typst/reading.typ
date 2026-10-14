// ===========================================================================
// Part 3: Zotero and reading a paper with AI.
//
// `ax` is the dictionary of numbers from the replication of Aneja and Xu
// (2022) that the deck builds from data/*.csv.
// ===========================================================================
#import "lib.typ": *

// ---- 1. Zotero: import DOIs and check cited pages -----------------------------
#let anim-zotero() = stage(26, 10.6, {
  import cetz.draw: *
  ai-icon((1.5, 7.7), s: 1.3)
  circle((2.55, 8.75), radius: 0.28, fill: white, stroke: 1.4pt + c-accent)
  line((2.75, 8.55), (3.05, 8.25), stroke: (paint: c-accent, thickness: 1.4pt, cap: "round"))
  content((1.5, 6.3), box(width: 3.0cm, align(center, lab("AI + 検索", size: 11pt))))
  arrow((2.7, 7.6), (3.9, 7.6), w: 1.7pt, head: 1.3)

  rect((4.1, 4.9), (12.0, 10.4), radius: 7pt, fill: c-panel, stroke: none)
  content((4.6, 9.65), anchor: "west", lab("DOI リスト", size: 12pt, weight: "medium"))
  content((4.6, 8.15), anchor: "west", mono("10.1093/qje/qjab040", size: 10pt))
  line((4.6, 7.35), (11.5, 7.35), stroke: 0.8pt + c-faint)
  content((4.6, 6.55), anchor: "west", mono("10.1093/restud/rdad018", size: 10pt))

  arrow((12.2, 7.6), (13.5, 7.6), w: 1.7pt, head: 1.3)
  content((12.85, 8.15), lab("取り込む", size: 9pt, fill: c-muted))
  rect((13.7, 4.9), (20.1, 10.4), radius: 7pt, fill: c-tint, stroke: none)
  content((16.9, 9.85), lab("Zotero", size: 12pt, weight: "medium", fill: c-accent.darken(15%)))
  for r in range(2) {
    for c in range(3) {
      doc-icon((14.9 + c * 1.65, 8.75 - r * 1.65), w: 0.85, h: 1.05, fill: white, stroke: 1pt + c-accent.darken(10%))
    }
  }
  content((16.9, 5.35), lab("PDF を添付", size: 10.5pt, fill: c-accent.darken(15%)))

  arrow((16.9, 4.7), (16.9, 3.5), w: 1.7pt, head: 1.3)
  content((17.2, 4.1), anchor: "west", lab("MCP で全文を読む", size: 10pt, fill: c-muted))
  ai-icon((16.9, 2.3), s: 1.2)
  arrow((18.1, 2.2), (19.6, 2.2), w: 1.7pt, head: 1.3)
  rect((19.8, 0.8), (25.8, 3.6), radius: 4pt, fill: white, stroke: 1.2pt + c-jet)
  content((22.8, 2.75), lab("内容の整理と根拠", size: 11pt))
  content((22.8, 1.65), box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 5pt, y: 3pt), lab("p. 926", size: 11pt)))

  person-icon((23.2, 8.1), s: 1.4)
  content((23.2, 6.65), box(width: 5.2cm, align(center, lab("原文のページを確認", size: 11pt))))
  arrow((23.2, 3.8), (23.2, 5.6), col: c-accent, w: 1.8pt, head: 1.3)
  arrow((22.0, 8.3), (20.3, 8.3), col: c-accent, w: 1.8pt, head: 1.3)
})

// ---- 2. Close reading: page numbers and "not stated" --------------------------
// The specification of Table II and Figure II as read from the paper. The last
// row is the one the paper leaves open.
#let spec-rows = (
  ([サンプル], [マッチングされた 1907 年から 1921 年の公務員. 観測数は全列で同じ]),
  ([結果変数], [対数賃金 (列 1 から 3), 年俸契約のダミー (列 4), 賃金の百分位 (列 5)]),
  ([処置], [黒人 × 1913 年以降 (列 1 は黒人のダミーも入れる)]),
  ([固定効果], [年 (列 1), 年と個人 (列 2), 年, 個人, 黒人 × 年齢階級 (列 3 から 5)]),
  ([ウェイト], [CEM のウェイト]),
  ([標準誤差], [個人でクラスター]),
  ([イベントスタディ], [列 3 の黒人 × 1913 年以降を, 黒人 × 各年に置き換える]),
  ([基準年], [記載なし]),
)

#let spec-table(highlight: false, size: 15pt, striped: true) = {
  set text(size: size)
  let n = spec-rows.len()
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 0.6em, y: 0.42em),
    fill: (x, y) => if striped and highlight and y == n { c-accent2.lighten(85%) } else if striped and calc.rem(y, 2) == 1 { c-panel } else { none },
    table.hline(stroke: 1.2pt + c-jet),
    table.header(text(weight: "medium")[項目], text(weight: "medium")[論文の記述]),
    table.hline(stroke: 0.7pt + c-jet),
    ..spec-rows
      .enumerate()
      .map(((i, r)) => {
        let last = highlight and i == n - 1
        (
          text(weight: if last { "medium" } else { "regular" }, r.at(0)),
          text(fill: if last { c-accent2 } else { c-jet }, weight: if last { "medium" } else { "regular" }, r.at(1)),
        )
      })
      .flatten(),
    table.hline(stroke: 1.2pt + c-jet),
  )
}

#let anim-close-reading(s) = {
  set block(spacing: 0.5em)
  let quote-box(body, why) = block(width: 100%, fill: c-tint, radius: 5pt, inset: (x: 0.7em, y: 0.45em), grid(
    columns: (1fr, auto),
    column-gutter: 1em,
    align: horizon,
    text(size: 0.85em, body), text(size: 0.8em, fill: c-accent.darken(15%), weight: "medium", why),
  ))
  quote-box([「それぞれの根拠となるページ番号を付けて」], [原文と突き合わせられる])
  quote-box([「論文に書かれていない項目は『記載なし』として」], [論文の穴に気づける])
  v(0.2em)
  if s >= 2 { spec-table(highlight: s >= 3, size: 15pt) } else { hide(spec-table(size: 15pt)) }
  stepcap(s, (
    [精読の指示には, この2文を入れる],
    [AI の読みは表で返ってくる. ページ番号があれば, 原文で確かめられる],
    [「記載なし」と答えさせなければ, AI はこの穴を推測で黙って埋めてしまう],
  ))
}

// ---- 3. Checking the AI's reading against the replication package -------------
#let anim-singleton(s, ax) = {
  let years = ("1907", "1909", "1911", "1913", "1915", "1917", "1919", "1921")
  // Which registers each person appears in; the pattern is made up.
  let people = (
    ("A", (0, 1, 2, 3, 4, 5, 6, 7)),
    ("B", (2, 3, 4, 5, 6, 7)),
    ("C", (3,)),
    ("D", (0, 1, 2, 3, 4)),
    ("E", (6,)),
  )
  stage(26, 10.4, {
    import cetz.draw: *
    // The AI's report.
    ai-icon((1.3, 9.2), s: 1.1)
    bubble(
      (13.9, 9.2),
      23.4,
      1.9,
      [Table I reports #ax.n_matched person-years, but Table II has N = #ax.n_estimation. The paper does not explain the gap.],
      tail: none,
      size: 11.5pt,
    )
    if s >= 2 {
      // A cartoon of the panel.
      for (j, yr) in years.enumerate() {
        content((3.3 + j * 1.3, 7.3), mono(yr, size: 9.5pt, fill: c-muted))
      }
      for (i, (name, obs)) in people.enumerate() {
        let y = 6.3 - i * 1.15
        let single = obs.len() == 1
        person-icon((1.0, y - 0.05), s: 0.62, col: if single and s >= 3 { c-accent2 } else { c-jet })
        content((1.75, y), lab(name, size: 11pt, fill: if single and s >= 3 { c-accent2 } else { c-jet }))
        line((2.7, y), (13.0, y), stroke: 0.8pt + c-faint)
        for j in obs {
          circle((3.3 + j * 1.3, y), radius: 0.24, fill: if single and s >= 3 { c-accent2 } else { c-accent }, stroke: none)
        }
        if single and s >= 3 {
          cross-mark(3.3 + obs.at(0) * 1.3, y, s: 0.8, w: 1.6pt)
        }
      }
    }
    if s == 2 {
      content((14.2, 5.2), anchor: "west", box(width: 11.4cm, {
        set par(leading: 0.5em)
        lab("Estimate it with individual fixed effects and count the observations.", size: 12pt)
      }))
    }
    if s >= 3 {
      content((14.2, 5.9), anchor: "west", box(width: 11.4cm, {
        set par(leading: 0.5em)
        lab("Seen once: the person's own fixed effect fits that observation exactly, so it adds nothing and is dropped.", size: 12pt)
      }))
    }
    if s >= 4 {
      rect((14.2, 1.0), (25.8, 3.8), radius: 6pt, fill: c-tint, stroke: none)
      content((20.0, 2.95), {
        lab(ax.n_matched, size: 15pt)
        lab("  −  ", size: 15pt)
        lab(ax.n_singletons, size: 15pt, fill: c-accent2, weight: "medium")
        lab("  =  ", size: 15pt)
        lab(ax.n_estimation, size: 15pt, weight: "medium")
      })
      content((20.0, 1.75), lab("matched  −  seen once  =  N in Table II", size: 10.5pt, fill: c-muted))
    }
  })
  stepcap(s, (
    [AI に精読させると, 論文の不整合として報告してきた],
    [Replication package があれば, 自分で計算して確かめられる],
    [
      1年しか観測されない人は, 推定に情報をもたらさない.
      #linebreak()
      `reghdfe` も `fixest` も, 既定でこうした人を除く.
    ],
    [除かれた数で, 差がちょうど埋まる. 不整合ではなく, 論文が書いていなかったこと],
  ))
}
