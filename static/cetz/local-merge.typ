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

  // Local: dev is merged into main here (M is created locally).
  zone(-0.6, 5.0, "Local")
  graph(0, true, true)

  // Remote: receives the merged main after a push.
  zone(6.9, 12.5, "Remote")
  graph(7.5, true, false)

  // push the merged main to the remote
  arr((5.1, 0.85), (6.8, 0.85))
  content((5.95, 1.2), text(size: 9pt, weight: "bold", fill: cdark, raw("git push")))
})
