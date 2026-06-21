#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "D1"); cm(2, 0, "D2", bg: rgb("#fbe3da"))
  arr((0.5, 0), (1.5, 0))
  seg((2, 0.42), (2, 0.8), lc: cdev); tag(2, 1.05, "dev", col: cdev)
})
