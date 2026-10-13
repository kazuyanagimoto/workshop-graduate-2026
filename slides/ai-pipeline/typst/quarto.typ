// ===========================================================================
// Part 2: Quarto + {targets}, on the textbook's targets-quarto example.
//
// Functions that show a count or an estimate take `q`, the dictionary of
// measured results that the deck builds from data/quarto-example.csv.
// ===========================================================================
#import "lib.typ": *

// ---- The example pipeline ----------------------------------------------------
// The analysis targets carry their labels on the right, so that the edges
// fanning out of `did` do not run through them; the edges to the manuscript
// start after the labels.
#let q-ax = 13.6
#let q-label-end = 18.5
#let q-nodes(y0) = (
  did_raw_file: (pos: (2.5, y0)),
  did_raw: (pos: (6.7, y0)),
  did: (pos: (10.0, y0)),
  tab_balance: (pos: (q-ax, y0 + 3.0), side: "right"),
  trends: (pos: (q-ax, y0 + 1.0), side: "right"),
  models_did: (pos: (q-ax, y0 - 1.0), side: "right"),
  model_event: (pos: (q-ax, y0 - 3.0), side: "right"),
)
#let q-edges = (
  ("did_raw_file", "did_raw"),
  ("did_raw", "did"),
  ("did", "tab_balance"),
  ("did", "trends"),
  ("did", "models_did"),
  ("did", "model_event"),
)
#let q-analysis = ("tab_balance", "trends", "models_did", "model_event")
#let q-ms-x = 23.2

// A dashed frame around one sub-plan.
#let plan-frame(x0, x1, y0, y1, name) = {
  import cetz.draw: *
  rect((x0, y0), (x1, y1), radius: 7pt, stroke: (paint: c-muted.lighten(30%), thickness: 1pt, dash: "dashed"))
  content((x0 + 0.25, y1 + 0.12), anchor: "south-west", mono(name, size: 11pt, fill: c-muted))
}

// A rendered document as a node: a sheet filled with the status colour.
#let doc-node(pos, label, status: "ok", w: 1.9, h: 2.4, sub: none) = {
  import cetz.draw: *
  let (x, y) = pos
  let col = status-colors.at(status)
  doc-icon(pos, w: w, h: h, fill: col, stroke: 1.2pt + col, lines: 4, line-col: white.transparentize(50%))
  if status == "ok" {
    circle((x, y - 0.15), radius: 0.42, fill: white, stroke: none)
    check-mark(x, y - 0.15, col: c-ok, w: 2.2pt)
  }
  content((x, y - h / 2 - 0.22), anchor: "north", mono(label))
  if sub != none {
    content((x, y - h / 2 - 0.95), anchor: "north", mono(sub, size: 10pt, fill: c-muted))
  }
}

// The whole example graph. `ms-edges` lists the analysis targets that the
// manuscript is known to depend on.
#let qgraph(
  y0,
  st: (:),
  default: "ok",
  hidden: (),
  frames: ("data", "analysis", "manuscript"),
  ms-edges: q-analysis,
  notes: (:),
  rings: (:),
) = {
  import cetz.draw: *
  if "data" in frames { plan-frame(0.2, 11.2, y0 - 1.75, y0 + 1.2, "tar_data") }
  if "analysis" in frames { plan-frame(12.5, 18.7, y0 - 3.95, y0 + 3.95, "tar_analysis") }
  if "manuscript" in frames { plan-frame(20.6, 25.8, y0 - 2.6, y0 + 1.75, "tar_manuscript") }
  tgraph(q-nodes(y0), q-edges, st: st, default: default, hidden: hidden, notes: notes, rings: rings)
  if "manuscript" not in hidden {
    for (i, n) in q-analysis.enumerate() {
      if n in ms-edges and n not in hidden {
        let sa = st.at(n, default: default)
        arrow(
          (q-label-end + 0.35, q-nodes(y0).at(n).pos.at(1)),
          (q-ms-x - 1.2, y0 + (1.5 - i) * 0.45),
          col: if sa == "outdated" { c-outdated.darken(8%) } else { c-muted.lighten(25%) },
          w: 1.7pt,
          head: 1.3,
        )
      }
    }
    doc-node((q-ms-x, y0), "manuscript", status: st.at("manuscript", default: default))
  }
}

