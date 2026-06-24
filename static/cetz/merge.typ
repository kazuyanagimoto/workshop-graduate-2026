#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "C1"); cm(2, 0, "C2"); cm(6, 0, "M")
  arr((0.5, 0), (1.5, 0))
  cm(4, 1.4, "D1")
  arr((2.35, 0.25), (3.6, 1.18))
  arr((4.4, 1.18), (5.65, 0.25))
  arr((2.5, 0), (5.55, 0))
  seg((6, 0.42), (6, 0.85), lc: cmain); tag(6, 1.1, "main")
  seg((4, 1.82), (4, 2.15), lc: cdev); tag(4, 2.4, "dev", col: cdev)
})
