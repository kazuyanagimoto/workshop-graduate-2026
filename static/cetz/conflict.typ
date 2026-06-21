#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  cm(0, 0, "C1"); cm(3, 0, "?", bg: rgb("#fbe3da"))
  cm(1.5, 1.3, "D1")
  arr((0.4, 0.15), (1.1, 1.1)); arr((1.9, 1.1), (2.6, 0.15))
  arr((0.5, 0), (2.55, 0))
  content((3, 0.75), text(size: 13pt, fill: cdev, weight: "bold", "✕"))
  tag(0, -0.75, "main"); tag(1.5, 1.85, "dev", col: cdev)
})
