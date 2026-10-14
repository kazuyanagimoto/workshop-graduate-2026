// ===========================================================================
// Part 5: the clean room. Another AI rebuilds the results from the paper alone.
//
// `ax` is the dictionary of numbers the deck builds from data/*.csv.
// ===========================================================================
#import "lib.typ": *

// ---- 0. Software origins: independent implementation from a specification ----
// The Compaq BIOS example is described by its founder in the PBS interview.
// The second team implements the same behavior without copying the source code.
#let anim-software-cleanroom(s) = {
  stage(26, 9.2, {
    import cetz.draw: *
    // The original implementation is available only to the analysis team.
    doc-icon((2.0, 6.2), w: 1.6, h: 2.0, lines: 4)
    content((2.0, 7.85), lab("IBM PC BIOS", size: 11.5pt, weight: "medium"))
    content((2.0, 4.65), lab("元の BIOS コード", size: 10pt, fill: c-accent2))
    if s >= 2 {
      arrow((3.05, 6.2), (4.5, 6.2), w: 1.6pt, head: 1.2)
      rect((4.7, 5.0), (10.1, 7.4), radius: 6pt, fill: c-panel, stroke: none)
      person-icon((5.8, 6.1), s: 0.85, col: c-muted)
      content((6.7, 6.6), anchor: "west", lab("Team A", size: 12pt, weight: "medium"))
      content((6.7, 5.85), anchor: "west", lab("動作を調査", size: 10.5pt))
      content((7.4, 8.1), lab("元のコードを参照できる", size: 10pt, fill: c-muted))
      arrow((10.3, 6.2), (11.95, 6.2), w: 1.6pt, head: 1.2)
      doc-icon((13.0, 6.2), w: 1.4, h: 1.8, lines: 3, stroke: 1.3pt + c-accent)
      content((13.0, 7.85), lab("機能仕様書", size: 11pt, weight: "medium", fill: c-accent))
      content((13.0, 4.65), lab("入力と出力", size: 10pt, fill: c-muted))
    }
    if s >= 3 {
      // Only the functional specification may cross the boundary.
      rect((15.3, 0.4), (25.7, 9.0), radius: 8pt, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
      content((20.5, 8.4), lab("クリーンルーム", size: 12pt, weight: "medium", fill: c-accent))
      arrow((14.05, 6.2), (16.3, 6.2), col: c-accent, w: 1.8pt, head: 1.2)
      rect((16.5, 5.0), (24.0, 7.4), radius: 6pt, fill: white, stroke: 1.2pt + c-accent)
      person-icon((17.7, 6.1), s: 0.85, col: c-accent)
      content((18.7, 6.6), anchor: "west", lab("Team B", size: 12pt, weight: "medium"))
      content((18.7, 5.85), anchor: "west", lab("仕様書から実装", size: 10.5pt))
      content((20.25, 4.45), lab("元のコードは見ていない", size: 10pt, fill: c-accent))
      arrow-path((3.05, 5.5), (4.3, 4.7), (4.3, 3.25), (14.9, 3.25), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(15.3, 3.25, s: 1.7, col: c-accent2)
      content((9.3, 3.85), lab("元のコードは渡さない", size: 11pt, fill: c-accent2, weight: "medium"))
      arrow((20.25, 4.0), (20.25, 2.9), col: c-accent, w: 1.8pt, head: 1.2)
      bnode((20.25, 1.85), 7.5, 1.7, "互換 BIOS", sub: "同じ動作, 別のコード", size: 12pt, sub-size: 10.5pt, stroke: 1.2pt + c-accent)
    }
  })
  stepcap(s, (
    [IBM PC の BIOS と同じ機能を, コードをコピーせずに作りたい],
    [調査チームが動作を調べ, 入力と出力の仕様書を書く],
    [実装チームは仕様書だけで互換 BIOS を作り, 元のコードをコピーしない],
  ))
  block(above: 0pt, text(size: 12pt, fill: c-muted)[
    例: Compaq の互換 BIOS. 出典: #link("https://www.pbs.org/nerds/part2.html")[PBS, 創業者の証言].
  ])
}

// ---- 1. Reproducibility: the paper and the data are enough -------------------
// A database cylinder, so the data reads differently from the code and the paper.
#let data-icon(pos, w: 1.3, h: 1.5, col: c-jet) = {
  import cetz.draw: *
  let (x, y) = pos
  let ry = h * 0.15
  let st = 1.1pt + col
  let (l, r, b, t) = (x - w / 2, x + w / 2, y - h / 2 + ry, y + h / 2 - ry)
  circle((x, b), radius: (w / 2, ry), fill: white, stroke: st)
  rect((l, b), (r, t), fill: white, stroke: none)
  line((l, b), (l, t), stroke: st)
  line((r, b), (r, t), stroke: st)
  circle((x, t), radius: (w / 2, ry), fill: white, stroke: st)
}