// What tar_make() reported, as a console-like tag.
#let result-tag(pos, completed, skipped, anchor: "center") = {
  d.content(pos, anchor: anchor, box(fill: c-jet.lighten(8%), radius: 5pt, inset: (x: 11pt, y: 7pt), mono(
    [#completed completed, #skipped skipped],
    size: 12pt,
    fill: white,
  )))
}

// ---- 1. From raw data to the PDF in one pipeline ------------------------------
#let anim-qpipe-overview() = {
  let y0 = 4.75
  stage(26, 9.8, {
    import cetz.draw: *
    qgraph(y0, default: "outdated")
  })
}

// ---- 2. The pipeline computes, the manuscript draws ---------------------------
#let anim-compute-render() = {
  stage(26, 10.2, {
    import cetz.draw: *
    let band(y, x-split) = {
      rect((3.7, y - 1.75), (x-split - 0.1, y + 1.75), radius: 6pt, fill: c-tint, stroke: none)
      rect((x-split + 0.1, y - 1.75), (25.8, y + 1.75), radius: 6pt, fill: c-panel, stroke: none)
    }
    let band-labels(y, x-split) = {
      content((3.95, y + 1.35), anchor: "west", mono("tar_analysis", size: 10.5pt, fill: c-accent.darken(10%)))
      content((x-split + 0.35, y + 1.35), anchor: "west", mono("tar_manuscript", size: 10.5pt, fill: c-muted))
    }
    let sheet(x, y, name, fill: white) = {
      doc-icon((x, y + 0.05), w: 1.3, h: 1.6, lines: 3, fill: fill)
      content((x, y - 0.95), anchor: "north", mono(name, size: 10.5pt))
    }
    // LaTeX: the pipeline writes the tables and figures to files.
    let ya = 7.9
    content((0.2, ya), anchor: "west", lab("LaTeX", size: 15pt, weight: "medium"))
    band(ya, 16.1)
    band-labels(ya, 16.1)
    tnode((5.6, ya + 0.05), "models_did", size: 10.5pt, r: 0.45)
    arrow((6.3, ya + 0.05), (8.4, ya + 0.05), w: 1.6pt, head: 1.3)
    sheet(9.6, ya, "tab_did.tex")
    sheet(13.9, ya, "fig_event.pdf")
    arrow((14.9, ya + 0.05), (17.6, ya + 0.05), w: 1.6pt, head: 1.3)
    sheet(18.7, ya, "main.tex")
    arrow((19.7, ya + 0.05), (22.6, ya + 0.05), w: 1.6pt, head: 1.3)
    sheet(23.7, ya, "main.pdf", fill: c-faint)
    // Quarto: the pipeline stops at the objects.
    let yb = 3.4
    content((0.2, yb), anchor: "west", lab("Quarto", size: 15pt, weight: "medium"))
    band(yb, 7.9)
    band-labels(yb, 7.9)
    tnode((5.6, yb + 0.05), "models_did", size: 10.5pt, r: 0.45)
    arrow((6.3, yb + 0.05), (12.6, yb + 0.05), w: 1.6pt, head: 1.3)
    content((9.5, yb + 0.5), mono("tar_load()", size: 10pt, fill: c-muted))
    sheet(13.9, yb, "main.qmd")
    content((15.0, yb + 0.45), anchor: "west", box(width: 7.4cm, {
      set par(leading: 0.45em)
      lab("レンダリング時に図表を作る", size: 10.5pt, fill: c-muted)
    }))
    arrow((14.9, yb - 0.5), (22.6, yb - 0.5), w: 1.6pt, head: 1.3)
    sheet(23.7, yb, "main.pdf", fill: c-faint)
  })
}

