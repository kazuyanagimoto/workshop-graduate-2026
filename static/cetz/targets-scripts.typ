// Scripts run in order break under change: after the first script is edited,
// every output downstream is stale, and nothing in the files says so.
// Shared with the workshop deck (anim-scripts in slides/ai-pipeline/typst/targets.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 10.2, {
  import cetz.draw: *
  let xs = (4.6, 13, 21.4)
  let scripts = ("01_clean.R", "02_estimate.R", "03_figure.R")
  let outputs = ("clean.csv", "estimates.rds", "figure.pdf")
  for (i, x) in xs.enumerate() {
    let edited = i == 0
    bnode((x, 9.0), 6.4, 1.5, scripts.at(i), code: true,
      fill: if edited { c-tint2 } else { white },
      stroke: if edited { 1.6pt + c-accent2 } else { 1.2pt + c-jet })
    arrow((x, 8.15), (x, 6.55), w: 1.6pt, head: 1.3)
    // Every output is now stale.
    doc-icon((x, 5.2), w: 1.9, h: 2.4, lines: 4, fill: c-outdated.lighten(55%),
      stroke: 1.6pt + c-outdated.darken(20%), line-col: c-outdated)
    content((x, 3.55), mono(outputs.at(i)))
    if i < 2 {
      arrow((x + 1.25, 5.7), (xs.at(i + 1) - 3.1, 8.5), col: c-muted.lighten(25%), w: 1.6pt, head: 1.3)
    }
  }
  chip((xs.at(0) + 3.2, 9.85), "edited", fill: c-accent2, anchor: "east")
  content((13, 1.5), box(fill: c-jet, radius: 5pt, inset: (x: 12pt, y: 8pt), {
    mono("tar_outdated()", fill: white)
    h(0.6em)
    lab("lists what is stale", fill: white)
  }))
})