// Same layout grammar as the BIOS slide: the paper plays the role of the spec.
#let anim-repro(s) = {
  stage(26, 9.4, {
    import cetz.draw: *
    let (yt, ym, yb) = (7.5, 5.0, 2.5)
    let (xd, xr) = (19.0, 23.3)
    let name(pos, body, col: c-jet) = content(pos, lab(body, size: 12pt, weight: "medium", fill: col))
    let result(y, col) = bnode((xr, y), 3.6, 1.5, "結果", size: 12pt, stroke: 1.2pt + col)
    // The original analysis: code and data give the results, the paper describes it.
    doc-icon((2.2, yt), lines: 4)
    name((2.2, yt + 1.4), "元のコード")
    arrow((3.25, yt), (xr - 2.0, yt), w: 1.6pt, head: 1.2)
    result(yt, c-jet)
    data-icon((xd, ym))
    content((xd - 0.95, ym), anchor: "east", lab("データ", size: 12pt, weight: "medium"))
    arrow((xd, ym + 0.9), (xd, yt - 0.15), w: 1.6pt, head: 1.2)
    arrow((2.2, yt - 1.15), (2.2, yb + 1.2), w: 1.6pt, head: 1.2)
    doc-icon((2.2, yb), lines: 4, stroke: 1.3pt + c-accent)
    name((2.2, yb - 1.5), "論文", col: c-accent)
    if s >= 2 {
      // Only the paper crosses the boundary; the original code and the data do not.
      rect((6.2, 0.3), (16.3, 4.6), radius: 8pt, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
      content((6.65, 4.05), anchor: "west", lab("クリーンルーム", size: 11pt, weight: "medium", fill: c-accent))
      arrow((3.25, yb), (6.9, yb), col: c-accent, w: 1.8pt, head: 1.2)
      rect((7.1, yb - 0.9), (11.5, yb + 0.9), radius: 6pt, fill: white, stroke: 1.2pt + c-accent)
      ai-icon((8.15, yb - 0.1), s: 0.85)
      content((9.0, yb), anchor: "west", lab("別の AI", size: 12pt, weight: "medium"))
      arrow((11.7, yb), (13.2, yb), col: c-accent, w: 1.8pt, head: 1.2)
      doc-icon((14.3, yb), lines: 4, stroke: 1.3pt + c-accent)
      name((14.3, yb - 1.5), "別のコード", col: c-accent)
      arrow-path((3.05, yt - 0.7), (4.3, yt - 1.5), (12.6, yt - 1.5), (12.6, 5.0), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(12.6, 4.6, s: 1.7, col: c-accent2)
      arrow-path((xd - 0.7, ym + 0.55), (xd - 1.4, yt - 1.5), (14.8, yt - 1.5), (14.8, 5.0), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(14.8, 4.6, s: 1.7, col: c-accent2)
    }
    if s >= 3 {
      // The new code runs on the same data, and the two results are compared.
      arrow((15.35, yb), (xr - 2.0, yb), col: c-accent, w: 1.8pt, head: 1.2)
      arrow((xd, ym - 0.9), (xd, yb + 0.15), w: 1.6pt, head: 1.2)
      result(yb, c-accent)
      line((xr, yt - 0.85), (xr, yb + 0.85), stroke: (paint: c-jet, thickness: 1.5pt, dash: "dashed"))
      circle((xr, ym), radius: 0.62, fill: c-jet, stroke: none)
      content((xr, ym), text(size: 17pt, fill: white, weight: "bold", "=?"))
    }
  })
  stepcap(s, (
    [元のコードとデータから結果を作り, 分析の手順を論文に書く],
    [別の AI が, 元のコードも元データも見ずに, 論文の記述だけで実装し直す],
    [同じデータで結果が一致すれば, 論文の再現性が確認できる],
  ))
}

// ---- 2. The four steps ---------------------------------------------------------
#let anim-cleanroom(s) = {
  stage(26, 10.8, {
    import cetz.draw: *
    let zone(x0, x1, title) = {
      rect((x0, 0.15), (x1, 10.7), radius: 8pt, stroke: (paint: c-muted.lighten(30%), thickness: 1pt, dash: "dashed"))
      content(((x0 + x1) / 2, 10.25), lab(title, size: 11pt, weight: "medium", fill: c-muted))
    }
    let node(pos, w, title, sub, fill: white, tc: c-jet, sc: c-muted) = bnode(pos, w, 1.5, title, sub: sub, fill: fill, tc: tc, sc: sc, size: 10.5pt, sub-size: 9pt, stroke: if fill == white { 1.1pt + c-jet } else { none })
    let step(pos, k) = chip(pos, "Step " + str(k), fill: c-accent2, size: 9pt, anchor: "west")
    zone(0.2, 9.5, "自分のプロジェクト")
    zone(10.5, 25.8, "クリーンルーム")
    // Step 0: the finished paper.
    node((4.85, 8.6), 7.6, "論文 + パイプライン", "数値はインラインコード")
    step((1.05, 9.5), 0)
    if s >= 2 {
      // Step 1: mask the numbers, make dummy data, keep the answers.
      arrow((4.85, 7.8), (4.85, 7.2), w: 1.6pt, head: 1.2)
      node((4.85, 6.4), 7.6, "数値とデータを伏せる", "数値は ID に, データはダミーに")
      step((1.05, 7.3), 1)
      arrow((4.85, 5.6), (4.85, 5.0), w: 1.6pt, head: 1.2)
      node((4.85, 4.2), 7.6, "answer.csv + 元データ", "手元に残す")
      arrow((8.75, 6.7), (11.1, 8.3), w: 1.6pt, head: 1.2)
      arrow((8.75, 6.3), (11.1, 6.4), w: 1.6pt, head: 1.2)
      node((14.5, 8.6), 6.6, "数値を伏せた論文", "数値の代わりに ID")
      node((14.5, 6.4), 6.6, "ダミーデータ", "列名と型は同じ, 値は別物")
    }
    if s >= 3 {
      // Step 2: the replicator works inside the room.
      node((14.5, 4.2), 6.6, "TASK.md, AGENTS.md", "作業の指示と規則")
      for y in (8.6, 6.4, 4.2) { arrow((17.9, y), (19.5, 6.4 + (y - 6.4) * 0.2), w: 1.6pt, head: 1.2) }
      node((22.6, 6.4), 5.9, "別の AI", "コードも元データも見ない", fill: c-accent, tc: white, sc: white)
      step((19.8, 7.3), 2)
      arrow((21.6, 5.6), (16.4, 2.4), w: 1.6pt, head: 1.2)
      arrow((22.9, 5.6), (22.9, 2.4), w: 1.6pt, head: 1.2)
      node((14.9, 1.6), 7.4, "再現コード", "ダミーデータで動作確認")
      node((22.6, 1.6), 5.9, "ambiguity.md", "論文が決めていない点")
    }
    if s >= 4 {
      // Step 3: compare, and read the list of open points.
      arrow((4.85, 3.4), (4.85, 2.4), w: 1.6pt, head: 1.2)
      node((4.85, 1.6), 7.6, "実行, 照合, 仕分け", "元データは手元で使う")
      step((1.05, 2.5), 3)
      arrow((11.1, 1.6), (8.75, 1.6), w: 1.6pt, head: 1.2)
      arrow-path((22.6, 0.8), (22.6, 0.45), (4.85, 0.45), (4.85, 0.8), w: 1.6pt, head: 1.2)
    }
    if s >= 5 {
      // Back to step 0, and what may be said to the replicator.
      arrow-path((1.0, 1.6), (0.55, 1.6), (0.55, 8.6), (1.0, 8.6), col: c-accent2, w: 2pt, head: 1.2)
      arrow-path((8.75, 2.0), (10.0, 2.85), (19.4, 2.85), (20.5, 5.6), col: c-accent2, w: 1.8pt, head: 1.2, dash: "dashed")
      content((13.2, 2.85), box(fill: white, inset: (x: 4pt, y: 2pt), lab("ID と節だけ伝える", size: 9.5pt, fill: c-accent2, weight: "medium")))
    }
  })
  stepcap(s, (
    [Step 0: 論文を書き上げる. 数値はすべてインラインコードで埋め込まれている],
    [Step 1: 論文の数値と元データを伏せる. 答えは手元に残す],
    [Step 2: 別の AI が, 伏せた論文とダミーデータでコードを書く],
    [Step 3: 元データで実行した値を答えと照らし, 曖昧な点の一覧も読む],
    [
      自分の誤りは直して Step 0 に戻る. 再現側の誤りは ID と論文の節だけを伝える
    ],
  ), height: 2em)
}

// ---- 3. Step 1: what is handed over and what stays ------------------------------
// A caption above a box: what it is on the left, where it goes on the right.
// `code` sets the name in the monospace font, for a file name.
#let dest-heading(x0, x1, y, what, dest, col, code: false) = {
  let name = if code { mono } else { lab }
  d.content((x0, y), anchor: "west", name(what, size: 10.5pt, fill: c-muted))
  d.content((x1, y), anchor: "east", lab(dest, size: 10.5pt, fill: col, weight: "medium"))
}

