#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // An outlined (hollow) tag: HEAD is a pointer to a branch, not a branch itself,
  // so it is drawn unfilled to set it apart from the solid branch labels.
  let otag(x, y, lab, lc: cdark) = {
    content((x, y), box(fill: white, inset: (x: 5pt, y: 3pt), radius: 3pt,
      stroke: 1pt + lc, text(size: 10pt, fill: lc, weight: "bold", lab)))
  }

  // main line, with dev branching diagonally up to its first commit D1.
  cm(0, 0, "C1"); cm(2, 0, "C2"); cm(4, 1.4, "D1")
  arr((0.5, 0), (1.5, 0))
  arr((2.35, 0.25), (3.6, 1.18))

  // Branch labels: solid pills on a stem rising from the commit.
  seg((2, 0.42), (2, 0.85), lc: cmain); tag(2, 1.1, "main")
  seg((4, 1.82), (4, 2.15), lc: cdev); tag(4, 2.4, "dev", col: cdev)

  // HEAD: hollow tag to the right of dev, with a triangle pointing to it.
  otag(5.7, 2.4, "HEAD")
  line((4.95, 2.55), (4.95, 2.25), (4.6, 2.4), close: true, fill: cdark, stroke: none)
})
