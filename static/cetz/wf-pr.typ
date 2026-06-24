#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // On the remote, a Pull Request merges dev into main, creating M.
  rect((-0.7, -1.35), (7.1, 2.65), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((-0.45, 2.35), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray)[Remote])

  cm(0, 0, "C1"); cm(1.5, 0, "C2"); cm(5.8, 0, "M")
  cm(3.0, 1.1, "D1"); cm(4.4, 1.1, "D2")
  arr((0.45, 0), (0.95, 0))
  arr((1.85, 0.25), (2.55, 0.85))
  arr((3.45, 1.1), (3.95, 1.1))
  arr((4.85, 0.85), (5.35, 0.25))
  arr((1.85, 0), (5.35, 0))

  seg((5.8, 0.42), (5.8, 0.78), lc: cmain); tag(5.8, 1.05, "main")
  seg((4.4, 1.52), (4.4, 1.82), lc: cdev); tag(4.4, 2.05, "dev", col: cdev)

  content((3.2, -0.92), text(size: 9pt, weight: "bold", fill: cdark)[Pull Request merges dev into main])
})
