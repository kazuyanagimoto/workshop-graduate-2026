#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "C1"); cm(2, 0, "C2"); cm(4, 0, "C3")
  arr((0.5, 0), (1.5, 0)); arr((2.5, 0), (3.5, 0))
  seg((2, 0.42), (2, 0.85), lc: cmain); tag(2, 1.1, "main")
  seg((4, 0.42), (4, 0.85), lc: cdev); tag(4, 1.1, "dev", col: cdev)
  seg((4, 1.35), (4, 1.7), lc: cdark); tag(4, 1.95, "HEAD", col: cdark)
})
