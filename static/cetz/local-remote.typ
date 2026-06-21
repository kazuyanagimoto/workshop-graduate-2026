#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-3, 0, 3.6, 1.4, [Local Repository\ (.git)], col: cbox, tc: cmain)
  fbox(3, 0, 3.6, 1.4, [Remote Repository\ (GitHub)], col: cmain, tc: white)
  arr((-1.2, 0.45), (1.2, 0.45))
  cap(0, 0.85, "push", col: cdark)
  arr((1.2, -0.45), (-1.2, -0.45))
  cap(0, -0.85, "pull", col: cdark)
})
