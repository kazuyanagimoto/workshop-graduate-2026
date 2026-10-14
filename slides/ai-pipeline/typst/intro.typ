// ===========================================================================
// Introduction: writing got cheap, checking did not; four tools to check with.
// The closing summary is here too, since it returns to the same four tools.
// ===========================================================================
#import "lib.typ": *

// ---- Writing vs checking -----------------------------------------------------
// Block lengths carry no data.
#let anim-cost() = {
  stage(26, 8.6, {
    import cetz.draw: *
    // Trim the empty bottom margin while keeping the drawing's size and position.
    translate(y: -1.6)
    let x-start = 4.6
    let w-check = 7.8
    let row(y, name, w-write, strong) = {
      content((0.2, y), anchor: "west", lab(name, size: 14pt, weight: "medium"))
      rect((x-start, y - 0.85), (x-start + w-write, y + 0.85), radius: 5pt, fill: c-accent.lighten(55%), stroke: none)
      content((x-start + w-write / 2, y), lab(if w-write > 4 { "Write the code" } else { "Write" }, size: 14pt))
      let x0 = x-start + w-write + 0.25
      rect((x0, y - 0.85), (x0 + w-check, y + 0.85), radius: 5pt, fill: if strong { c-accent2 } else { c-accent2.lighten(60%) }, stroke: none)
      content((x0 + w-check / 2, y), lab("Check the result", size: 14pt, fill: if strong { white } else { c-jet }))
    }
    row(9.0, "Before AI", 12.4, false)
    row(6.4, "With AI", 2.6, true)
    let x0 = x-start + 2.6 + 0.25
    line((x0, 5.3), (x0, 5.0), (x0 + w-check, 5.0), (x0 + w-check, 5.3), stroke: 1.4pt + c-accent2)
    let qs = (
      "仕様は意図どおりか?",
      "サンプルは正しく絞れているか?",
      "数値は今のコードの実行結果か?",
    )
    for (i, q) in qs.enumerate() {
      content((x0 + 0.2, 4.1 - i * 1.0), anchor: "west", lab(q, size: 14pt))
    }
    content((x0 + w-check + 0.5, 6.4), anchor: "west", lab("確かめるのは研究者の仕事", size: 14pt, fill: c-accent2, weight: "medium"))
  })
}

// ---- Four tools, four standards to check against -----------------------------
// `final: true` draws the closing version, with {targets} emphasised.
#let anim-four-tools(final: false) = {
  let tools = (
    (pos: (5.4, 7.2), name: "Git", logo: "../img/logos/git.svg", q: "何が変わり, どこに戻せるか?"),
    (pos: (20.6, 7.2), name: "Zotero", logo: "../img/logos/zotero.png", q: "文献には何が書かれているか?"),
    (pos: (5.4, 1.8), name: "{targets}", logo: "../img/logos/targets.png", q: "どのデータとコードで計算したか?"),
    (pos: (20.6, 1.8), name: "Quarto", logo: "../img/logos/quarto.svg", q: "本文の数値は最新の結果と一致するか?"),
  )
  stage(26, 9.0, {
    import cetz.draw: *
    for (i, t) in tools.enumerate() {
      let (x, y) = t.pos
      let star = final and i == 2
      line(
        (13, 4.5),
        (x + (if x < 13 { 4.2 } else { -4.2 }), y + (if y > 4.5 { -1.2 } else { 1.2 })),
        stroke: (paint: c-accent, thickness: 1.5pt, dash: "dashed"),
      )
      rect((x - 5.3, y - 1.6), (x + 5.3, y + 1.6), radius: 7pt, fill: if star { c-accent } else { c-tint }, stroke: none)
      content((x, y + 0.8), std.grid(
        columns: (1.2cm, auto),
        column-gutter: 0.3cm,
        align: horizon,
        image(t.logo, width: 1.2cm, height: 1.2cm, fit: "contain", alt: t.name + " logo"),
        lab(t.name, size: 17pt, weight: "medium", fill: if star { white } else { c-accent.darken(15%) }),
      ))
      content((x, y - 0.5), box(width: 9.8cm, align(center, {
        set par(leading: 0.45em)
        lab(t.q, size: 12pt, fill: if star { white } else { c-jet })
      })))
    }
    circle((13, 4.5), radius: 1.7, fill: white, stroke: 1.5pt + c-jet)
    ai-icon((13, 4.85), s: 1.05)
    content((13, 3.6), lab("AI Output", weight: "medium"))
  })
}

