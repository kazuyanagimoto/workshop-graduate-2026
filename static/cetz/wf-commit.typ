#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let otag(x, y, lab, lc: cdark) = {
    content((x, y), box(fill: white, inset: (x: 5pt, y: 3pt), radius: 3pt,
      stroke: 1pt + lc, text(size: 8pt, fill: lc, weight: "bold", lab)))
  }

  // main stays at C2; new commits D1, D2 pile up on dev (D2 is the latest).
  cm(0, 0, "C2")
  seg((0, 0.42), (0, 0.72), lc: cmain); tag(0, 0.95, "main")
  cm(1.6, 1.2, "D1"); cm(3.2, 1.2, "D2", bg: rgb("#fbe3da"))
  arr((0.35, 0.28), (1.15, 0.95))
  arr((2.05, 1.2), (2.75, 1.2))

  // dev points at the latest commit; HEAD is on dev.
  seg((3.2, 1.62), (3.2, 1.92), lc: cdev); tag(3.2, 2.15, "dev", col: cdev)
  otag(4.65, 2.15, "HEAD")
  line((4.1, 2.3), (4.1, 2.0), (3.75, 2.15), close: true, fill: cdark, stroke: none)
})
