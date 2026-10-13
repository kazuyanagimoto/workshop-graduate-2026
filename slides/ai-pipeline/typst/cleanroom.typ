// ===========================================================================
// Part 5: the clean room. Another AI rebuilds the results from the paper alone.
//
// `ax` is the dictionary of numbers the deck builds from data/*.csv.
// ===========================================================================
#import "lib.typ": *

// ---- 0. Software origins: independent implementation from a specification ----
// The Compaq BIOS example is described by its founder in the PBS interview.
// This avoids copying copyrighted code; it does not clear patent rights.
#let anim-software-cleanroom(s) = {
  stage(26, 9.2, {
    import cetz.draw: *
    // The original implementation is available only to the analysis team.
    doc-icon((2.0, 6.2), w: 1.6, h: 2.0, lines: 4)
    content((2.0, 7.85), lab("IBM PC BIOS", size: 11.5pt, weight: "medium"))
    content((2.0, 4.65), lab("copyrighted code", size: 10pt, fill: c-accent2))
    if s >= 2 {
      arrow((3.05, 6.2), (4.5, 6.2), w: 1.6pt, head: 1.2)
      rect((4.7, 5.0), (10.1, 7.4), radius: 6pt, fill: c-panel, stroke: none)
      person-icon((5.8, 6.1), s: 0.85, col: c-muted)
      content((6.7, 6.6), anchor: "west", lab("Team A", size: 12pt, weight: "medium"))
      content((6.7, 5.85), anchor: "west", lab("study behavior", size: 10.5pt))
      content((7.4, 8.1), lab("May inspect the original code", size: 10pt, fill: c-muted))
      arrow((10.3, 6.2), (11.95, 6.2), w: 1.6pt, head: 1.2)
      doc-icon((13.0, 6.2), w: 1.4, h: 1.8, lines: 3, stroke: 1.3pt + c-accent)
      content((13.0, 7.85), lab("Functional spec", size: 11pt, weight: "medium", fill: c-accent))
      content((13.0, 4.65), lab("inputs / outputs", size: 10pt, fill: c-muted))
    }
    if s >= 3 {
      // Only the functional specification may cross the boundary.
      rect((15.3, 0.4), (25.7, 9.0), radius: 8pt, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
      content((20.5, 8.4), lab("Clean room", size: 12pt, weight: "medium", fill: c-accent))
      arrow((14.05, 6.2), (16.3, 6.2), col: c-accent, w: 1.8pt, head: 1.2)
      rect((16.5, 5.0), (24.0, 7.4), radius: 6pt, fill: white, stroke: 1.2pt + c-accent)
      person-icon((17.7, 6.1), s: 0.85, col: c-accent)
      content((18.7, 6.6), anchor: "west", lab("Team B", size: 12pt, weight: "medium"))
      content((18.7, 5.85), anchor: "west", lab("code from the spec", size: 10.5pt))
      content((20.25, 4.45), lab("Has never seen the original code", size: 10pt, fill: c-accent))
      arrow-path((3.05, 5.5), (4.3, 4.7), (4.3, 3.25), (14.9, 3.25), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(15.3, 3.25, s: 1.7, col: c-accent2)
      content((9.3, 3.85), lab("No original code crosses", size: 11pt, fill: c-accent2, weight: "medium"))
    }
    if s >= 4 {
      arrow((20.25, 4.0), (20.25, 2.9), col: c-accent, w: 1.8pt, head: 1.2)
      bnode((20.25, 1.85), 7.5, 1.7, "New BIOS", sub: "same behavior, new code", size: 12pt, sub-size: 10.5pt, stroke: 1.2pt + c-accent)
    }
  })
  stepcap(s, (
    [IBM PC の BIOS と同じ機能を, コードをコピーせずに作りたい],
    [調査チームが動作を調べ, 入力と出力の仕様書を書く],
    [元のコードを見ていない実装チームに, 仕様書だけを渡す],
    [
      別のコードで同じ機能を作り, コードのコピーによる著作権侵害を避ける.
      #linebreak()
      独立実装でも, 特許侵害の可能性は残る.
    ],
  ), height: 3em)
  block(above: 0pt, text(size: 12pt, fill: c-muted)[
    例: Compaq の互換 BIOS. 出典: #link("https://www.pbs.org/nerds/part2.html")[PBS, 創業者の証言]. 特許: #link("https://www.jpo.go.jp/support/ipr/kenrishingai.html")[特許庁の解説].
  ])
}

// ---- 1. Reproducible: the paper and the data are enough -----------------------
#let anim-repro(s) = {
  stage(26, 10.0, {
    import cetz.draw: *
    // The researcher executes both implementations on the same real data.
    // The real data is never an input to the AI that writes the new code.
    doc-icon((12.0, 5.1), w: 1.2, h: 1.5, tag: "data")
    content((10.9, 5.1), anchor: "east", lab("real data", size: 10.5pt))
    let row(y, col, code, result) = {
      doc-icon((5.7, y), w: 1.4, h: 1.75, lines: 3)
      content((5.7, y - 1.25), mono(code, size: 10.5pt))
      arrow((6.8, y), (9.3, y), w: 1.6pt, head: 1.2)
      rect((9.5, y - 0.9), (14.5, y + 0.9), radius: 7pt, fill: col.lighten(86%), stroke: none)
      person-icon((10.6, y), s: 0.8, col: col)
      content((11.5, y + 0.25), anchor: "west", lab("you run it", size: 11pt, weight: "medium"))
      content((11.5, y - 0.4), anchor: "west", lab("without AI", size: 9.5pt, fill: c-muted))
      arrow((14.7, y), (18.6, y), w: 1.6pt, head: 1.2)
      rect((18.8, y - 0.8), (22.6, y + 0.8), radius: 5pt, fill: white, stroke: 1.3pt + col)
      content((20.7, y), lab(result, size: 11pt))
    }
    row(7.6, c-accent, "code A", "results A")
    content((5.7, 9.15), lab("your implementation", size: 10.5pt))
    arrow((12.0, 6.0), (12.0, 6.5), w: 1.6pt, head: 1.2)
    if s >= 2 {
      doc-icon((1.6, 2.6), w: 1.4, h: 1.75, lines: 4)
      content((1.6, 1.3), lab("masked paper", size: 10pt))
      arrow((2.7, 2.6), (4.6, 2.6), w: 1.6pt, head: 1.2)
      row(2.6, c-pink, "code B", "results B")
      content((5.7, 4.15), lab("independent implementation", size: 10.5pt))
      content((5.7, 0.45), lab("written on dummy data", size: 9.5pt, fill: c-muted))
      arrow((12.0, 4.2), (12.0, 3.7), w: 1.6pt, head: 1.2)
    }
    if s >= 3 {
      line((20.7, 6.6), (20.7, 3.6), stroke: (paint: c-jet, thickness: 1.5pt, dash: "dashed"))
      circle((20.7, 5.1), radius: 0.62, fill: c-jet, stroke: none)
      content((20.7, 5.1), text(size: 17pt, fill: white, weight: "bold", "=?"))
    }
  })
  stepcap(s, (
    [手元の元データでコードを動かすと, 論文の数値ができる],
    [別の実装を同じ元データで動かし, 同じ結果になるかを確かめる],
    [実装する AI には, 数値を伏せた論文とダミーデータだけを渡す],
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
    zone(0.2, 9.5, "Your project")
    zone(10.5, 25.8, "Clean room: another AI")
    // Step 0: the finished paper.
    node((4.85, 8.6), 7.6, "manuscript + pipeline", "numbers as inline code")
    step((1.05, 9.5), 0)
    if s >= 2 {
      // Step 1: mask the numbers, make dummy data, keep the answers.
      arrow((4.85, 7.8), (4.85, 7.2), w: 1.6pt, head: 1.2)
      node((4.85, 6.4), 7.6, "masking scripts", "numbers to IDs, dummy data")
      step((1.05, 7.3), 1)
      arrow((4.85, 5.6), (4.85, 5.0), w: 1.6pt, head: 1.2)
      node((4.85, 4.2), 7.6, "answer.csv + real data", "kept outside the clean room")
      arrow((8.75, 6.7), (11.1, 8.3), w: 1.6pt, head: 1.2)
      arrow((8.75, 6.3), (11.1, 6.4), w: 1.6pt, head: 1.2)
      node((14.5, 8.6), 6.6, "masked manuscript", "numbers replaced by IDs")
      node((14.5, 6.4), 6.6, "dummy data", "same schema, unrelated values")
    }
    if s >= 3 {
      // Step 2: the replicator works inside the room.
      node((14.5, 4.2), 6.6, "TASK.md, AGENTS.md", "the task and the rules")
      for y in (8.6, 6.4, 4.2) { arrow((17.9, y), (19.5, 6.4 + (y - 6.4) * 0.2), w: 1.6pt, head: 1.2) }
      node((22.6, 6.4), 5.9, "replicator", "no original code or data", fill: c-accent, tc: white, sc: white)
      step((19.8, 7.3), 2)
      arrow((21.6, 5.6), (16.4, 2.4), w: 1.6pt, head: 1.2)
      arrow((22.9, 5.6), (22.9, 2.4), w: 1.6pt, head: 1.2)
      node((14.9, 1.6), 7.4, "replication code", "checked on dummy data")
      node((22.6, 1.6), 5.9, "ambiguity.md", "what the paper left open")
    }
    if s >= 4 {
      // Step 3: compare, and read the list of open points.
      arrow((4.85, 3.4), (4.85, 2.4), w: 1.6pt, head: 1.2)
      node((4.85, 1.6), 7.6, "run, compare and triage", "real data stays outside")
      step((1.05, 2.5), 3)
      arrow((11.1, 1.6), (8.75, 1.6), w: 1.6pt, head: 1.2)
      arrow-path((22.6, 0.8), (22.6, 0.45), (4.85, 0.45), (4.85, 0.8), w: 1.6pt, head: 1.2)
    }
    if s >= 5 {
      // Back to step 0, and what may be said to the replicator.
      arrow-path((1.0, 1.6), (0.55, 1.6), (0.55, 8.6), (1.0, 8.6), col: c-accent2, w: 2pt, head: 1.2)
      arrow-path((8.75, 2.0), (10.0, 2.85), (19.4, 2.85), (20.5, 5.6), col: c-accent2, w: 1.8pt, head: 1.2, dash: "dashed")
      content((13.2, 2.85), box(fill: white, inset: (x: 4pt, y: 2pt), lab("IDs and sections only", size: 9.5pt, fill: c-accent2, weight: "medium")))
    }
  })
  stepcap(s, (
    [Step 0: 論文を書き上げる. 数値はすべてインラインコードで埋め込まれている],
    [Step 1: 論文の数値と元データを伏せる. 答えは手元に残す],
    [Step 2: 別の AI が, 伏せた論文とダミーデータでコードを書く],
    [Step 3: 元データで実行した値を答えと照らし, 曖昧な点の一覧も読む],
    [
      自分側に誤りがあれば, 直して Step 0 に戻る.
      #linebreak()
      再現する側には, ID と論文の節だけを伝える.
    ],
  ), height: 2em)
}

