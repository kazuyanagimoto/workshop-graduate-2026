// Exploration and the live pipeline live in separate folders; only settled
// analyses move from notes/ into R/.
// Shared with the workshop deck (fig-workflow-folders in slides/ai-pipeline/typst/workflow.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 9.0, {
  import cetz.draw: *
  let c-pink = rgb("#e64173")
  let folder(x0, y0, name, purpose, col) = {
    rect((x0, y0), (x0 + 9.0, y0 + 2.0), radius: 5pt, fill: white, stroke: 1.1pt + c-faint)
    rect((x0, y0), (x0 + 0.14, y0 + 2.0), fill: col, stroke: none)
    content((x0 + 0.45, y0 + 1.37), anchor: "west", mono(name, size: 13pt, fill: col))
    content((x0 + 0.45, y0 + 0.55), anchor: "west", lab(purpose, size: 10.5pt, fill: c-muted))
  }
  content((5.85, 8.25), lab("Exploration and sharing", size: 13pt, fill: c-accent, weight: "medium"))
  content((20.15, 8.25), lab("Live pipeline", size: 13pt, fill: c-jet, weight: "medium"))
  line((1.35, 7.8), (10.35, 7.8), stroke: 1.7pt + c-accent)
  line((15.65, 7.8), (24.65, 7.8), stroke: 1.7pt + c-jet)

  folder(1.35, 5.3, "notes/", "keeps what you tried and found", c-accent)
  folder(1.35, 1.9, "slides/", "keeps the results as presented", c-pink)
  folder(15.65, 5.3, "R/", "settled analyses, as functions", c-jet)
  folder(15.65, 1.9, "manuscript/", "the paper, on the latest results", c-jet)

  arrow((5.85, 5.1), (5.85, 4.1), col: c-pink, w: 1.8pt, head: 1.2)
  arrow((10.55, 6.3), (15.45, 6.3), col: c-accent, w: 2.1pt, head: 1.3)
  content((13.0, 7.05), lab("settled analyses only", size: 9.5pt, fill: c-accent, weight: "medium"))
  arrow((20.15, 5.1), (20.15, 4.1), col: c-jet, w: 1.8pt, head: 1.2)
})