// ---- 3a. Masking: every number becomes an ID ----------------------------------
// The sentence is an English manuscript, so it stays in English. Its numbers are
// shown as inline code: that is what lets a script replace them with IDs.
#let fig-mask(ax) = stage(26, 7.5, {
  import cetz.draw: *
  let num(body, fill, tc) = box(fill: fill, radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, mono(body, size: 11.5pt, fill: tc))
  let sentence(x0, x1, y, a, b, fill, tc, edge) = {
    rect((x0, y - 0.9), (x1, y + 0.9), radius: 3pt, fill: white, stroke: 1.2pt + edge)
    content((x0 + 0.5, y), anchor: "west", {
      lab("The coefficient on Black × Wilson is ", size: 12pt)
      num(a, fill, tc)
      lab(" (", size: 12pt)
      num(b, fill, tc)
      lab(").", size: 12pt)
    })
  }
  content((3.9, 6.95), anchor: "west", lab("論文 (.qmd)", size: 10.5pt, fill: c-muted))
  sentence(3.9, 22.1, 5.65, "`r did$est`", "`r did$se`", c-accent.lighten(78%), c-jet, c-jet)
  for x in (8.3, 21.4) {
    arrow-path((13.0, 4.65), (13.0, 3.95), (x, 3.95), (x, 2.25), w: 1.6pt, head: 1.2)
  }
  // The masked manuscript is the only version the clean room sees.
  dest-heading(0.3, 16.3, 2.6, "数値を伏せた論文", "クリーンルームに渡す", c-accent)
  sentence(0.3, 16.3, 1.25, "[R-042]", "[R-043]", c-jet, white, c-accent)
  // The answer key stays behind.
  dest-heading(17.1, 25.7, 2.6, "answer.csv", "手元に残す", c-accent2, code: true)
  rect((17.1, 0.35), (25.7, 2.15), radius: 3pt, fill: white, stroke: 1.2pt + c-accent2)
  content((17.6, 1.63), anchor: "west", mono("R-042, " + ax.did3 + ", did$est", size: 10.5pt))
  content((17.6, 0.87), anchor: "west", mono("R-043, " + ax.did3_se + ", did$se", size: 10.5pt))
})

