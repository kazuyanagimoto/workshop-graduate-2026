#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-3.4, 0, 3.4, 1.3, [Remote main], col: cmain, tc: white)
  fbox(3.4, 0, 3.4, 1.3, [Local main], col: cbox, tc: cmain)
  arr((-1.6, 0), (1.6, 0)); cap(0, 0.45, "pull", col: cdark)
})
