#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // The .git folder: a dashed container holding every committed snapshot.
  rect((-1.15, -1.3), (6.35, 1.55),
    stroke: (paint: cdark, thickness: 1pt, dash: "dashed"), radius: 6pt)
  content((-1.0, 1.28), anchor: "west",
    text(size: 12pt, weight: "bold", fill: cdev)[#fa-folder() #h(4pt) .git])

  // A snapshot card: the whole set of tracked files at one commit.
  // `hot` is the index of the file changed in this commit (drawn in accent).
  let snap(cx, hash, hot) = {
    let w = 1.5
    rect((cx - w/2, -0.55), (cx + w/2, 0.95), fill: white, stroke: 1pt + cdark, radius: 4pt)
    let bars = ((0.55, 0.92), (0.2, 1.0), (-0.15, 0.66))
    for (i, b) in bars.enumerate() {
      let col = if i == hot { cdev } else { cgray }
      line((cx - 0.5, b.at(0)), (cx - 0.5 + b.at(1), b.at(0)), stroke: 2.4pt + col)
    }
    content((cx, -0.92), text(size: 11pt, fill: cdark, raw(hash)))
  }

  snap(0, "7b3c0d1", 1)
  snap(2.6, "9d04011", 2)
  snap(5.2, "a84d0e9", 0)

  // history links (older -> newer)
  arr((0.78, 0.2), (1.82, 0.2))
  arr((3.38, 0.2), (4.42, 0.2))
})
