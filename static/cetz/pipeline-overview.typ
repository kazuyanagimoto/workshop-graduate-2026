#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 12pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A box with a bold title and a small grey subtitle.
  let node(cx, cy, w, title, sub, fill) = {
    rect((cx - w / 2, cy - 0.55), (cx + w / 2, cy + 0.55),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    if sub == none {
      content((cx, cy), text(size: 12pt, weight: "bold", fill: cdark, title))
    } else {
      content((cx, cy + 0.17), text(size: 12pt, weight: "bold", fill: cdark, title))
      content((cx, cy - 0.25), text(size: 8.5pt, fill: cgray, sub))
    }
  }

  // --- Nodes ----------------------------------------------------------------
  // Sub-plans in R/tar_*.R, named as in template-research.
  node(1.2, 0, 2.4, "data/", "raw files", cbox)
  node(5.0, 0, 2.6, "tar_data", "cleaning", cnode)
  node(9.2, 0, 3.6, "tar_analysis", "estimates, summaries", cnode)
  node(9.2, 1.7, 3.6, "tar_figure", "theme, palettes", cnode)
  node(13.9, 0.85, 3.8, "tar_manuscript", "paper PDF", cbox)

  // --- Flow -----------------------------------------------------------------
  arr((2.4, 0), (3.7, 0), lc: cdev)          // raw files -> tar_data
  arr((6.3, 0), (7.4, 0), lc: cmain)         // tar_data -> tar_analysis
  arr((11.0, 1.55), (12.0, 1.1), lc: cdev)   // tar_figure -> manuscript
  arr((11.0, 0.15), (12.0, 0.6), lc: cdev)   // tar_analysis -> manuscript
})
