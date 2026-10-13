// ===========================================================================
// Part 1: the basics of {targets}, on the penguins pipeline of the textbook.
// ===========================================================================
#import "lib.typ": *

// ---- The penguins graph ----------------------------------------------------
#let penguin-nodes(y) = (
  penguins_file: (pos: (3.9, y)),
  penguins: (pos: (9.3, y)),
  penguins_cleaned: (pos: (15.4, y)),
  penguins_summary: (pos: (22.4, y)),
  clean_penguins: (pos: (11.6, y + 2.6), label: "clean_penguins()", kind: "function", above: true),
  summarize_penguins: (pos: (19.0, y + 2.6), label: "summarize_penguins()", kind: "function", above: true),
)
#let penguin-edges = (
  ("penguins_file", "penguins"),
  ("penguins", "penguins_cleaned"),
  ("penguins_cleaned", "penguins_summary"),
  ("clean_penguins", "penguins_cleaned"),
  ("summarize_penguins", "penguins_summary"),
)
#let penguin-targets = ("penguins_file", "penguins", "penguins_cleaned", "penguins_summary")
#let penguin-graph(y, ..args) = tgraph(penguin-nodes(y), penguin-edges, ..args)

// The raw CSV on disk, left of the file target.
#let csv-icon(y, changed: false) = {
  import cetz.draw: *
  doc-icon(
    (1.0, y + 0.25),
    w: 1.15,
    h: 1.4,
    tag: "csv",
    fill: if changed { c-tint2 } else { white },
    stroke: if changed { 1.5pt + c-accent2 } else { 1.1pt + c-jet },
    tag-fill: if changed { c-accent2 } else { c-jet },
  )
  arrow((1.8, y + 0.1), (3.2, y + 0.05), col: if changed { c-accent2 } else { c-muted.lighten(25%) })
}

#let skipped-note = text(size: 13pt, fill: c-muted, style: "italic", "skipped")

// ---- 1. Why a pipeline: scripts run in order break under change ------------
#let anim-scripts(s) = {
  let xs = (4.6, 13, 21.4)
  let scripts = ("01_clean.R", "02_estimate.R", "03_figure.R")
  let outputs = ("clean.csv", "estimates.rds", "figure.pdf")
  stage(26, 10.2, {
    import cetz.draw: *
    for (i, x) in xs.enumerate() {
      let edited = s >= 2 and i == 0
      bnode(
        (x, 9.0),
        6.4,
        1.5,
        scripts.at(i),
        code: true,
        fill: if edited { c-tint2 } else { white },
        stroke: if edited { 1.6pt + c-accent2 } else { 1.2pt + c-jet },
      )
      arrow((x, 8.15), (x, 6.55), w: 1.6pt, head: 1.3)
      doc-icon(
        (x, 5.2),
        w: 1.9,
        h: 2.4,
        lines: 4,
        fill: if s == 3 { c-outdated.lighten(55%) } else { white },
        stroke: if s == 3 { 1.6pt + c-outdated.darken(20%) } else { 1.2pt + c-jet },
        line-col: if s == 3 { c-outdated } else { c-faint },
      )
      content((x, 3.55), mono(outputs.at(i)))
      if i < 2 {
        arrow((x + 1.25, 5.7), (xs.at(i + 1) - 3.1, 8.5), col: c-muted.lighten(25%), w: 1.6pt, head: 1.3)
      }
      if s == 2 {
        circle((x + 1.25, 6.45), radius: 0.44, fill: c-accent2, stroke: none)
        content((x + 1.25, 6.45), text(size: 19pt, fill: white, weight: "bold", "?"))
      }
    }
    if s >= 2 {
      chip((xs.at(0) + 3.2, 9.85), "edited", fill: c-accent2, anchor: "east")
    }
    if s == 2 {
      person-icon((4.8, 1.35), s: 1.25)
      ai-icon((6.4, 1.35), s: 1.25)
      content((4.8, 0.45), lab("人間", size: 11pt))
      content((6.4, 0.45), lab("AI", size: 11pt, fill: c-accent))
      bubble((14.4, 1.5), 13.0, 1.5, "どのスクリプトを再実行すればいいか?", tail: none, size: 14pt)
    }
    if s == 3 {
      content((13, 1.5), box(fill: c-jet, radius: 5pt, inset: (x: 12pt, y: 8pt), {
        mono("tar_outdated()", fill: white)
        h(0.6em)
        lab("lists what is stale", fill: white)
      }))
    }
  })
  stepcap(s, (
    [スクリプトを番号順に実行すれば, 出力はすべて最新になる],
    [
      古くなった出力は, ファイルだけでは分からない.
      #linebreak()
      人は記憶に, AI はコンテキスト内の情報に頼って判断する.
    ],
    [依存関係をコードとして持てば, 古くなった範囲は機械的に判定できる],
  ), height: 3em)
}