// ---- Summary: three stages resting on Git -------------------------------------
// Each card repeats, in miniature, the drawing of its part of the deck. The
// commit history under them is what all three rest on.
#let fig-summary() = stage(26, 10.6, {
  import cetz.draw: *
  let logo(file, name, size: 0.8cm) = image("../img/logos/" + file, width: size, height: size, fit: "contain", alt: name + " logo")
  let tool(body) = lab(body, size: 11pt, weight: "medium")
  let row(..cells) = std.grid(columns: cells.pos().len(), column-gutter: 0.2cm, align: horizon, ..cells)
  let (y0, y1, yp, yg) = (3.4, 10.4, 6.45, 1.9)
  let flow(a, b, col: c-muted) = arrow((a, yp), (b, yp), col: col, w: 1.5pt, head: 1.1)

  // Git: the history line, with one commit under each stage.
  rect((0.2, 0.3), (25.8, 2.75), radius: 7pt, fill: c-panel, stroke: none)
  content((0.75, 1.52), anchor: "west", row(logo("git.svg", "Git", size: 1.15cm), lab("Git", size: 17pt, weight: "medium")))
  line((4.0, yg), (25.2, yg), stroke: 2.2pt + c-jet, mark: (end: ">", fill: c-jet, scale: 1.2))
  for x in (7.3, 10.15, 15.85, 18.7, 24.0) {
    circle((x, yg), radius: 0.17, fill: white, stroke: 1.8pt + c-jet)
  }
  content((14.6, 0.95), lab("すべての変更を記録し, いつでも戻せる", size: 11.5pt))

  let cards = (
    (x: 4.4, title: "文献調査", line: "根拠のページを確かめる"),
    (x: 13.0, title: "ワークフロー", line: "数値が最新かを確かめる"),
    (x: 21.6, title: "検証", line: "再現できるかを確かめる"),
  )
  for (k, c) in cards.enumerate() {
    let x = c.x
    line((x, y0), (x, yg), stroke: 1.8pt + c-accent)
    circle((x, yg), radius: 0.25, fill: c-accent, stroke: 1.5pt + c-panel)
    rect((x - 3.8, y0), (x + 3.8, y1), radius: 7pt, fill: c-tint, stroke: none)
    content((x, 9.7), row(
      box(fill: c-accent, radius: 4pt, inset: (x: 7pt, y: 4pt), text(size: 11pt * fs, fill: white, weight: "medium", str(k + 1))),
      lab(c.title, size: 14pt, weight: "medium", fill: c-accent.darken(15%)),
    ))
    content((x, 4.15), lab(c.line, size: 11pt))
    if k < 2 { arrow((x + 3.95, yp), (x + 4.65, yp), col: c-accent, w: 2pt, head: 1.3) }
  }

  // 1. Zotero: the AI reads the full text and answers with a page to check.
  let x = cards.at(0).x
  content((x, 8.55), row(logo("zotero.png", "Zotero"), tool("Zotero")))
  doc-icon((x - 2.75, yp + 0.12), w: 0.9, h: 1.15, stroke: 1pt + c-accent.darken(10%))
  doc-icon((x - 2.45, yp - 0.12), w: 0.9, h: 1.15, lines: 3, stroke: 1pt + c-accent.darken(10%))
  flow(x - 1.75, x - 1.05)
  ai-icon((x - 0.35, yp - 0.1), s: 0.95)
  flow(x + 0.35, x + 1.05)
  rect((x + 1.2, yp - 0.85), (x + 3.2, yp + 0.85), radius: 3pt, fill: white, stroke: 1.1pt + c-jet)
  line((x + 1.45, yp + 0.5), (x + 2.95, yp + 0.5), stroke: 1.6pt + c-faint)
  line((x + 1.45, yp + 0.2), (x + 2.6, yp + 0.2), stroke: 1.6pt + c-faint)
  content((x + 2.2, yp - 0.35), box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 4pt, y: 2.5pt), lab("p. 926", size: 9.5pt)))

  // 2. {targets} + Quarto: every target and the manuscript are up to date.
  let x = cards.at(1).x
  content((x, 8.55), row(logo("targets.png", "targets"), tool("{targets}"), tool("+"), logo("quarto.svg", "Quarto"), tool("Quarto")))
  let px = (x - 3.1, x - 1.55, x)
  for (i, p) in px.enumerate() {
    if i > 0 { flow(px.at(i - 1) + 0.5, p - 0.5) }
    circle((p, yp), radius: 0.38, fill: c-ok, stroke: none)
    check-mark(p, yp, w: 2pt)
  }
  flow(x + 0.5, x + 1.6)
  doc-icon((x + 2.4, yp), w: 1.3, h: 1.65, fill: c-ok, stroke: 1.2pt + c-ok, lines: 3, line-col: white.transparentize(50%))
  circle((x + 2.4, yp - 0.12), radius: 0.3, fill: white, stroke: none)
  check-mark(x + 2.4, yp - 0.12, s: 0.75, col: c-ok, w: 1.8pt)

  // 3. Clean room: another AI rebuilds the results from the paper alone.
  let x = cards.at(2).x
  content((x, 8.55), tool("クリーンルーム"))
  doc-icon((x - 2.65, yp), w: 0.95, h: 1.2, lines: 3, stroke: 1.2pt + c-accent)
  flow(x - 2.0, x - 1.35, col: c-accent)
  rect((x - 1.2, yp - 0.95), (x + 0.9, yp + 0.95), radius: 6pt, fill: white, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
  ai-icon((x - 0.15, yp - 0.1), s: 0.95)
  flow(x + 1.05, x + 1.7, col: c-accent)
  circle((x + 2.45, yp), radius: 0.55, fill: c-jet, stroke: none)
  content((x + 2.45, yp), text(size: 15pt, fill: white, weight: "bold", "=?"))
})
