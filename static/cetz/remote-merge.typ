#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A commit graph at x-offset `ox`. `withM` adds the merge commit M (main on M,
  // otherwise main on C2); `withDev` shows the dev label on D1.
  let graph(ox, withM, withDev) = {
    cm(ox, 0, "C1"); cm(ox + 1.4, 0, "C2")
    arr((ox + 0.45, 0), (ox + 0.95, 0))
    cm(ox + 2.8, 1.0, "D1")
    arr((ox + 1.75, 0.25), (ox + 2.45, 0.78))
    if withDev {
      seg((ox + 2.8, 1.42), (ox + 2.8, 1.72), lc: cdev); tag(ox + 2.8, 1.97, "dev", col: cdev)
    }
    if withM {
      cm(ox + 4.2, 0, "M")
      arr((ox + 3.15, 0.78), (ox + 3.85, 0.25))
      arr((ox + 1.85, 0), (ox + 3.78, 0))
      seg((ox + 4.2, 0.42), (ox + 4.2, 0.85), lc: cmain); tag(ox + 4.2, 1.1, "main")
    } else {
      seg((ox + 1.4, 0.42), (ox + 1.4, 0.85), lc: cmain); tag(ox + 1.4, 1.1, "main")
    }
  }

  let zone(x0, x1, label) = {
    rect((x0, -0.7), (x1, 2.6), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
    content((x0 + 0.25, 2.3), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray, label))
  }

  // Local: dev (D1) is built here; main is still at C2 (no merge locally).
  zone(-0.6, 3.6, "Local")
  graph(0, false, true)

  // Remote: dev is pushed, then a Pull Request merges it into main (M created here).
  zone(6.0, 11.6, "Remote")
  graph(6.6, true, true)

  // push dev, then open a Pull Request to merge it on the remote
  arr((3.7, 0.85), (5.9, 0.85))
  content((4.8, 1.45), text(size: 9pt, weight: "bold", fill: cdark)[1. push dev])
  content((4.8, 1.08), text(size: 9pt, weight: "bold", fill: cdark)[2. Pull Request])
})