// ---- 3. Masking: every number becomes an ID -----------------------------------
#let anim-mask(s, ax) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let num(body, fill, tc) = box(fill: fill, radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, mono(body, size: 11.5pt, fill: tc))
    let sentence(y, title, a, b, fill, tc) = {
      content((0.3, y + 1.15), anchor: "west", lab(title, size: 10.5pt, fill: c-muted))
      rect((0.3, y - 0.75), (25.7, y + 0.75), radius: 3pt, fill: white, stroke: 1.2pt + c-jet)
      content((0.8, y), anchor: "west", {
        lab("The coefficient on Black × Wilson is ", size: 12pt)
        num(a, fill, tc)
        lab(" (", size: 12pt)
        num(b, fill, tc)
        lab(").", size: 12pt)
      })
    }
    sentence(8.6, "the manuscript", ax.did3, ax.did3_se, c-accent.lighten(78%), c-jet)
    if s >= 2 {
      arrow((13, 7.7), (13, 6.75), col: c-accent, w: 2pt, head: 1.3)
      sentence(5.2, "the masked manuscript, the only version the clean room sees", "[R-042]", "[R-043]", c-jet, white)
      // The answer key stays behind.
      rect((0.3, 0.4), (12.6, 3.6), radius: 6pt, fill: c-tint, stroke: none)
      content((0.7, 3.05), anchor: "west", mono("answer.csv", size: 10.5pt, fill: c-accent.darken(15%)))
      content((12.3, 3.05), anchor: "east", lab("never leaves your project", size: 9.5pt, fill: c-accent.darken(15%)))
      content((0.7, 2.2), anchor: "west", mono("R-042, " + ax.did3 + ", coef(...)", size: 10.5pt))
      content((0.7, 1.4), anchor: "west", mono("R-043, " + ax.did3_se + ", se(...)", size: 10.5pt))
    }
  })
  stepcap(s, (
    [論文の数値は, すべてインラインコードから来ている],
    [スクリプトで数値を ID に置き換え, 値は答えの表に保存する],
  ))
}

