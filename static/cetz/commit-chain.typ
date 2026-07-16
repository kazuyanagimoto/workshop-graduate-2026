#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // An outlined (hollow) tag: HEAD points to a branch, drawn unfilled.
  let otag(x, y, lab, lc: cdark) = {
    content((x, y), box(fill: white, inset: (x: 5pt, y: 3pt), radius: 3pt,
      stroke: 1pt + lc, text(size: 10pt, fill: lc, weight: "bold", lab)))
  }

  // A commit: an empty circle with its hash written underneath.
  let node(x, hash) = {
    cm(x, 0, "")
    content((x, -0.75), text(size: 11pt, fill: cdark, raw(hash)))
  }

  // The commits from `git log --oneline` (oldest on the left).
  node(0, "6761acb"); node(2.4, "9d04011"); node(4.8, "a84d0e9")
  arr((0.45, 0), (1.95, 0)); arr((2.85, 0), (4.35, 0))

  // main sits on the latest commit; HEAD points to main.
  seg((4.8, 0.42), (4.8, 0.78), lc: cmain); tag(4.8, 1.0, "main")
  otag(6.65, 1.0, "HEAD")
  line((5.9, 1.15), (5.9, 0.85), (5.55, 1.0), close: true, fill: cdark, stroke: none)
})
