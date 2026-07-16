#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // One tree row: an icon followed by a label, left-anchored at (x, y).
  let row(x, y, icon, label, col: cdark, w: "regular") = {
    content((x, y), anchor: "west",
      text(size: 13pt, fill: col)[#icon #h(4pt) #text(weight: w, label)])
  }

  // Elbow connector: vertical guide under a parent + horizontal tick to a child.
  let tick(gx, y, cx) = seg((gx, y), (cx, y), lc: cgray)

  // Rows: project / .git / data / survey.csv / code / analysis.R
  row(0.2, 2.4, fa-folder(), [project], w: "bold")
  row(1.0, 1.8, fa-folder(), [.git], col: cdev, w: "bold")
  row(1.0, 1.2, fa-folder(), [data])
  row(1.8, 0.6, fa-file-csv(), [survey.csv], col: cmain)
  row(1.0, 0.0, fa-folder(), [code])
  row(1.8, -0.6, fa-r-project(), [analysis.R], col: cmain)

  // project -> its direct children (.git, data, code)
  seg((0.32, 2.12), (0.32, 0.0), lc: cgray)
  tick(0.32, 1.8, 1.0)
  tick(0.32, 1.2, 1.0)
  tick(0.32, 0.0, 1.0)

  // data -> survey.csv
  seg((1.12, 0.92), (1.12, 0.6), lc: cgray)
  tick(1.12, 0.6, 1.8)

  // code -> analysis.R
  seg((1.12, -0.28), (1.12, -0.6), lc: cgray)
  tick(1.12, -0.6, 1.8)

  // Note: the .git folder is created by Git, not by you.
  arr((3.15, 1.8), (2.45, 1.8), lc: cgray)
  content((3.3, 1.8), anchor: "west",
    text(size: 10pt, fill: cgray)[created by #raw("git init")])
})
