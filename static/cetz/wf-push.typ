#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-3.4, 0, 3.4, 1.3, [Local dev], col: cbox, tc: cdev)
  fbox(3.4, 0, 3.4, 1.3, [Remote dev], col: cdev, tc: white)
  arr((-1.6, 0), (1.6, 0)); cap(0, 0.45, "push", col: cdark)
})