// ---- 3b. Dummy data: preserve the schema, not the observed values ------------
// All rows below are illustrative, not records from the research data.
#let anim-dummy-data(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let data-panel(x, title, note, rows, col) = {
      rect((x, 4.0), (x + 9.8, 9.1), radius: 6pt, fill: white, stroke: 1.2pt + col)
      content((x + 0.45, 8.5), anchor: "west", lab(title, size: 12pt, weight: "medium", fill: col))
      content((x + 4.9, 6.4), box(width: 9cm, {
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
      content((x + 4.9, 4.6), lab(note, size: 10pt, fill: c-muted))
    }
    data-panel(0.3, "Real data: stays with you", "observed values are never shared", (
      ("1", "1911", "0", "7.25", "1.4"),
      ("1", "1913", "0", "7.56", "1.4"),
      ("2", "1911", "1", "6.93", "0.8"),
    ), c-accent2)
    if s >= 2 {
      arrow((10.3, 7.9), (15.5, 7.9), col: c-accent, w: 1.8pt, head: 1.2)
      content((13.0, 8.6), lab("Schema only", size: 11pt, weight: "medium", fill: c-accent))
      content((13.0, 6.65), box(width: 4.6cm, align(center, {
        set par(leading: 0.5em)
        lab("column names\ntypes\nrequired constraints", size: 10.5pt)
      })))
      data-panel(15.9, "Dummy data: shared with AI", "values are generated independently", (
        ("501", "1911", "1", "8.31", "1.0"),
        ("501", "1913", "1", "8.96", "1.0"),
        ("502", "1911", "0", "5.12", "0.7"),
      ), c-accent)
    }
    if s >= 3 {
      arrow((10.3, 4.55), (15.4, 4.55), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(13.0, 4.55, s: 1.6, col: c-accent2)
      arrow((20.8, 3.8), (20.8, 3.0), col: c-accent, w: 1.8pt, head: 1.2)
      bnode((20.8, 1.9), 9.8, 1.7, "Check that the code runs", sub: "follow the paper, not the real data", stroke: 1.2pt + c-accent, size: 11.5pt, sub-size: 10pt)
      content((5.2, 2.0), box(width: 9.2cm, align(center, {
        set par(leading: 0.5em)
        lab("Do not add filters or other choices\nbased on the observed values.", size: 11pt, fill: c-accent2)
      })))
    }
    illus-tag(26, 0.1)
  })
  stepcap(s, (
    [元データを見せると, 論文にない処理を足すおそれがある],
    [列名・型・必要な制約を揃え, 値は独立に生成する],
    [ダミーデータで, 論文どおりのコードが動くかを確かめる],
  ))
}

