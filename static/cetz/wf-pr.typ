#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-3, 0, 3.4, 1.3, [Remote dev], col: cdev, tc: white)
  fbox(3, 0, 3.4, 1.3, [Remote main], col: cmain, tc: white)
  arr((-1.3, 0), (1.3, 0)); cap(0, 0.45, "Pull Request", col: cdark)
})