// ---- 2. The three elements --------------------------------------------------
#let anim-elements() = {
  let card(x, title, fn, desc, shape) = {
    import cetz.draw: *
    rect((x - 4.05, 5.0), (x + 4.05, 10.2), radius: 7pt, fill: c-panel, stroke: none)
    shape
    content((x, 8.0), lab(title, size: 17pt, weight: "medium"))
    content((x, 7.1), mono(fn, size: 12pt, fill: c-accent))
    content((x, 5.95), box(width: 7.4cm, align(center, {
      set par(leading: 0.45em)
      lab(desc, size: 11.5pt, fill: c-muted)
    })))
  }
  stage(26, 10.4, {
    import cetz.draw: *
    card(4.5, "File", "tar_file()", [
      パスと中身の指紋を記録
      #linebreak()
      中身が変われば検知できる
    ], {
      doc-icon((4.5, 9.25), w: 1.05, h: 1.3, tag: "csv")
    })
    card(13, "Object", "name = ...", [
      データフレームやモデルなど
      #linebreak()
      任意の R オブジェクト
    ], {
      circle((13, 9.25), radius: 0.5, fill: c-ok, stroke: none)
    })
    card(21.5, "Function", "function(inputs) ...", [
      すべての入力を引数にとり
      #linebreak()
      オブジェクトやパスを返す
    ], {
      line((21.5 - 0.58, 8.85), (21.5 + 0.58, 8.85), (21.5, 9.8), close: true, fill: c-ok, stroke: none)
    })
    let y = 1.9
    doc-icon((3.0, y + 0.1), w: 1.3, h: 1.6, tag: "csv")
    arrow((3.8, y), (5.9, y), w: 1.6pt, head: 1.3)
    tnode((6.6, y), "penguins_file", status: "outdated")
    tedge((6.6, y), (12.6, y))
    tnode((12.6, y), "penguins", status: "outdated")
    tedge((12.6, y), (20.2, y))
    tnode((20.2, y), "penguins_cleaned", status: "outdated")
    tnode((16.4, y + 1.6), "clean_penguins()", status: "outdated", kind: "function", above: true)
    tedge((16.4, y + 1.6), (20.2, y), ra: 0.58)
  })
}

// ---- 3. One line of _targets.R is one node ----------------------------------
#let anim-build(s) = {
  set block(spacing: 0.4em)
  let lines = (
    "tar_plan(",
    "  tar_file(penguins_file, \"data/penguins.csv\"),",
    "  penguins = readr::read_csv(penguins_file),",
    "  penguins_cleaned = clean_penguins(penguins),",
    "  penguins_summary = summarize_penguins(penguins_cleaned)",
    ")",
  )
  let k = calc.min(s, 4)
  code-box(
    lines,
    file: "_targets.R",
    size: 15pt,
    hl: if s <= 4 { (k,) } else { () },
  )
  let hidden = penguin-targets.slice(k)
  if k < 3 { hidden.push("clean_penguins") }
  if k < 4 { hidden.push("summarize_penguins") }
  let rings = (:)
  if s <= 4 { rings.insert(penguin-targets.at(k - 1), c-accent) }
  stage(26, 5.0, {
    import cetz.draw: *
    penguin-graph(1.5, default: "outdated", hidden: hidden, rings: rings)
    if s == 5 { status-legend((0.4, 4.2), items: ("outdated",), shapes: true, vertical: true) }
  })
  stepcap(s, (
    [`tar_file()` はファイルを登録する],
    [ファイルを読んだ結果が, 次のターゲットになる],
    [関数に通すと, 引数に書いた名前から矢印が引かれる],
    [下流のターゲットも同じ. 矢印は誰も手で書いていない],
    [まだ何も計算していないので, 全部 Outdated (水色)],
  ))
}

