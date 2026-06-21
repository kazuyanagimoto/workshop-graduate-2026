#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  fbox(0, 1.1, 3.4, 1.0, [Git], col: cbox, tc: cmain)
  cap(0, 0.45, "version control tool", col: cgray)
  fbox(0, -1.1, 3.4, 1.0, [GitHub], col: cmain, tc: white)
  cap(0, -1.75, "web service", col: cgray)
})
