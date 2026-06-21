#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-4, 0, 3.2, 1.2, [Remote\ main], col: cmain, tc: white)
  fbox(0, 0, 3.2, 1.2, [origin/main\ (local)], col: cbox, tc: cmain)
  fbox(4, 0, 3.2, 1.2, [main\ (local)], col: cnode)
  arr((-2.4, 0), (-1.6, 0)); cap(-2, 0.45, "fetch", col: cdark)
  arr((1.6, 0), (2.4, 0)); cap(2, 0.45, "merge", col: cdark)
})
