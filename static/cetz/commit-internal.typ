#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-0.2, 0, 2.6, 1.2, [Project\ Folder], col: white)
  rect((3.3, -1), (8.4, 1), stroke: 1pt + cdark, radius: 4pt, fill: cbox)
  cap(5.85, 1.35, ".git (hidden folder)", col: cdark)
  cm(4.3, 0, "C1"); cm(5.85, 0, "C2"); cm(7.4, 0, "C3")
  arr((4.7, 0), (5.43, 0)); arr((6.27, 0), (7.0, 0))
  arr((1.15, 0), (3.2, 0))
  cap(2.2, 0.35, "commit", col: cdark)
})
