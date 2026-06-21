#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(-4, 0, 3.0, 1.3, [Working\ Directory], col: white)
  fbox(0, 0, 3.0, 1.3, [Staging Area], col: cnode)
  fbox(4, 0, 3.0, 1.3, [Repository\ (.git)], col: cbox, tc: cmain)
  arr((-2.5, 0), (-1.5, 0)); cap(-2, 0.5, "git add", col: cdark)
  arr((1.5, 0), (2.5, 0)); cap(2, 0.5, "git commit", col: cdark)
})
