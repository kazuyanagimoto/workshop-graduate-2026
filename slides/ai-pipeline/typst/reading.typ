// ===========================================================================
// Part 3: Git and Zotero as checks on the AI, and reading a paper with it.
//
// `ax` is the dictionary of numbers from the replication of Aneja and Xu
// (2022) that the deck builds from data/*.csv.
// ===========================================================================
#import "lib.typ": *

// ---- 1. Git: commit, let the AI work, read the diff ---------------------------
#let anim-git(s) = {
  stage(26, 10.4, {
    import cetz.draw: *
    let commit(x, name, on: true) = {
      circle((x, 8.9), radius: 0.65, fill: if on { c-tint } else { white }, stroke: 1.4pt + c-jet)
      content((x, 8.9), lab(name, size: 14pt, weight: "medium"))
    }
    // History: A, B.
    line((2.85, 8.9), (5.95, 8.9), stroke: 1.6pt + c-jet)
    commit(2.2, "A")
    commit(6.6, "B")
    chip((6.6, 10.0), "HEAD", fill: c-jet, size: 10pt)
    if s == 1 { content((6.6, 7.6), lab("commit before you ask", size: 12pt, fill: c-accent, weight: "medium")) }
    if s >= 2 {
      // The AI edits the working tree.
      arrow((7.4, 8.9), (10.0, 8.9), col: c-muted, w: 1.7pt, head: 1.3, dash: "dashed")
      rect((10.2, 7.9), (18.6, 9.9), radius: 6pt, fill: c-panel, stroke: none)
      ai-icon((11.4, 8.8), s: 0.9)
      content((12.5, 8.9), anchor: "west", lab("the AI edits the files", size: 12pt))
    }
    if s >= 3 {
      // The diff.
      rect((0.6, 1.0), (18.6, 6.6), radius: 5pt, fill: c-jet.lighten(8%), stroke: none)
      content((1.1, 6.05), anchor: "west", mono("> git diff", size: 11pt, fill: c-outdated))
      content((1.1, 5.2), anchor: "west", mono("  clean_penguins <- function(penguins) {", size: 11pt, fill: white.darken(25%)))
      content((1.1, 4.4), anchor: "west", mono("    penguins |>", size: 11pt, fill: white.darken(25%)))
      rect((0.9, 3.25), (18.3, 3.95), fill: c-accent2.lighten(10%), stroke: none)
      content((1.1, 3.6), anchor: "west", mono("-     filter(!is.na(bill_len))", size: 11pt, fill: white))
      rect((0.9, 2.45), (18.3, 3.15), fill: c-ok.lighten(15%), stroke: none)
      content((1.1, 2.8), anchor: "west", mono("+     filter(!is.na(bill_len), !is.na(body_mass))", size: 11pt, fill: white))
      content((1.1, 2.0), anchor: "west", mono("  }", size: 11pt, fill: white.darken(25%)))
      line((14.4, 7.8), (14.4, 6.8), stroke: 1.5pt + c-muted)
    }
    if s == 3 {
      person-icon((22.2, 4.3), s: 1.5)
      content((22.2, 3.0), box(width: 6.4cm, align(center, lab("you read every changed line", size: 12pt))))
    }
    if s >= 4 {
      arrow((18.8, 8.9), (22.2, 8.9), col: c-ok, w: 2pt, head: 1.4)
      commit(23.0, "C")
      content((23.0, 7.6), box(width: 5.6cm, align(center, {
        set par(leading: 0.45em)
        lab("keep it: commit", size: 12pt, fill: c-ok, weight: "medium")
      })))
    }
    if s >= 5 {
      arrow-path((19.2, 3.8), (22.6, 3.8), (22.6, 5.9), col: c-accent2, w: 2pt, head: 1.4, dash: "dashed")
      content((22.6, 2.6), box(width: 6.4cm, align(center, {
        set par(leading: 0.45em)
        lab("or discard it: back to B", size: 12pt, fill: c-accent2, weight: "medium")
      })))
      circle((22.6, 6.5), radius: 0.5, fill: white, stroke: 1.3pt + c-accent2)
      content((22.6, 6.5), lab("B", size: 12pt, fill: c-accent2, weight: "medium"))
    }
  })
  stepcap(s, (
    [AI に頼む前にコミットしておく],
    [AI がファイルを書き換える],
    [何を変えたかは, `git diff` ですべて見える],
    [よければコミットする. 頼んだ作業1つが, コミット1つになる],
    [気に入らなければ, コミットした時点に戻せば済む],
  ))
}

// ---- 2. The unit of a request is the unit of a commit -------------------------
// A schematic diff: bars standing for changed lines. Lengths are a fixed
// pseudo-random sequence, not data.
#let diff-card(x0, y0, w, h, n, seed: 0) = {
  import cetz.draw: *
  rect((x0, y0), (x0 + w, y0 + h), radius: 4pt, fill: white, stroke: 1.1pt + c-jet)
  let step = (h - 0.5) / n
  for i in range(n) {
    let len = (calc.rem((i + seed) * 37, 50) + 35) / 100 * (w - 0.9)
    let removed = calc.rem(i + seed, 3) == 0
    let y = y0 + h - 0.35 - i * step
    content((x0 + 0.3, y), mono(if removed { "-" } else { "+" }, size: 8pt, fill: if removed { c-accent2 } else { c-ok }))
    line((x0 + 0.6, y), (x0 + 0.6 + len, y), stroke: (paint: if removed { c-accent2.lighten(35%) } else { c-ok.lighten(40%) }, thickness: 4pt, cap: "round"))
  }
}

