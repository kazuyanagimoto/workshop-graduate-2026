#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Remote (top): main at C2.
  rect((-1.2, 1.6), (1.2, 3.85), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((0, 3.55), text(size: 12pt, weight: "bold", fill: cgray)[Remote])
  seg((0, 2.52), (0, 2.68), lc: cmain); tag(0, 2.9, "main")
  cm(0, 2.1, "C2")

  // pull the latest main down into the local repo
  arr((0, 1.65), (0, -0.05))
  content((0.3, 0.8), anchor: "west", text(size: 11pt, weight: "bold", fill: cdark)[git pull])

  // Local (bottom): main updated to C2.
  rect((-1.2, -2.35), (1.2, -0.1), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  cm(0, -0.5, "C2")
  seg((0, -0.92), (0, -1.08), lc: cmain); tag(0, -1.3, "main")
  content((0, -1.95), text(size: 12pt, weight: "bold", fill: cgray)[Local])
})
