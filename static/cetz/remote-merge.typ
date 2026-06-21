#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-4, 1, 3.0, 1.1, [Local dev], col: cbox, tc: cdev)
  fbox(2.5, 1, 3.0, 1.1, [Remote dev], col: cdev, tc: white)
  fbox(2.5, -1.2, 3.0, 1.1, [Remote main], col: cmain, tc: white)
  arr((-2.5, 1), (1, 1)); cap(-0.7, 1.4, "push", col: cdark)
  arr((2.5, 0.45), (2.5, -0.65)); cap(4.4, -0.1, "Pull Request", col: cdark)
})