#let anim-ask-size(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
    // A request small enough to review.
    bubble((6.4, 9.0), 11.8, 1.6, "Move this one function into the pipeline.", tail: "left", size: 12pt)
    diff-card(2.4, 2.6, 8.0, 4.6, 8)
    chip((6.4, 1.6), "you can read this diff", fill: c-ok, size: 11.5pt)
    if s >= 2 {
      // A request too large to review.
      bubble((19.6, 9.0), 11.8, 1.6, "Write all the analysis for the paper.", tail: "left", size: 12pt)
      for k in range(7) {
        diff-card(14.4 + k * 0.62, 2.9 - calc.rem(k, 2) * 0.3 + k * 0.05, 6.4, 4.4, 14, seed: k * 5)
      }
      chip((19.6, 1.6), "nobody can read this one", fill: c-accent2, size: 11.5pt)
    }
    illus-tag(26, 0.1)
  })
  stepcap(s, (
    [ノート1つや関数1つに区切れば, 差分を読んで確かめられる],
    [「分析を全部書いて」と頼むと, 差分が大きすぎて誰にも読めなくなる],
    [AI に頼む作業の単位を, コミットの単位に揃える],
  ))
}

// ---- 3. Zotero: matching DOIs is the hallucination check ----------------------
#let anim-zotero(s) = {
  // Candidates that fail the DOI lookup (row, column); the count is made up.
  let failed = ((0, 3), (1, 1), (2, 4))
  stage(26, 10.6, {
    import cetz.draw: *
    // The AI answering from memory.
    ai-icon((1.5, 7.7), s: 1.3)
    content((1.5, 6.3), box(width: 3.0cm, align(center, {
      set par(leading: 0.45em)
      lab("AI, from memory", size: 11pt)
    })))
    arrow((2.7, 7.6), (3.9, 7.6), w: 1.7pt, head: 1.3)
    // Candidate papers, each with a DOI.
    for r in range(3) {
      for c in range(5) {
        let (x, y) = (4.8 + c * 1.5, 9.4 - r * 1.8)
        let bad = (r, c) in failed
        let gone = bad and s >= 3
        doc-icon((x, y), w: 1.05, h: 1.35, lines: 2, fill: if gone { c-panel } else { white }, stroke: if gone { 1pt + c-faint } else { 1.1pt + c-jet })
        if s >= 2 {
          circle((x + 0.47, y + 0.6), radius: 0.28, fill: if bad { c-accent2 } else { c-ok }, stroke: none)
          if bad { cross-mark(x + 0.47, y + 0.6, s: 0.95, w: 1.7pt) } else { check-mark(x + 0.47, y + 0.6, s: 0.85, w: 1.7pt) }
        }
      }
    }
    content((7.8, 4.6), lab("candidates, each with a DOI", size: 11pt, fill: c-muted))
    if s >= 3 {
      chip((7.8, 3.6), "no such paper, or a wrong DOI", fill: c-accent2, size: 10.5pt)
    }
    if s >= 4 {
      // The library.
      arrow((11.7, 7.6), (13.5, 7.6), w: 1.7pt, head: 1.3)
      content((12.6, 8.05), lab("import", size: 10pt, fill: c-muted))
      rect((13.7, 4.9), (20.1, 10.4), radius: 7pt, fill: c-tint, stroke: none)
      content((16.9, 9.85), lab("Zotero library", size: 12pt, weight: "medium", fill: c-accent.darken(15%)))
      for r in range(3) {
        for c in range(4) {
          doc-icon((14.9 + c * 1.35, 8.75 - r * 1.25), w: 0.85, h: 1.05, fill: white, stroke: 1pt + c-accent.darken(10%))
        }
      }
      content((16.9, 5.35), lab("PDFs, full text", size: 10.5pt, fill: c-accent.darken(15%)))
    }
    if s >= 5 {
      // The AI reads the full text and answers with page numbers.
      arrow((16.9, 4.7), (16.9, 3.5), w: 1.7pt, head: 1.3)
      content((17.2, 4.1), anchor: "west", lab("MCP", size: 10.5pt, fill: c-muted))
      ai-icon((16.9, 2.3), s: 1.2)
      arrow((18.1, 2.2), (19.6, 2.2), w: 1.7pt, head: 1.3)
      rect((19.8, 0.8), (25.8, 3.6), radius: 4pt, fill: white, stroke: 1.2pt + c-jet)
      content((22.8, 2.75), lab("what each paper shows,", size: 11pt))
      content((22.8, 1.65), {
        lab("with pages: ", size: 11pt)
        box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, lab("(p. 926)", size: 11pt))
      })
    }
    if s >= 6 {
      person-icon((23.2, 8.1), s: 1.4)
      content((23.2, 6.65), box(width: 5.2cm, align(center, {
        set par(leading: 0.45em)
        lab("you check the cited pages", size: 11pt)
      })))
      arrow((23.2, 3.8), (23.2, 5.6), col: c-accent, w: 1.8pt, head: 1.3)
      arrow((22.0, 8.3), (20.3, 8.3), col: c-accent, w: 1.8pt, head: 1.3)
    }
    illus-tag(0.2, 0.15, anchor: "south-west")
  })
  stepcap(s, (
    [AI は学習データの記憶から候補を挙げる. DOI も一緒に出させる],
    [DOI から Zotero に取り込む],
    [DOI の照合で, 架空の論文や DOI の誤りを見つける],
    [残ったものだけが, 全文つきでライブラリに入る],
    [全文から整理を書き直させ, 根拠のページ番号も付けさせる],
    [それでも要約を誤ることはある. 根拠のページを原文で確かめる],
  ))
}

// ---- 4. Close reading: page numbers and "not stated" --------------------------
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

// ---- 5. Checking the AI's reading against the replication package -------------
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
      illus-tag(13.0, 0.3)
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
