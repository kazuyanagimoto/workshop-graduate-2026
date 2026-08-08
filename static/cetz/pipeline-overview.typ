#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 12pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A box with a bold title and a small grey subtitle.
  let node(cx, cy, w, title, sub, fill) = {
    rect((cx - w / 2, cy - 0.55), (cx + w / 2, cy + 0.55),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    if sub == none {
      content((cx, cy), text(size: 12pt, weight: "bold", fill: cdark, title))
    } else {
      content((cx, cy + 0.17), text(size: 12pt, weight: "bold", fill: cdark, title))
      content((cx, cy - 0.25), text(size: 8.5pt, fill: cgray, sub))
    }
  }

  // --- Nodes ----------------------------------------------------------------
  node(1.2, 0, 2.4, "raw data", none, cbox)
  node(5.0, 0, 2.4, "data", "cleaning", cnode)
  node(9.4, 1.7, 3.6, "fact", "figures and numbers", cnode)
  node(9.4, 0, 3.6, "model", "Julia", cnode)
  node(9.4, -1.7, 3.6, "website", none, cbox)
  node(13.8, 0.85, 2.8, "manuscript", none, cbox)

  // --- Flow -----------------------------------------------------------------
  arr((2.4, 0), (3.8, 0), lc: cdev)          // raw data -> data
  arr((6.2, 0.3), (7.6, 1.55), lc: cmain)    // data -> fact
  arr((6.2, 0), (7.6, 0), lc: cmain)         // data -> model
  arr((6.2, -0.3), (7.6, -1.55), lc: cmain)  // data -> website
  arr((11.2, 1.55), (12.4, 1.1), lc: cdev)   // fact -> manuscript
  arr((11.2, 0.3), (12.4, 0.6), lc: cdev)    // model -> manuscript
})
