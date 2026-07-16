#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Local: C1 - C2 on main, with D1 on dev branched up from C2.
  rect((-0.7, -0.7), (4.9, 3.05), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((-0.45, 2.7), anchor: "west", text(size: 12pt, weight: "bold", fill: cgray)[Local])
  cm(0, 0, "C1"); cm(2, 0, "C2"); cm(4, 1.4, "D1")
  arr((0.5, 0), (1.5, 0)); arr((2.35, 0.25), (3.6, 1.18))
  seg((2, 0.42), (2, 0.85), lc: cmain); tag(2, 1.1, "main")
  seg((4, 1.82), (4, 2.15), lc: cdev); tag(4, 2.4, "dev", col: cdev)

  // Remote: only C1 - C2 on main (no dev / D1 yet).
  rect((6.0, -0.7), (9.5, 3.05), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((6.25, 2.7), anchor: "west", text(size: 12pt, weight: "bold", fill: cgray)[Remote])
  cm(6.8, 0, "C1"); cm(8.8, 0, "C2")
  arr((7.3, 0), (8.3, 0))
  seg((8.8, 0.42), (8.8, 0.85), lc: cmain); tag(8.8, 1.1, "main")
})
