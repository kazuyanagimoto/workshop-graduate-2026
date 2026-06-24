#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // An outlined (hollow) tag for a remote-tracking ref like origin/main.
  let otag(x, y, lab, lc: cdark) = {
    content((x, y), box(fill: white, inset: (x: 5pt, y: 3pt), radius: 3pt,
      stroke: 1pt + lc, text(size: 8pt, fill: lc, weight: "bold", lab)))
  }

  // Remote (top): main on C3, sitting on the same vertical line as the local main.
  rect((-0.9, 1.9), (2.4, 4.1), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((-0.65, 3.85), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray)[Remote])
  cm(1.0, 2.6, "C3")
  seg((1.0, 3.02), (1.0, 3.28), lc: cmain); tag(1.0, 3.5, "main")

  // fetch: bring the remote main down into the local origin/main (on the right).
  arr((1.3, 2.05), (3.35, 0.35))
  content((2.0, 1.2), anchor: "east", text(size: 9pt, weight: "bold", fill: cdark)[1. fetch])

  // Local (bottom): main aligned under the remote main; origin/main on the right.
  rect((-0.9, -1.5), (4.9, 1.0), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  content((-0.65, 0.7), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray)[Local])
  cm(1.0, 0, "C3"); cm(3.6, 0, "C3")
  seg((1.0, -0.42), (1.0, -0.72), lc: cmain); tag(1.0, -0.98, "main")
  seg((3.6, -0.42), (3.6, -0.72), lc: cmain); otag(3.6, -0.98, "origin/main", lc: cmain)

  // merge: origin/main into the local main.
  arr((3.15, 0), (1.45, 0))
  content((2.3, 0.32), text(size: 9pt, weight: "bold", fill: cdark)[2. merge])
})
