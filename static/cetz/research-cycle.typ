#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 16pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let node(cx, cy, title, sub, fill) = {
    rect((cx - 1.25, cy - 0.5), (cx + 1.25, cy + 0.5),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.17), text(size: 12pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.23), text(size: 8.5pt, fill: cgray, sub))
  }

  // --- Three stages of the cycle (wide triangle) ----------------------------
  node(4.6, 3.5, "explore", "notes/", cbox)
  node(8.4, 0.5, "solidify", "R/ pipeline", cbox)
  node(0.8, 0.5, "write", "manuscript/", cbox)

  // --- Cycle arrows ---------------------------------------------------------
  arr((5.7, 3.0), (7.6, 1.0), lc: cmain)       // explore -> solidify
  arr((7.1, 0.5), (2.1, 0.5), lc: cmain)       // solidify -> write
  arr((1.95, 1.0), (3.5, 3.0), lc: cmain)      // write -> explore
  tag(4.6, 0.5, "iterate", col: cmain)

  // --- AI at the centre (kept clear of the arrows) --------------------------
  rect((4.6 - 1.45, 1.55 - 0.52), (4.6 + 1.45, 1.55 + 0.52),
    fill: chot, stroke: 1pt + cdev, radius: 4pt)
  content((4.6, 1.74),
    text(size: 10pt, weight: "bold", fill: cdev)[#fa-robot() #h(4pt) Claude Code])
  content((4.6, 1.36), text(size: 8pt, fill: cdev, "reads CLAUDE.md"))
})