// ---- 4. tar_make() builds from upstream and stores the results --------------
#let anim-make(s) = {
  set block(spacing: 0.4em)
  // In frame s (2..5) target s - 2 is running; in frame 6 everything is done.
  let n-done = calc.max(0, s - 2)
  let st = (:)
  for (i, name) in penguin-targets.enumerate() {
    st.insert(name, if i < n-done { "ok" } else if i == n-done and s >= 2 { "run" } else { "outdated" })
  }
  st.insert("clean_penguins", if n-done >= 3 { "ok" } else { "outdated" })
  st.insert("summarize_penguins", if n-done >= 4 { "ok" } else { "outdated" })
  stage(26, 6.0, {
    import cetz.draw: *
    penguin-graph(1.75, st: st)
    status-legend((0.5, 5.6), items: ("outdated", "run", "ok"), shapes: false, vertical: true)
  })
  let log = (cl-cmd[targets::tar_make()],)
  for (i, name) in penguin-targets.enumerate() {
    if i < n-done { log.push(cl-done(name)) } else if i == n-done and s >= 2 { log.push(cl-dispatch(name)) }
  }
  if s == 6 { log.push(cl-end(4, 0)) }
  grid(
    columns: (1.5fr, 1fr),
    column-gutter: 1em,
    console-box(log, height: 4.55cm, size: 12pt),
    block(width: 100%, height: 4.55cm, fill: c-panel, radius: 5pt, inset: (x: 12pt, y: 10pt), {
      mono("_targets/", size: 11.5pt, fill: c-jet)
      h(0.5em)
      lab("the store", size: 10.5pt, fill: c-muted)
      v(0.15em)
      for (i, name) in penguin-targets.enumerate() {
        if i < n-done {
          block(spacing: 0.4em, box(fill: c-ok, radius: 3pt, inset: (x: 7pt, y: 4.5pt), mono(name, size: 10pt, fill: white)))
        }
      }
    }),
  )
  stepcap(s, (
    [`tar_make()` を実行する],
    [上流から順に計算が始まる],
    [終わった結果はストア (`_targets/`) に保存され, 次のターゲットに渡される],
    [関数 `clean_penguins()` の出番],
    [最後のターゲットまで進む],
    [全部 Up to date (緑). 結果は `tar_read(penguins_summary)` でいつでも取り出せる],
  ))
}

// ---- 5. A function changes: only its downstream is outdated ------------------
#let anim-fn-change(s) = {
  set block(spacing: 0.4em)
  let st = (:)
  let rings = (:)
  let notes = (:)
  if s >= 2 and s <= 5 {
    st.insert("clean_penguins", "outdated")
    rings.insert("clean_penguins", c-accent2)
  }
  if s == 3 or s == 4 { st.insert("penguins_cleaned", "outdated") }
  if s == 4 { st.insert("penguins_summary", "outdated") }
  if s == 5 {
    st.insert("penguins_cleaned", "run")
    st.insert("penguins_summary", "outdated")
  }
  if s == 6 {
    notes.insert("penguins_file", skipped-note)
    notes.insert("penguins", skipped-note)
  }
  stage(26, 6.4, {
    import cetz.draw: *
    penguin-graph(2.2, st: st, rings: rings, notes: notes)
    if s >= 2 and s <= 5 { chip((10.6, 4.75), "edited", fill: c-accent2, anchor: "east") }
  })
  let log = ()
  if s == 4 {
    log = (cl-cmd[targets::tar_outdated()], [\[1\] "penguins_cleaned" "penguins_summary"])
  } else if s == 5 {
    log = (cl-cmd[targets::tar_make()], cl-dispatch("penguins_cleaned"))
  } else if s == 6 {
    log = (
      cl-cmd[targets::tar_make()],
      cl-done("penguins_cleaned"),
      cl-done("penguins_summary"),
      cl-end(2, 2),
    )
  }
  grid(
    columns: (1.15fr, 1fr),
    column-gutter: 1em,
    code-box(
      (
        "clean_penguins <- function(penguins) {",
        "  penguins |>",
        if s == 1 { "    filter(!is.na(bill_len))" } else { "    filter(!is.na(bill_len), !is.na(body_mass))" },
        "}",
      ),
      file: "R/functions.R",
      size: 13pt,
      hl: if s >= 2 { (2,) } else { () },
    ),
    if log.len() > 0 { console-box(log, height: 3.9cm, size: 12pt) } else { block(height: 3.9cm) },
  )
  stepcap(s, (
    [全部 Up to date の状態から始める],
    [`clean_penguins()` に条件を1つ足した. 関数のノードが Outdated になる],
    [その関数を使っているターゲットが古くなる],
    [そこから下流へ伝わる. 上流の2つは緑のまま],
    [`tar_make()` は古くなったものだけを計算し直す],
    [変えていない上流は飛ばされる: 2 completed, 2 skipped],
  ))
}

