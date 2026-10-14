// Where the tables and figures are made: LaTeX needs them as files from the
// pipeline; Quarto makes them while the manuscript renders.
// Shared with the workshop deck (anim-compute-render in slides/ai-pipeline/typst/quarto.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 10.2, {
  import cetz.draw: *
  let band(y, x-split) = {
    rect((3.7, y - 1.75), (x-split - 0.1, y + 1.75), radius: 6pt, fill: c-tint, stroke: none)
    rect((x-split + 0.1, y - 1.75), (25.8, y + 1.75), radius: 6pt, fill: c-panel, stroke: none)
  }
  let band-labels(y, x-split) = {
    content((3.95, y + 1.35), anchor: "west", mono("tar_analysis", size: 10.5pt, fill: c-accent.darken(10%)))
    content((x-split + 0.35, y + 1.35), anchor: "west", mono("tar_manuscript", size: 10.5pt, fill: c-muted))
  }
  let sheet(x, y, name, fill: white) = {
    doc-icon((x, y + 0.05), w: 1.3, h: 1.6, lines: 3, fill: fill)
    content((x, y - 0.95), anchor: "north", mono(name, size: 10.5pt))
  }
  // LaTeX: the pipeline writes the tables and figures to files.
  let ya = 7.9
  content((0.2, ya), anchor: "west", lab("LaTeX", size: 15pt, weight: "medium"))
  band(ya, 16.1)
  band-labels(ya, 16.1)
  tnode((5.6, ya + 0.05), "models_did", size: 10.5pt, r: 0.45)
  arrow((6.3, ya + 0.05), (8.4, ya + 0.05), w: 1.6pt, head: 1.3)
  sheet(9.6, ya, "tab_did.tex")
  sheet(13.9, ya, "fig_event.pdf")
  arrow((14.9, ya + 0.05), (17.6, ya + 0.05), w: 1.6pt, head: 1.3)
  sheet(18.7, ya, "main.tex")
  arrow((19.7, ya + 0.05), (22.6, ya + 0.05), w: 1.6pt, head: 1.3)
  sheet(23.7, ya, "main.pdf", fill: c-faint)
  // Quarto: the pipeline stops at the objects.
  let yb = 3.4
  content((0.2, yb), anchor: "west", lab("Quarto", size: 15pt, weight: "medium"))
  band(yb, 7.9)
  band-labels(yb, 7.9)
  tnode((5.6, yb + 0.05), "models_did", size: 10.5pt, r: 0.45)
  arrow((6.3, yb + 0.05), (12.6, yb + 0.05), w: 1.6pt, head: 1.3)
  content((9.5, yb + 0.5), mono("tar_load()", size: 10pt, fill: c-muted))
  sheet(13.9, yb, "main.qmd")
  content((15.0, yb + 0.45), anchor: "west", box(width: 7.4cm, {
    set par(leading: 0.45em)
    lab("makes the tables and figures\nwhile it renders", size: 10.5pt, fill: c-muted)
  }))
  arrow((14.9, yb - 0.5), (22.6, yb - 0.5), w: 1.6pt, head: 1.3)
  sheet(23.7, yb, "main.pdf", fill: c-faint)
})
