#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "C1"); cm(2, 0, "C2"); cm(4, 0, "C3"); cm(6, 0, "C4")
  arr((0.5, 0), (1.5, 0)); arr((2.5, 0), (3.5, 0)); arr((4.5, 0), (5.5, 0))
  seg((6, 0.42), (6, 0.85), lc: cmain)
  tag(6, 1.1, "main")
  seg((2, -0.42), (2, -0.85), lc: cdev)
  tag(2, -1.1, "HEAD", col: cdev)
  cap(2, -1.7, "git switch / git checkout", col: cgray)
})
