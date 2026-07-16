#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Applications layer
  rect((-3.5, 3.2), (3.5, 4.5), fill: cnode, stroke: 1.1pt + cdark, radius: 4pt)
  content((0, 4.12), text(size: 12pt, fill: cdark, weight: "bold", "Applications"))
  content((0, 3.6), text(size: 10pt, fill: cdark, "R / Python / browser / VS Code / ..."))

  // Operating system layer
  rect((-3.5, 1.3), (3.5, 2.6), fill: cmain, stroke: 1.1pt + cdark, radius: 4pt)
  content((0, 2.22), text(size: 12pt, fill: white, weight: "bold", "Operating System"))
  content((0, 1.7), text(size: 10pt, fill: white, "Windows / macOS / Linux"))

  // Hardware layer
  rect((-3.5, -0.6), (3.5, 0.7), fill: cbox, stroke: 1.1pt + cdark, radius: 4pt)
  content((0, 0.32), text(size: 12pt, fill: cdark, weight: "bold", "Hardware"))
  content((0, -0.2), text(size: 10pt, fill: cdark, "CPU (x86-64 / ARM64), RAM, storage, ..."))

  // Interfaces between layers
  line((-1.2, 2.65), (-1.2, 3.15), stroke: 1.1pt + cdev,
    mark: (start: ">", end: ">", fill: cdev))
  content((-0.9, 2.9), anchor: "west",
    text(size: 10pt, fill: cdev, "system calls / APIs"))

  line((-1.2, 0.75), (-1.2, 1.25), stroke: 1.1pt + cdev,
    mark: (start: ">", end: ">", fill: cdev))
  content((-0.9, 1.0), anchor: "west",
    text(size: 10pt, fill: cdev, "machine instructions (ISA)"))
})
