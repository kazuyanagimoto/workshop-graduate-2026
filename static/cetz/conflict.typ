#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // One branch's version of foo.txt; line 3 (l3) is the edit that clashes.
  let card(cx, branch, bcol, l3) = {
    seg((cx, 2.07), (cx, 2.3), lc: bcol)
    tag(cx, 2.55, branch, col: bcol)
    rect((cx - 1.0, 0.2), (cx + 1.0, 2.05), fill: cbox, stroke: 1pt + cdark, radius: 4pt)
    content((cx, 1.78), text(size: 8pt, fill: cdark)[#fa-file-lines() #h(3pt) #raw("foo.txt")])
    content((cx, 1.45), text(size: 8pt, fill: cgray, raw("aaaaa")))
    content((cx, 1.15), text(size: 8pt, fill: cgray, raw("bbbbb")))
    content((cx, 0.85), text(size: 8pt, weight: "bold", fill: bcol, raw(l3)))
    content((cx, 0.55), text(size: 8pt, fill: cgray, raw("ddddd")))
  }

  card(-2.2, "main", cmain, "cccccc")
  card(2.2, "dev", cdev, "zzzzz")

  // merging the two clashes on line 3
  content((0, -0.3), text(size: 8pt, weight: "bold", fill: cdark, raw("git merge")))
  arr((-2.2, 0.15), (-0.85, -0.62))
  arr((2.2, 0.15), (0.85, -0.62))

  rect((-1.45, -1.55), (1.45, -0.65), fill: rgb("#fbe3da"), stroke: 1pt + cdev, radius: 4pt)
  content((0, -1.1), text(size: 10pt, weight: "bold", fill: cdev)[CONFLICT])
  content((0, -1.85), text(size: 8pt, fill: cgray)[same line edited on both sides])
})
