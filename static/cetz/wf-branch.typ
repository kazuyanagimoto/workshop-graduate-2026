#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let otag(x, y, lab, lc: cdark) = {
    content((x, y), box(fill: white, inset: (x: 5pt, y: 3pt), radius: 3pt,
      stroke: 1pt + lc, text(size: 10pt, fill: lc, weight: "bold", lab)))
  }

  // main line; dev is just created at C2 and HEAD moves onto it.
  cm(0, 0, "C1"); cm(2, 0, "C2"); arr((0.5, 0), (1.5, 0))
  seg((2, 0.42), (2, 0.72), lc: cmain); tag(2, 0.95, "main")

  // dev: a new label at C2, drawn branching up-right.
  seg((2.3, 0.28), (3.0, 0.82), lc: cdev); tag(3.35, 1.05, "dev", col: cdev)

  // HEAD points to dev (the current branch).
  otag(5.05, 1.05, "HEAD")
  line((4.3, 1.2), (4.3, 0.9), (3.95, 1.05), close: true, fill: cdark, stroke: none)
})