// ---- 3b. Dummy data: preserve the schema, not the observed values ------------
// All rows below are illustrative, not records from the research data.
#let fig-dummy-data() = stage(26, 5.2, {
  import cetz.draw: *
  let data-panel(x, rows, col) = {
    rect((x, 0.3), (x + 9.8, 4.3), radius: 6pt, fill: white, stroke: 1.2pt + col)
    content((x + 4.9, 2.3), box(width: 9cm, {
      set text(font: "Fira Code", size: 14pt, ligatures: false, features: (calt: 0))
      std.table(
        columns: (1.2cm, 1.6cm, 1.8cm, 3.2cm, 1.2cm),
        stroke: none,
        inset: (x: 1pt, y: 5pt),
        table.header([id], [year], [black], [log_salary], [cem]),
        table.hline(stroke: 0.7pt + c-faint),
        ..rows.flatten().map(v => text(fill: col, v)),
      )
    }))
  }
  dest-heading(0.3, 10.1, 4.75, "元データ", "手元に残す", c-accent2)
  data-panel(0.3, (
    ("1", "1911", "0", "7.25", "1.4"),
    ("1", "1913", "0", "7.56", "1.4"),
    ("2", "1911", "1", "6.93", "0.8"),
  ), c-accent2)
  dest-heading(15.9, 25.7, 4.75, "ダミーデータ", "クリーンルームに渡す", c-accent)
  data-panel(15.9, (
    ("501", "1911", "1", "8.31", "1.0"),
    ("501", "1913", "1", "8.96", "1.0"),
    ("502", "1911", "0", "5.12", "0.7"),
  ), c-accent)
  // The header row crosses, at the height of the header; the value rows do not.
  arrow((10.4, 3.5), (15.6, 3.5), col: c-accent, w: 1.8pt, head: 1.2)
  content((13.0, 4.05), lab("列名と型", size: 11pt, weight: "medium", fill: c-accent))
  arrow((10.4, 1.9), (15.6, 1.9), col: c-accent2, dash: "dashed", w: 1.4pt)
  cross-mark(13.0, 1.9, s: 1.6, col: c-accent2)
  content((13.0, 2.45), lab("値", size: 11pt, weight: "medium", fill: c-accent2))
})

