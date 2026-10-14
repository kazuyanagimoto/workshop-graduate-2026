// Research moves through rounds of exploration and outside feedback.
// Shared with the workshop deck (fig-research-loop in slides/ai-pipeline/typst/workflow.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 5.0, {
  import cetz.draw: *
  let c-pink = rgb("#e64173")
  let steps = (
    (name: "Explore", col: c-accent),
    (name: "Present", col: c-pink),
    (name: "Explore", col: c-accent),
    (name: "Present", col: c-pink),
    (name: "Submit", col: c-jet),
    (name: "R&R", col: c-accent2),
    (name: "Explore", col: c-accent),
    (name: "Resubmit", col: c-jet),
  )
  let xs = (1.55, 4.82, 8.09, 11.36, 14.63, 17.90, 21.17, 24.44)
  let y = 3.6
  for i in range(7) {
    arrow((xs.at(i) + 1.38, y), (xs.at(i + 1) - 1.38, y), col: c-muted, w: 1.8pt, head: 1.1)
  }
  for (i, step) in steps.enumerate() {
    bnode((xs.at(i), y), 2.6, 1.5, step.name, fill: white, stroke: 1.5pt + step.col, tc: step.col, size: 11.5pt)
  }
  for (i, label) in ((1, "questions"), (3, "comments"), (5, "referee reports")) {
    let x = xs.at(i)
    line((x, y - 0.8), (x, 1.2), stroke: 1.3pt + c-faint)
    circle((x, 1.05), radius: 0.11, fill: steps.at(i).col, stroke: none)
    content((x, 0.4), lab(label, size: 10pt, fill: c-muted))
  }
})