// ---- 3. The manuscript reads the store and makes everything -------------------
#let anim-manuscript(s, q) = {
  stage(26, 10.2, {
    import cetz.draw: *
    // The store.
    rect((0.3, 0.5), (6.6, 9.4), radius: 7pt, fill: c-panel, stroke: none)
    content((0.7, 8.85), anchor: "west", mono("_targets/", size: 11.5pt))
    for (i, n) in q-analysis.enumerate() {
      let y = 7.5 - i * 1.8
      tnode((1.5, y), "", r: 0.42)
      content((2.2, y), anchor: "west", mono(n, size: 11pt))
    }
    // The manuscript source.
    rect((8.2, 0.5), (17.6, 9.4), radius: 4pt, fill: white, stroke: 1.2pt + c-jet)
    rect((8.2, 9.4), (11.4, 10.05), radius: (north: 4pt), fill: c-jet.lighten(25%), stroke: none)
    content((9.8, 9.72), mono("main.qmd", size: 9.5pt, fill: white))
    let qblock(i, y, h, head, code) = {
      let on = s == i
      rect((8.6, y - h / 2), (17.2, y + h / 2), radius: 5pt, fill: if on { c-accent.lighten(80%) } else { c-panel }, stroke: if on { 1.4pt + c-accent } else { none })
      if head != none {
        content((8.9, y + 0.33), anchor: "west", lab(head, size: 10.5pt, fill: c-muted))
        content((8.9, y - 0.33), anchor: "west", mono(code, size: 10.5pt))
      } else {
        content((8.9, y), anchor: "west", mono(code, size: 10.5pt))
      }
    }
    qblock(1, 8.2, 1.35, "setup chunk", "tar_load(c(trends, ...))")
    qblock(2, 6.3, 1.35, "figure chunk", "ggplot(trends, ...)")
    qblock(3, 4.4, 1.35, "table chunk", "modelsummary(models_did)")
    qblock(4, 2.05, 2.2, "prose", "... is `r coef(...)`.")
    // The rendered page.
    rect((19.4, 0.5), (25.7, 9.4), radius: 2pt, fill: white, stroke: 1.2pt + c-jet)
    content((22.55, 9.72), mono("main.pdf", size: 9.5pt, fill: c-muted))
    // A figure placeholder: axes and two lines, an icon rather than a plot.
    let hl(i) = if s == i { 1.6pt + c-accent } else { 0.9pt + c-faint }
    rect((20.0, 5.6), (25.1, 8.8), radius: 3pt, stroke: hl(2), fill: none)
    line((20.5, 8.4), (20.5, 6.0), (24.7, 6.0), stroke: 1pt + c-muted)
    line((20.8, 6.5), (22.2, 6.9), (23.2, 7.9), (24.4, 8.2), stroke: 1.5pt + c-accent)
    line((20.8, 6.4), (22.2, 6.6), (23.2, 6.7), (24.4, 6.9), stroke: (paint: c-accent2, thickness: 1.5pt, dash: "dashed"))
    // A table placeholder.
    rect((20.0, 3.3), (25.1, 5.2), radius: 3pt, stroke: hl(3), fill: none)
    line((20.3, 4.85), (24.8, 4.85), stroke: 1.1pt + c-jet)
    for i in range(3) { line((20.3, 4.45 - i * 0.38), (24.8, 4.45 - i * 0.38), stroke: 1.6pt + c-faint) }
    line((20.3, 3.5), (24.8, 3.5), stroke: 1.1pt + c-jet)
    // A sentence with a number in it.
    rect((20.0, 1.0), (25.1, 2.9), radius: 3pt, stroke: hl(4), fill: none)
    line((20.3, 2.5), (24.8, 2.5), stroke: 1.6pt + c-faint)
    line((20.3, 2.0), (22.6, 2.0), stroke: 1.6pt + c-faint)
    content((23.4, 2.0), box(fill: if s == 4 { c-accent } else { c-faint }, radius: 3pt, inset: (x: 5pt, y: 3pt), mono(q.base.est, size: 10.5pt, fill: if s == 4 { white } else { c-jet })))
    line((20.3, 1.5), (23.6, 1.5), stroke: 1.6pt + c-faint)
    // The link drawn in this frame.
    if s == 1 { arrow((6.8, 8.2), (8.4, 8.2), col: c-accent, w: 2pt, head: 1.4) }
    if s == 2 { arrow((17.4, 6.3), (19.8, 7.0), col: c-accent, w: 2pt, head: 1.4) }
    if s == 3 { arrow((17.4, 4.4), (19.8, 4.3), col: c-accent, w: 2pt, head: 1.4) }
    if s == 4 { arrow((17.4, 2.05), (22.5, 2.0), col: c-accent, w: 2pt, head: 1.4) }
  })
  stepcap(s, (
    [冒頭のチャンクで, パイプラインの結果を `tar_load()` で読み込む],
    [図は, 読み込んだオブジェクトからチャンクの中で描く],
    [表も同じ. 推定結果のオブジェクトを `modelsummary()` に渡す],
    [本文の数値も, 読み込んだ結果からインラインコードで埋め込む],
  ))
}

