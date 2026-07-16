#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A small monitor icon (screen with code lines + stand) labelled underneath.
  let computer(cx, cy, label) = {
    let w = 1.6
    let h = 1.05
    rect((cx - w/2, cy), (cx + w/2, cy + h), fill: cbox, stroke: 1pt + cdark, radius: 3pt)
    line((cx - 0.5, cy + 0.76), (cx + 0.28, cy + 0.76), stroke: 1.3pt + cgray)
    line((cx - 0.5, cy + 0.52), (cx + 0.44, cy + 0.52), stroke: 1.3pt + cgray)
    line((cx - 0.5, cy + 0.28), (cx + 0.12, cy + 0.28), stroke: 1.3pt + cgray)
    line((cx, cy), (cx, cy - 0.24), stroke: 1.5pt + cdark)
    line((cx - 0.38, cy - 0.24), (cx + 0.38, cy - 0.24), stroke: 1.5pt + cdark)
    content((cx, cy - 0.52), text(size: 11pt, fill: cdark, label))
  }

  // GitHub: the shared hub at the top vertex (with a brand icon).
  fbox(0, 2.35, 3.2, 1.0, [#fa-github() #h(4pt) GitHub], col: cmain, tc: white)
  cap(0, 1.3, "remote repository", col: cgray)

  // Two local machines at the bottom vertices.
  computer(-2.8, -0.65, [PC])
  computer(2.8, -0.65, [PC])

  // push (up, orange) and pull (down, teal) on each side, labelled beside each arrow.
  arr((-2.55, 0.45), (-1.25, 1.82), lc: cdev)
  arr((-1.75, 1.82), (-3.05, 0.45), lc: cmain)
  arr((2.55, 0.45), (1.25, 1.82), lc: cdev)
  arr((1.75, 1.82), (3.05, 0.45), lc: cmain)
  content((-1.35, 0.8), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((-2.95, 1.5), text(size: 10pt, weight: "bold", fill: cmain)[pull])
  content((1.35, 0.8), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((2.95, 1.5), text(size: 10pt, weight: "bold", fill: cmain)[pull])

  // GitHub also hosts a website (arrow out the side); "GitHub Pages" sits below the box.
  rect((4.25, 1.85), (6.35, 2.85), fill: cbox, stroke: 1pt + cdark, radius: 4pt)
  content((5.3, 2.35), text(size: 12pt, fill: cdark)[Website])
  cap(5.3, 1.62, "GitHub Pages", col: cgray)
  arr((1.6, 2.35), (4.25, 2.35), lc: cmain)
  content((2.92, 2.62), text(size: 10pt, weight: "bold", fill: cmain)[host])
})