// ---- 4. Step 2: code is written inside; real-data execution is outside --------
#let anim-replicator(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
    let zone(x0, x1, title, col) = {
      rect((x0, 0.15), (x1, 10.05), radius: 8pt, stroke: (paint: col, thickness: 1pt, dash: "dashed"))
      content(((x0 + x1) / 2, 9.55), lab(title, size: 11.5pt, weight: "medium", fill: col))
    }
    let node(pos, w, title, sub, col: c-jet) = bnode(pos, w, 1.5, title, sub: sub, stroke: 1.1pt + col, size: 11pt, sub-size: 9.5pt)
    zone(0.2, 11.0, "Your project", c-muted)
    zone(12.0, 25.8, "Clean room: another AI", c-accent)
    node((5.0, 7.6), 6.0, "real data", "never given to the AI", col: c-accent2)
    node((5.0, 5.5), 8.0, "original code + answer.csv", "kept outside", col: c-accent2)
    for (x, y) in ((8.2, 7.6), (9.2, 5.5)) {
      arrow((x, y), (11.6, y), col: c-accent2, dash: "dashed", w: 1.4pt)
      cross-mark(12.0, y, s: 1.6, col: c-accent2)
    }
    node((15.4, 8.1), 5.8, "masked paper", "results replaced by IDs", col: c-accent)
    node((15.4, 6.1), 5.8, "dummy data", "same schema, new values", col: c-accent)
    node((15.4, 4.1), 5.8, "TASK.md, AGENTS.md", "no access outside", col: c-accent)
    rect((19.7, 5.0), (25.3, 7.3), radius: 6pt, fill: c-accent, stroke: none)
    ai-icon((20.8, 6.05), s: 0.85, col: white)
    content((21.8, 6.4), anchor: "west", lab("Replicator", size: 11.5pt, weight: "medium", fill: white))
    content((21.8, 5.7), anchor: "west", lab("another AI", size: 10pt, fill: white))
    for y in (8.1, 6.1, 4.1) {
      arrow((18.45, y), (19.5, 6.15 + (y - 6.1) * 0.25), col: c-accent, w: 1.5pt, head: 1.2)
    }
    if s >= 2 {
      arrow-path((21.5, 4.85), (19.0, 2.9), (16.0, 2.9), (15.4, 2.75), col: c-accent, w: 1.6pt, head: 1.2)
      node((15.4, 1.9), 5.8, "replication code", "dummy-data checks", col: c-accent)
    }
    if s >= 3 {
      arrow((22.6, 4.85), (22.6, 2.75), col: c-accent, w: 1.6pt, head: 1.2)
      node((22.6, 1.9), 5.8, "ambiguity.md", "choices left open", col: c-accent)
    }
    if s >= 4 {
      // Only code leaves the room. The researcher runs it without the AI.
      arrow-path((12.3, 1.9), (11.5, 1.9), (11.5, 3.4), (9.2, 3.4), col: c-accent, w: 1.8pt, head: 1.2)
      node((5.0, 3.4), 8.0, "run returned code", "on real data, without AI", col: c-accent)
      arrow-path((1.8, 7.6), (0.65, 7.6), (0.65, 3.4), (0.9, 3.4), col: c-accent, w: 1.8pt, head: 1.2)
      arrow((5.0, 2.55), (5.0, 2.05), col: c-accent, w: 1.8pt, head: 1.2)
      node((5.0, 1.15), 8.0, "replication.csv", "one real-data value per ID", col: c-accent)
    }
  })
  stepcap(s, (
    [渡すのは, 伏せた論文・ダミーデータ・指示と隔離ルールだけ],
    [別の AI が, 伏せた論文とダミーデータだけで実装する],
    [論文で決まらない点は, 判断と影響する ID を一覧にする],
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
    illus-tag(26, 0.05)
  })
  stepcap(s, (
    [答えの数字を渡すと, 再現する側の AI は, その値に合うようにコードを書いてしまう],
    [仕様を勝手に変えて数字を合わせると, 誤りが見かけの一致に隠れる],
    [答えを伏せれば数値を合わせられず, 論文の曖昧な点も報告される],
  ))
}

