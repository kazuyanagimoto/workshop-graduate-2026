// ===========================================================================
// Introduction: writing got cheap, checking did not; four tools to check with.
// ===========================================================================
#import "lib.typ": *

// ---- Writing vs checking -----------------------------------------------------
// Block lengths carry no data; the drawing is tagged as an illustration.
#let anim-cost(s) = {
  stage(26, 10.2, {
    import cetz.draw: *
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
    if s >= 2 { row(6.4, "With AI", 2.6, s >= 3) }
    if s >= 3 {
      let x0 = x-start + 2.6 + 0.25
      line((x0, 5.3), (x0, 5.0), (x0 + w-check, 5.0), (x0 + w-check, 5.3), stroke: 1.4pt + c-accent2)
      let qs = (
        "Is the specification what I meant?",
        "Is the sample restricted correctly?",
        "Do the numbers come from the current code?",
      )
      for (i, q) in qs.enumerate() {
        content((x0 + 0.2, 4.1 - i * 1.0), anchor: "west", lab(q, size: 14pt))
      }
      content((x0 + w-check + 0.5, 6.4), anchor: "west", lab("still the researcher's job", size: 14pt, fill: c-accent2, weight: "medium"))
    }
    illus-tag(26, 0.1)
  })
  stepcap(s, (
    [これまでは, コードを書くことに時間の多くを使っていた],
    [AI を使うと, 数百行のコードも数分で書き上がる. 確かめるコストは変わらない],
    [AI が速く書くほど, 確かめる仕事の比重が増していく],
  ))
}

// ---- Four tools, four standards to check against -----------------------------
// `final: true` draws the closing version, with {targets} emphasised.
#let anim-four-tools(s, final: false) = {
  let tools = (
    (pos: (5.4, 9.0), name: "Git", logo: "../img/logos/git.svg", q: "What changed, and where can I go back to?"),
    (pos: (20.6, 9.0), name: "Zotero", logo: "../img/logos/zotero.png", q: "What does the paper actually say?"),
    (pos: (5.4, 1.8), name: "{targets}", logo: "../img/logos/targets.png", q: "Which data and code did this number come from?"),
    (pos: (20.6, 1.8), name: "Quarto", logo: "../img/logos/quarto.svg", q: "Does the number in the text match the current result?"),
  )
  stage(26, 10.8, {
    import cetz.draw: *
    for (i, t) in tools.enumerate() {
      if s >= i + 2 {
        let (x, y) = t.pos
        let star = final and i == 2
        line(
          (13, 5.4),
          (x + (if x < 13 { 4.2 } else { -4.2 }), y + (if y > 5.4 { -1.2 } else { 1.2 })),
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
    }
    circle((13, 5.4), radius: 2.05, fill: white, stroke: 1.5pt + c-jet)
    ai-icon((13, 5.75), s: 1.05)
    content((13, 4.4), lab("AI output", weight: "medium"))
  })
  if final {
    stepbar(1, 1, [4つの道具はどれも, AI の出力を照らし合わせる基準を与える. 中心は {targets}])
  } else {
    stepcap(s, (
      [AI の出力を, 何と照らし合わせて確かめるか],
      [Git: AI が何を変えたかは, `git diff` ですべて見える],
      [Zotero: 手元の PDF の全文が, 論文についての答えの根拠になる],
      [`{targets}`: 数字がどのデータとコードから来たかをたどれる. 最も重要],
      [Quarto: 本文の数字は, いつも最新の結果から計算される],
    ))
  }
}