// ---- 4. Step 2: code is written inside; real-data execution is outside --------
#let anim-replicator(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let zone(x0, x1, title, col) = {
      rect((x0, 0.15), (x1, 10.05), radius: 8pt, stroke: (paint: col, thickness: 1pt, dash: "dashed"))
      content(((x0 + x1) / 2, 9.55), lab(title, size: 11.5pt, weight: "medium", fill: col))
    }
    let node(pos, w, title, sub, col: c-jet) = bnode(pos, w, 1.5, title, sub: sub, stroke: 1.1pt + col, size: 11pt, sub-size: 9.5pt)
    zone(0.2, 11.0, "自分のプロジェクト", c-muted)
    zone(12.0, 25.8, "クリーンルーム", c-accent)
    node((5.0, 7.6), 6.0, "元データ", "AI には渡さない", col: c-accent2)
    node((5.0, 5.5), 8.0, "元のコード + answer.csv", "手元に残す", col: c-accent2)
    for (x, y) in ((8.2, 7.6), (9.2, 5.5)) {
      arrow((x, y), (11.6, y), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(12.0, y, s: 1.6, col: c-accent2)
    }
    node((15.4, 8.1), 5.8, "数値を伏せた論文", "数値の代わりに ID", col: c-accent)
    node((15.4, 6.1), 5.8, "ダミーデータ", "列名と型は同じ, 値は別物", col: c-accent)
    node((15.4, 4.1), 5.8, "TASK.md, AGENTS.md", "指示と, 外を読まない規則", col: c-accent)
    rect((19.7, 5.0), (25.3, 7.3), radius: 6pt, fill: c-accent, stroke: none)
    ai-icon((20.8, 6.05), s: 0.85, col: white, face: c-accent)
    content((21.8, 6.4), anchor: "west", lab("別の AI", size: 11.5pt, weight: "medium", fill: white))
    content((21.8, 5.7), anchor: "west", lab("再現する側", size: 10pt, fill: white))
    for y in (8.1, 6.1, 4.1) {
      arrow((18.45, y), (19.5, 6.15 + (y - 6.1) * 0.25), col: c-accent, w: 1.5pt, head: 1.2)
    }
    // The two things the room produces.
    arrow-path((21.5, 4.85), (19.0, 2.9), (16.0, 2.9), (15.4, 2.75), col: c-accent, w: 1.6pt, head: 1.2)
    node((15.4, 1.9), 5.8, "再現コード", "ダミーデータで動作確認", col: c-accent)
    arrow((22.6, 4.85), (22.6, 2.75), col: c-accent, w: 1.6pt, head: 1.2)
    node((22.6, 1.9), 5.8, "ambiguity.md", "論文が決めていない点", col: c-accent)
    if s >= 2 {
      // Only code leaves the room. The researcher runs it without the AI.
      arrow-path((12.3, 1.9), (11.5, 1.9), (11.5, 3.4), (9.2, 3.4), col: c-accent, w: 1.8pt, head: 1.2)
      node((5.0, 3.4), 8.0, "再現コードを実行", "元データで, AI を介さずに", col: c-accent)
      arrow-path((1.8, 7.6), (0.65, 7.6), (0.65, 3.4), (0.9, 3.4), col: c-accent, w: 1.8pt, head: 1.2)
      arrow((5.0, 2.55), (5.0, 2.05), col: c-accent, w: 1.8pt, head: 1.2)
      node((5.0, 1.15), 8.0, "replication.csv", "元データで計算した各 ID の値", col: c-accent)
    }
  })
  stepcap(s, (
    [別の AI が伏せた論文とダミーデータで実装し, 論文で決まらない点を一覧にする],
    [返ってきたコードは, 研究者が元データで実行し, 数値を作る],
  ))
}