// ---- 6. Triage of the mismatches ----------------------------------------------
#let anim-triage(s) = {
  // How many identifiers fall in each class is made up.
  let classes = ("exact",) * 17 + ("close",) * 4 + ("mismatch",) * 3
  let ccol = (exact: c-ok, close: c-outdated, mismatch: c-accent2)
  let causes = (
    (title: "The code differs from the paper", act: "Fix the code or the text.", next: "back to Step 0"),
    (title: "The paper does not say what the code does", act: "Decide the definition and write it in the paper.", next: "back to Step 0"),
    (title: "The replicator made a mistake", act: "Tell it the ID and the section. Never the value or the direction.", next: "redo Step 2"),
  )
  stage(26, 10.4, {
    import cetz.draw: *
    for (i, c) in classes.enumerate() {
      rect((0.4 + i * 0.72, 9.0), (0.4 + i * 0.72 + 0.56, 9.56), radius: 2pt, fill: ccol.at(c), stroke: none)
    }
    content((0.4, 10.05), anchor: "west", lab("every ID in replication.csv against answer.csv", size: 10pt, fill: c-muted))
    for (i, c) in ("exact", "close", "mismatch").enumerate() {
      rect((18.6 + i * 2.5, 9.1), (18.96 + i * 2.5, 9.46), radius: 2pt, fill: ccol.at(c), stroke: none)
      content((19.1 + i * 2.5, 9.28), anchor: "west", lab(c, size: 9.5pt, fill: c-muted))
    }
    for (k, c) in causes.enumerate() {
      if s >= k + 2 {
        let x = 4.45 + k * 8.55
        arrow((0.4 + (21 + k) * 0.72 + 0.28, 8.9), (x, 7.6), col: c-accent2, w: 1.5pt, head: 1.2)
        rect((x - 4.05, 0.5), (x + 4.05, 7.4), radius: 7pt, fill: c-panel, stroke: none)
        content((x, 6.1), box(width: 7.4cm, align(center, {
          set par(leading: 0.5em)
          lab(c.title, size: 11.5pt, weight: "medium")
        })))
        content((x, 3.75), box(width: 7.4cm, align(center, {
          set par(leading: 0.5em)
          lab(c.act, size: 10.5pt, fill: c-muted)
        })))
        chip((x, 1.35), c.next, fill: if k == 2 { c-accent } else { c-accent2 }, size: 10pt)
      }
    }
    illus-tag(26, 0.0)
  })
  stepcap(s, (
    [再現された値を答えと照らし, 表示桁まで一致, 許容範囲内, 不一致に分ける],
    [不一致の原因その1: 元のコードが論文の記述と違う],
    [その2: 論文が, コードのしていることを書いていない],
    [その3: 再現する側の誤りでも, 答えやずれの方向は伝えない],
  ))
}
