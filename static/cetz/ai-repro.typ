// Reproducibility: another AI, given the paper but neither the original code
// nor the data, rebuilds the code; run on the same data, do the results match?
// Shared with the workshop deck (anim-repro in slides/ai-pipeline/typst/cleanroom.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 9.4, {
  import cetz.draw: *
  let (yt, ym, yb) = (7.5, 5.0, 2.5)
  let (xd, xr) = (19.0, 23.3)
  let name(pos, body, col: c-jet) = content(pos, lab(body, size: 12pt, weight: "medium", fill: col))
  let result(y, col) = bnode((xr, y), 3.6, 1.5, "Results", size: 12pt, stroke: 1.2pt + col)
  // The original analysis: code and data give the results, the paper describes it.
  doc-icon((2.2, yt), lines: 4)
  name((2.2, yt + 1.4), "Original code")
  arrow((3.25, yt), (xr - 2.0, yt), w: 1.6pt, head: 1.2)
  result(yt, c-jet)
  data-icon((xd, ym))
  content((xd - 0.95, ym), anchor: "east", lab("Data", size: 12pt, weight: "medium"))
  arrow((xd, ym + 0.9), (xd, yt - 0.15), w: 1.6pt, head: 1.2)
  arrow((2.2, yt - 1.15), (2.2, yb + 1.2), w: 1.6pt, head: 1.2)
  doc-icon((2.2, yb), lines: 4, stroke: 1.3pt + c-accent)
  name((2.2, yb - 1.5), "Paper", col: c-accent)
  // Only the paper crosses the boundary; the original code and the data do not.
  rect((6.2, 0.3), (16.3, 4.6), radius: 8pt, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
  content((6.65, 4.05), anchor: "west", lab("Clean room", size: 11pt, weight: "medium", fill: c-accent))
  arrow((3.25, yb), (6.9, yb), col: c-accent, w: 1.8pt, head: 1.2)
  rect((7.1, yb - 0.9), (12.0, yb + 0.9), radius: 6pt, fill: white, stroke: 1.2pt + c-accent)
  ai-icon((8.15, yb - 0.1), s: 0.85)
  content((9.0, yb), anchor: "west", lab("Another AI", size: 12pt, weight: "medium"))
  arrow((12.15, yb), (13.25, yb), col: c-accent, w: 1.8pt, head: 1.2)
  doc-icon((14.3, yb), lines: 4, stroke: 1.3pt + c-accent)
  name((14.3, yb - 1.5), "New code", col: c-accent)
  arrow-path((3.05, yt - 0.7), (4.3, yt - 1.5), (12.6, yt - 1.5), (12.6, 5.0), col: c-accent2, dash: "dashed", w: 1.4pt)
  cross-mark(12.6, 4.6, s: 1.7, col: c-accent2)
  arrow-path((xd - 0.7, ym + 0.55), (xd - 1.4, yt - 1.5), (14.8, yt - 1.5), (14.8, 5.0), col: c-accent2, dash: "dashed", w: 1.4pt)
  cross-mark(14.8, 4.6, s: 1.7, col: c-accent2)
  // The new code runs on the same data, and the two results are compared.
  arrow((15.35, yb), (xr - 2.0, yb), col: c-accent, w: 1.8pt, head: 1.2)
  arrow((xd, ym - 0.9), (xd, yb + 0.15), w: 1.6pt, head: 1.2)
  result(yb, c-accent)
  line((xr, yt - 0.85), (xr, yb + 0.85), stroke: (paint: c-jet, thickness: 1.5pt, dash: "dashed"))
  circle((xr, ym), radius: 0.62, fill: c-jet, stroke: none)
  content((xr, ym), text(size: 17pt, fill: white, weight: "bold", "=?"))
})