// ---- 4. tar_quarto() reads the manuscript and draws the edges -----------------
// The four analysis targets and their dependencies on the manuscript.
#let tq-graph() = {
  import cetz.draw: *
  let ys = (8.7, 6.6, 4.5, 2.4)
  for (i, n) in q-analysis.enumerate() {
    let pos = (0.7, ys.at(i))
    arrow((5.6, ys.at(i)), (9.0, 5.55 + (1.5 - i) * 0.45), col: c-accent, w: 2pt, head: 1.4)
    tnode(pos, n, status: "ok", side: "right")
  }
  doc-node((10.2, 5.55), "manuscript", status: "ok")
}

#let anim-tar-quarto() = {
  grid(
    columns: (14.3cm, 1fr),
    column-gutter: 0.6em,
    align: horizon,
    {
      set block(spacing: 0.5em)
      code-box(("tar_quarto(manuscript, \"manuscript/main.qmd\")",), file: "R/tar_manuscript.R", size: 13.5pt, hl: (0,))
      code-box(
        (
          "targets::tar_load(c(",
          "  tab_balance,",
          "  trends,",
          "  models_did,",
          "  model_event",
          "), store = here::here(\"_targets\"))",
        ),
        file: "manuscript/main.qmd, first chunk",
        size: 13.5pt,
      )
    },
    cetz.canvas(length: 1cm, {
      import cetz.draw: *
      rect((0, 0), (12.2, 9.9), stroke: none)
      tq-graph()
    }),
  )
}

// ---- 5. What reruns after each change (debrief of the exercise) ---------------
#let anim-what-reruns(s, q) = {
  let y0 = 4.75
  let k = calc.quo(s - 1, 2)
  let reveal = calc.rem(s, 2) == 0
  let outdated = (
    ("manuscript",),
    ("model_event", "manuscript"),
    ("did", "tab_balance", "trends", "models_did", "model_event", "manuscript"),
  ).at(k)
  let st = (:)
  if reveal { for n in outdated { st.insert(n, "outdated") } }
  let res = (q.theme, q.event, q.clean).at(k)
  stage(26, 9.8, {
    import cetz.draw: *
    qgraph(y0, st: st)
    chip((0.4, 9.35), "Change " + ("A", "B", "C").at(k), fill: c-jet, anchor: "west", size: 12pt)
    let edited(pos, name, anchor) = content(pos, anchor: anchor, box(fill: c-accent2, radius: 4pt, inset: (x: 8pt, y: 5pt), {
      mono(name, size: 11pt, fill: white)
      h(0.5em)
      lab("edited", size: 11pt, fill: white)
    }))
    if k == 0 { edited((25.8, y0 + 2.75), "theme_set()", "south-east") }
    if k == 1 { edited((12.2, 1.3), "estimate_event()", "east") }
    if k == 2 { edited((10.3, y0 + 1.9), "clean_did()", "south-east") }
    if reveal { result-tag((4.3, 9.35), res.completed, res.skipped, anchor: "west") }
  })
  stepcap(s, (
    [変更 A: 原稿の `theme_set()` を変えると, どこが古くなる?],
    [作り直されるのは PDF だけ. 図の見た目を変えても, 推定はやり直されない],
    [変更 B: `estimate_event()` の定式化を変えた. どこが古くなる?],
    [イベントスタディの推定と PDF だけ. ほかの3つの結果は飛ばされる],
    [変更 C: `clean_did()` に行を足した. どこが古くなる?],
    [下流の6つを再計算し, 生データの登録と読み込みは飛ばす #h(1em) #link(<sec-exr-3>)[#button[Back to main]]],
  ))
}