// ---- 5. Why the answers are hidden --------------------------------------------
// Positions on the line are made up; the drawing is tagged as an illustration.
#let anim-tuning(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let panel(x0, title, col) = {
      rect((x0, 0.5), (x0 + 12.4, 9.9), radius: 8pt, fill: col.lighten(90%), stroke: none)
      content((x0 + 0.5, 9.25), anchor: "west", lab(title, size: 12pt, weight: "medium", fill: col))
      line((x0 + 0.8, 5.6), (x0 + 11.6, 5.6), stroke: 1.2pt + c-jet)
      content((x0 + 11.9, 9.25), anchor: "east", lab("a dot: one estimate", size: 9pt, fill: c-muted))
    }
    let dot(x, label, col, above: true) = {
      circle((x, 5.6), radius: 0.22, fill: col, stroke: none)
      content((x, if above { 6.55 } else { 4.5 }), box(width: 2.6cm, align(center, {
        set par(leading: 0.45em)
        lab(label, size: 9.5pt, fill: col)
      })))
    }
    let hop(a, b) = bezier((a, 5.9), (b, 5.9), ((a + b) / 2, 7.6), stroke: (paint: c-accent2, thickness: 1.5pt, dash: "dashed"), mark: (end: ">", fill: c-accent2))
    // With the answer in view.
    panel(0.3, "The answer is visible", c-accent2)
    line((10.6, 5.2), (10.6, 6.0), stroke: 2.2pt + c-jet)
    content((10.6, 8.3), lab("the target", size: 9.5pt))
    line((10.6, 7.9), (10.6, 6.15), stroke: (paint: c-jet, thickness: 1pt, dash: "dotted"))
    dot(2.2, "as the paper says", c-jet, above: false)
    if s >= 2 {
      hop(2.2, 5.0)
      hop(5.0, 7.8)
      hop(7.8, 10.6)
      dot(5.0, "add a fixed effect", c-accent2, above: false)
      dot(7.8, "trim the sample", c-accent2, above: false)
      circle((10.6, 5.6), radius: 0.22, fill: c-accent2, stroke: none)
      content((6.5, 2.0), box(fill: c-accent2, radius: 4pt, inset: (x: 8pt, y: 5pt), lab("it matches, for the wrong reason", size: 10.5pt, fill: white, weight: "medium")))
    }
    if s >= 3 {
      // With the answer masked.
      panel(13.3, "The answer is masked", c-ok)
      dot(15.2, "as the paper says", c-jet, above: false)
      content((23.6, 8.3), mono("[R-042]", size: 10.5pt, fill: c-muted))
      doc-icon((16.2, 2.3), w: 1.0, h: 1.25, lines: 3)
      content((17.1, 2.3), anchor: "west", box(width: 8.0cm, {
        set par(leading: 0.45em)
        lab("one estimate, and a list of what the paper left open", size: 10.5pt)
      }))
    }
  })
  stepcap(s, (
    [答えの数字を渡すと, 再現する側の AI は, その値に合うようにコードを書いてしまう],
    [仕様を勝手に変えて数字を合わせると, 誤りが見かけの一致に隠れる],
    [答えを伏せれば数値を合わせられず, 論文の曖昧な点も報告される],
  ))
}

