#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Pyramid bands: apex at (0, 5), base from (-4, 0) to (4, 0).
  // Top = fastest & smallest, bottom = slowest & largest.

  // Registers (triangular cap)
  line((0, 5), (1.0, 3.75), (-1.0, 3.75), close: true, fill: cdev, stroke: 1pt + cdark)
  // Cache
  line((-1.0, 3.75), (1.0, 3.75), (2.0, 2.5), (-2.0, 2.5), close: true, fill: cmain, stroke: 1pt + cdark)
  // Main Memory
  line((-2.0, 2.5), (2.0, 2.5), (3.0, 1.25), (-3.0, 1.25), close: true, fill: cnode, stroke: 1pt + cdark)
  // Auxiliary Storage
  line((-3.0, 1.25), (3.0, 1.25), (4.0, 0), (-4.0, 0), close: true, fill: cbox, stroke: 1pt + cdark)

  // Registers label (outside, with a leader line to the cap)
  seg((0.55, 4.25), (1.9, 4.55), lc: cgray)
  content((3.3, 4.55), text(size: 11pt, fill: cdark, weight: "bold", "Registers"))
  content((3.55, 4.18), text(size: 9pt, fill: cgray, "hundreds of bytes"))

  // In-band labels
  content((0, 3.25), text(size: 12pt, fill: white, weight: "bold", "Cache"))
  content((0, 2.85), text(size: 9pt, fill: white, "L1 / L2 / L3"))

  content((0, 2.0), text(size: 12pt, fill: cdark, weight: "bold", "Main Memory"))
  content((0, 1.6), text(size: 9pt, fill: cdark, "RAM, 8-64 GB"))

  content((0, 0.75), text(size: 12pt, fill: cdark, weight: "bold", "Auxiliary Storage"))
  content((0, 0.35), text(size: 9pt, fill: cdark, "SSD / HDD, TBs"))

  // Side annotations
  arr((-4.9, 0.5), (-4.9, 4.5), lc: cdev)
  content((-5.4, 2.5), std.rotate(90deg, text(size: 11pt, fill: cdev, weight: "bold", "Faster, costlier")))

  arr((4.9, 4.5), (4.9, 0.5), lc: cmain)
  content((5.4, 2.5), std.rotate(-90deg, text(size: 11pt, fill: cmain, weight: "bold", "Larger capacity")))
})