// ---- 6. The data change: everything downstream of the file -------------------
#let anim-data-change(s) = {
  set block(spacing: 0.4em)
  let st = (:)
  if s == 3 { st.insert("penguins_file", "outdated") }
  if s == 4 {
    for n in penguin-targets { st.insert(n, "outdated") }
  }
  stage(26, 6.4, {
    import cetz.draw: *
    csv-icon(2.2, changed: s >= 2 and s <= 4)
    penguin-graph(2.2, st: st)
    if s >= 2 and s <= 4 { chip((0.3, 3.75), "new contents", fill: c-accent2, size: 10pt, anchor: "west") }
  })
  let log = ()
  if s == 5 { log = (cl-cmd[targets::tar_make()], cl-end(4, 0)) }
  grid(
    columns: (1.15fr, 1fr),
    column-gutter: 1em,
    if s >= 2 {
      code-box(
        (
          "write.csv(",
          "  subset(penguins, year >= 2008),",
          "  \"data/penguins.csv\", row.names = FALSE",
          ")",
        ),
        file: "R console",
        size: 13pt,
      )
    } else { block(height: 3.9cm) },
    if log.len() > 0 { console-box(log, height: 3.9cm, size: 12pt) } else { block(height: 3.9cm) },
  )
  stepcap(s, (
    [もう一度, 全部 Up to date の状態から],
    [生データが更新された. パスは同じで, 中身だけが変わる],
    [`tar_file()` は中身も記録しているので, 変更を検知する],
    [データを変えると下流はすべて古くなり, 関数は緑のまま残る],
    [今度は4つとも計算し直される: 4 completed, 0 skipped #h(1.5em) #link(<sec-exr-2>)[#button[Back to main]]],
  ))
}

// ---- 7. Four commands --------------------------------------------------------
#let fig-commands() = stage(26, 11.2, {
  import cetz.draw: *
  let card(x, cmds, what, body) = {
    rect((x - 3.1, 0.3), (x + 3.1, 11.0), radius: 7pt, fill: c-panel, stroke: none)
    for (i, cmd) in cmds.enumerate() {
      content((x, 10.1 - i * 0.75), mono(cmd, size: 12.5pt, fill: c-accent))
    }
    content((x, 1.6), box(width: 5.6cm, align(center, {
      set par(leading: 0.45em)
      lab(what, size: 12pt)
    })))
    body
  }
  let mini(x, y, sts) = {
    let pts = ((x - 1.8, y), (x, y), (x + 1.8, y))
    tedge(pts.at(0), pts.at(1), ra: 0.4, rb: 0.4)
    tedge(pts.at(1), pts.at(2), ra: 0.4, rb: 0.4)
    for (i, p) in pts.enumerate() {
      tnode(p, "", status: sts.at(i), r: 0.4)
    }
  }
  card(3.2, ("tar_visnetwork()",), "グラフと更新状況", {
    mini(3.2, 5.9, ("ok", "outdated", "outdated"))
  })
  card(9.73, ("tar_outdated()",), "古いターゲットを列挙", {
    content((9.73, 6.3), mono("\"penguins_cleaned\"", size: 10pt))
    content((9.73, 5.5), mono("\"penguins_summary\"", size: 10pt))
  })
  card(16.27, ("tar_make()",), "古い対象を順に再計算", {
    mini(16.27, 6.9, ("ok", "run", "outdated"))
    arrow((16.27, 6.2), (16.27, 5.3), w: 1.6pt, head: 1.3)
    mini(16.27, 4.6, ("ok", "ok", "ok"))
  })
  card(22.8, ("tar_read()", "tar_load()"), "保存した結果を取得", {
    tnode((21.4, 5.9), "", status: "ok", r: 0.4)
    arrow((22.0, 5.9), (23.0, 5.9), w: 1.6pt, head: 1.3)
    // A small table.
    rect((23.2, 5.1), (24.9, 6.7), stroke: 1.1pt + c-jet, fill: white)
    line((23.2, 6.2), (24.9, 6.2), stroke: 1.1pt + c-jet)
    line((23.2, 5.65), (24.9, 5.65), stroke: 0.7pt + c-muted)
    line((24.05, 5.1), (24.05, 6.7), stroke: 0.7pt + c-muted)
  })
})
