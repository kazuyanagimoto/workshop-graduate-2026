#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let W = 3.35  // half width of each zone

  let title(cy, t) = content((0, cy), text(size: 12pt, weight: "bold", fill: cdark, t))
  let filerow(y, name, col) = content((-2.55, y), anchor: "west",
    text(size: 11pt, fill: col)[#fa-file-lines() #h(5pt) #raw(name)])

  // A thick flow arrow pointing UP (y0 -> y1, y0 < y1) with a label to its right.
  let flow(y0, y1, lab) = {
    line((0, y0), (0, y1), stroke: 2.2pt + cdark, mark: (end: ">", fill: cdark))
    content((0.3, (y0 + y1) / 2), anchor: "west",
      text(size: 11pt, weight: "bold", fill: cdark, raw(lab)))
  }

  // Working Directory (bottom)
  rect((-W, -1.3), (W, 1.2), fill: cbox, stroke: 1pt + cdark, radius: 5pt)
  title(0.78, "Working Directory")
  filerow(0.2, "analysis.R", cdev)
  filerow(-0.3, "data.csv", cdev)
  content((-2.55, -0.8), anchor: "west")[
    #text(size: 11pt, fill: cgray)[#fa-file-lines() #h(5pt) #raw("draft.txt")]
    #h(8pt) #text(size: 10pt, fill: cgray)[(left unstaged)]
  ]

  flow(1.25, 1.75, "git add")

  // Staging Area (middle)
  rect((-W, 1.8), (W, 4.05), fill: cbox, stroke: 1pt + cdark, radius: 5pt)
  title(3.6, "Staging Area")
  filerow(2.9, "analysis.R", cdev)
  filerow(2.4, "data.csv", cdev)

  flow(4.1, 4.65, "git commit")

  // Repository / .git (top)
  rect((-W, 4.7), (W, 6.55), fill: cbox, stroke: 1pt + cdark, radius: 5pt)
  title(6.1, "Repository (.git)")
  cm(-0.85, 5.4, "")
  content((-0.3, 5.4), anchor: "west", text(size: 11pt, fill: cdark, raw("e4f1a9c")))
})
