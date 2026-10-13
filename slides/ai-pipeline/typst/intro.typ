// ===========================================================================
// Introduction: writing got cheap, checking did not; four tools to check with.
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