// ---- 6. Inline code: the number in the text follows the result ----------------
#let anim-inline(s, q) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let after = s == 2
    let lane(y, title, src, value, state) = {
      content((0.2, y + 0.9), anchor: "west", lab(title, size: 14pt, weight: "medium"))
      // Source.
      rect((0.2, y - 1.1), (15.4, y + 0.4), radius: 5pt, fill: c-panel, stroke: none)
      content((0.6, y - 0.35), anchor: "west", src)
      arrow((15.6, y - 0.35), (17.2, y - 0.35), w: 1.6pt, head: 1.3)
      // Rendered sentence.
      rect((17.5, y - 1.1), (25.8, y + 0.4), radius: 2pt, fill: white, stroke: 1.2pt + c-jet)
      let num-fill = if state == "stale" { c-accent2 } else if state == "fresh" { c-ok } else { c-faint }
      content((17.9, y - 0.35), anchor: "west", {
        lab("the estimate is ", size: 12pt)
        box(fill: num-fill, radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, mono(value, size: 12pt, fill: if state == "none" { c-jet } else { white }))
        lab(".", size: 12pt)
      })
      if state == "stale" { chip((25.6, y + 0.4), "stale", fill: c-accent2, anchor: "east") }
      if state == "fresh" { chip((25.6, y + 0.4), "updated", fill: c-ok, anchor: "east") }
    }
    content((7.8, 9.8), lab("manuscript source", size: 11pt, fill: c-muted))
    content((21.65, 9.8), lab("rendered PDF", size: 11pt, fill: c-muted))
    lane(7.9, "Typed by hand", mono("the estimate is " + q.base.est + ".", size: 12pt), q.base.est, if after { "stale" } else { "none" })
    lane(
      4.6,
      "Inline code",
      {
        mono("the estimate is ", size: 12pt)
        box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 4pt, y: 3pt), baseline: 3pt, mono("`r sprintf(\"%.2f\", est)`", size: 12pt))
        mono(".", size: 12pt)
      },
      if after { q.clean.est } else { q.base.est },
      if after { "fresh" } else { "none" },
    )
    if after {
      content((0.2, 1.6), anchor: "west", box(fill: c-accent2, radius: 4pt, inset: (x: 8pt, y: 5pt), {
        mono("clean_did()", size: 11pt, fill: white)
        h(0.5em)
        lab("edited, then", size: 11pt, fill: white)
        h(0.5em)
        mono("tar_make()", size: 11pt, fill: white)
      }))
    }
    if after {
      content((25.8, 1.6), anchor: "east", lab([the table in the same PDF now says #q.clean.est], size: 12pt, fill: c-muted))
    }
  })
  stepcap(s, (
    [本文の数字の書き方は2通り. どちらも, PDF では同じに見える],
    [手書きの数字は古いまま残るが, インラインコードなら更新される],
  ))
}
