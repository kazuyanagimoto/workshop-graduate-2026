#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "C1"); cm(2, 0, "C2"); arr((0.5, 0), (1.5, 0))
  seg((2, 0.42), (2, 0.8), lc: cmain); tag(2, 1.05, "main")
  cm(4, -1.3, "D1"); arr((2.4, -0.25), (3.6, -1.1))
  seg((4, -1.72), (4, -2.05), lc: cdev); tag(4, -2.3, "dev", col: cdev)
})