// ---- 6. Triage of the mismatches ----------------------------------------------
#let fig-triage() = {
  // How many identifiers fall in each class is made up.
  let classes = ("exact",) * 17 + ("close",) * 4 + ("mismatch",) * 3
  let ccol = (exact: c-ok, close: c-outdated, mismatch: c-accent2)
  let causes = (
    (title: "元のコードが論文と違う", act: "コードか記述を直す", next: "Step 0 に戻る"),
    (title: "論文に書いていない処理がある", act: "定義を決め, 論文に書く", next: "Step 0 に戻る"),
    (title: "再現する側の誤り", act: "ID と論文の節だけ伝える\n値やずれの方向は伝えない", next: "Step 2 をやり直す"),
  )
  stage(26, 7.7, {
    import cetz.draw: *
    for (i, c) in classes.enumerate() {
      rect((0.4 + i * 0.72, 6.3), (0.4 + i * 0.72 + 0.56, 6.86), radius: 2pt, fill: ccol.at(c), stroke: none)
    }
    content((0.4, 7.35), anchor: "west", lab("replication.csv の各 ID を answer.csv と照合", size: 10pt, fill: c-muted))
    for (x, c, name) in ((18.6, "exact", "一致"), (20.5, "close", "許容範囲内"), (23.7, "mismatch", "不一致")) {
      rect((x, 6.4), (x + 0.36, 6.76), radius: 2pt, fill: ccol.at(c), stroke: none)
      content((x + 0.5, 6.58), anchor: "west", lab(name, size: 9.5pt, fill: c-muted))
    }
    for (k, c) in causes.enumerate() {
      let x = 4.45 + k * 8.55
      arrow((0.4 + (21 + k) * 0.72 + 0.28, 6.2), (x, 4.9), col: c-accent2, w: 1.5pt, head: 1.2)
      rect((x - 4.05, 0.3), (x + 4.05, 4.7), radius: 7pt, fill: c-panel, stroke: none)
      content((x, 3.9), lab(c.title, size: 11.5pt, weight: "medium"))
      content((x, 2.55), box(width: 7.4cm, align(center, {
        set par(leading: 0.5em)
        lab(c.act, size: 10.5pt, fill: c-muted)
      })))
      chip((x, 1.05), c.next, fill: if k == 2 { c-accent } else { c-accent2 }, size: 10pt)
    }
  })
}
