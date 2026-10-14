// Two channels for a wider Black-white pay gap. A cartoon: bar lengths stand
// for pay and carry no data. Rows are job titles, so job title fixed effects
// compare workers within a row.
// Shared with the workshop deck (fig-mechanism in slides/ai-pipeline/typst/workflow.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 8.9, {
  import cetz.draw: *
  let (high, low) = (6.3, 3.7)
  let panels = (4.6, 15.4)
  let pw = 10.4
  // A worker with a bar for pay. `was` outlines the pay before 1913; a ghost
  // marks where the worker used to be.
  let worker(x, y, col, who, pay, was: none, ghost: false) = {
    person-icon((x, y + 0.05), s: 0.85, col: if ghost { col.lighten(70%) } else { col })
    if who != none { content((x, y - 0.8), lab(who, size: 9.5pt, fill: col)) }
    if was != none {
      rect((x + 0.8, y - 0.22), (x + 0.8 + was, y + 0.22), radius: 2pt, stroke: (paint: col, thickness: 1pt, dash: "dashed"))
    }
    if pay != none {
      rect((x + 0.8, y - 0.22), (x + 0.8 + pay, y + 0.22), radius: 2pt, fill: col.lighten(35%), stroke: none)
    }
  }
  let row-name(y, body) = content((0.2, y), anchor: "west", box(width: 4.2cm, {
    set par(leading: 0.45em)
    lab(body, size: 10.5pt, weight: "medium")
  }))
  row-name(high, "Original\njob title")
  row-name(low, "Lower-paid\njob title")
  let titles = ("Channel 1: same job title, lower pay", "Channel 2: moved to a lower-paid job")
  let notes = ("With job title FE, the gap remains", "With job title FE, the gap disappears")
  for (i, x0) in panels.enumerate() {
    content((x0 + pw / 2, 8.4), lab(titles.at(i), size: 12pt, weight: "medium", fill: c-accent.darken(10%)))
    for y in (high, low) {
      rect((x0, y - 1.1), (x0 + pw, y + 1.1), radius: 6pt, fill: c-panel, stroke: none)
    }
    // The matched white worker stays in the same job at the same pay.
    worker(x0 + 1.2, high, c-muted, "White", 3.0)
    content((x0 + pw / 2, 1.2), lab(notes.at(i), size: 11pt))
  }
  // Channel 1: the Black worker keeps the job title, at lower pay.
  worker(panels.at(0) + 6.0, high, c-accent, "Black", 1.9, was: 3.0)
  // Channel 2: the Black worker is moved to a lower-paid job title.
  let x = panels.at(1) + 6.0
  worker(x, high, c-accent, none, none, was: 3.0, ghost: true)
  arrow((x, high - 0.75), (x, low + 0.75), col: c-accent, w: 2pt, head: 1.3)
  worker(x, low, c-accent, "Black", 1.9)
})
