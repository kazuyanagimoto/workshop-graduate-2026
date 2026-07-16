#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Motherboard container
  rect((-5.8, -3.5), (5.8, 3.8), fill: cbox, stroke: 1pt + cgray, radius: 6pt)
  content((-4.55, 3.45), text(size: 10pt, fill: cgray, weight: "bold", "Motherboard"))

  // Bus (shared data highway)
  line((-4.9, 0), (4.9, 0), stroke: 3pt + cgray)
  content((0, 0.35), text(size: 10pt, fill: cgray, weight: "bold", "Bus"))

  // Connectors from each component to the bus
  seg((-3.2, 1.05), (-3.2, 0), lc: cgray)
  seg((3.2, 1.05), (3.2, 0), lc: cgray)
  seg((-3.2, -1.05), (-3.2, 0), lc: cgray)
  seg((3.2, -1.05), (3.2, 0), lc: cgray)

  // CPU: a few powerful cores
  rect((-4.85, 1.05), (-1.55, 3.15), fill: white, stroke: 1.1pt + cdark, radius: 4pt)
  content((-3.2, 2.85), text(size: 12pt, fill: cdark, weight: "bold", "CPU"))
  for i in range(2) {
    for j in range(2) {
      rect(
        (-3.75 + i * 0.65, 1.75 + j * 0.5),
        (-3.3 + i * 0.65, 2.15 + j * 0.5),
        fill: cdev, stroke: 0.8pt + cdark, radius: 2pt,
      )
    }
  }
  content((-3.2, 1.35), text(size: 9pt, fill: cgray, "a few powerful cores"))

  // GPU: many small cores
  rect((1.55, 1.05), (4.85, 3.15), fill: white, stroke: 1.1pt + cdark, radius: 4pt)
  content((3.2, 2.85), text(size: 12pt, fill: cdark, weight: "bold", "GPU"))
  for i in range(6) {
    for j in range(3) {
      rect(
        (2.35 + i * 0.3, 1.7 + j * 0.3),
        (2.55 + i * 0.3, 1.9 + j * 0.3),
        fill: cmain, stroke: 0.5pt + cdark,
      )
    }
  }
  content((3.2, 1.35), text(size: 9pt, fill: cgray, "many small cores"))

  // Memory (RAM): volatile working space
  rect((-4.85, -3.05), (-1.55, -1.05), fill: white, stroke: 1.1pt + cdark, radius: 4pt)
  content((-3.2, -1.4), text(size: 12pt, fill: cdark, weight: "bold", "Memory (RAM)"))
  for i in range(4) {
    rect(
      (-4.15 + i * 0.5, -2.5),
      (-3.85 + i * 0.5, -1.75),
      fill: cnode, stroke: 0.8pt + cdark, radius: 2pt,
    )
  }
  content((-3.2, -2.78), text(size: 9pt, fill: cgray, "fast, volatile"))

  // Storage (SSD / HDD): persistent
  rect((1.55, -3.05), (4.85, -1.05), fill: white, stroke: 1.1pt + cdark, radius: 4pt)
  content((3.2, -1.4), text(size: 12pt, fill: cdark, weight: "bold", "Storage"))
  rect((2.4, -2.25), (4.0, -1.8), fill: cnode, stroke: 0.8pt + cdark, radius: 3pt)
  rect((2.4, -2.55), (4.0, -2.35), fill: cnode, stroke: 0.8pt + cdark, radius: 3pt)
  content((3.2, -2.03), text(size: 9pt, fill: cdark, "SSD / HDD"))
  content((3.2, -2.78), text(size: 9pt, fill: cgray, "slow, persistent"))
})
