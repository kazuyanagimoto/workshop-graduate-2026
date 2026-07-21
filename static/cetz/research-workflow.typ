#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 12pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A box with a bold title and a small grey subtitle.
  let box(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.17), text(size: 12pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.25), text(size: 8.5pt, fill: cgray, sub))
  }

  // --- Project repository boundary ------------------------------------------
  rect((-0.4, -1.8), (11.2, 3.4),
    stroke: (dash: "dashed", paint: cgray, thickness: 0.8pt), radius: 6pt)
  content((-0.05, 3.1), anchor: "west",
    text(size: 9pt, fill: cgray)[#fa-folder() #h(3pt) research project (from template)])

  // --- Nodes ----------------------------------------------------------------
  box(1.2, 1.6, 1.9, 1.1, "data/", "raw data", cbox)

  // Pipeline node with two subtitle lines (kept inside the box).
  rect((5.0 - 1.7, 1.6 - 0.85), (5.0 + 1.7, 1.6 + 0.85),
    fill: cnode, stroke: 1pt + cdark, radius: 4pt)
  content((5.0, 2.04), text(size: 12pt, weight: "bold", fill: cdark, "Pipeline"))
  content((5.0, 1.60), text(size: 8.5pt, fill: cgray, "_targets.R + R/"))
  content((5.0, 1.22), text(size: 8.5pt, fill: cgray, "produces data objects"))

  box(5.0, -0.9, 2.6, 1.1, "notes/", "trial & error", cbox)

  box(9.5, 2.35, 2.8, 1.1, "manuscript/", "live (tar_load)", cbox)
  box(9.5, 0.75, 2.8, 1.1, "slides/", "frozen snapshot", cbox)

  // --- Flow arrows ----------------------------------------------------------
  arr((2.25, 1.6), (3.2, 1.6), lc: cdev)                  // data -> pipeline
  arr((5.0, -0.3), (5.0, 0.7), lc: cmain)                 // notes -> pipeline
  tag(6.5, 0.15, "graduate", col: cmain)
  arr((6.75, 1.95), (8.05, 2.35), lc: cdev)               // pipeline -> manuscript
  line((6.75, 1.25), (8.05, 0.8),
    stroke: (dash: "dashed", paint: cgray, thickness: 1pt),
    mark: (end: ">", fill: cgray))                        // pipeline -> slides (frozen)

  // --- AI layer -------------------------------------------------------------
  rect((2.9, -3.2), (7.1, -2.15), fill: chot, stroke: 1pt + cdev, radius: 4pt)
  content((5.0, -2.67),
    text(size: 10.5pt, weight: "bold", fill: cdev)[#fa-robot() #h(4pt) Claude Code])
  arr((5.0, -2.15), (5.0, -1.8), lc: cdev)                // AI -> project
  content((5.25, -1.98), anchor: "west",
    text(size: 8.5pt, fill: cdev, "reads CLAUDE.md"))
})
