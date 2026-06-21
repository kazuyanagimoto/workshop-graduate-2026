#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  rect((-5.4, -1.6), (1.4, 1.9), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
  cap(-4.4, 1.55, "Local", col: cgray, sz: 9pt)
  cm(-4, 0, "C1"); cm(-2, 0, "M"); arr((-3.5, 0), (-2.5, 0))
  cm(-3, 1.2, "D1"); arr((-3.65, 0.3), (-3.2, 0.95)); arr((-2.8, 0.95), (-2.35, 0.3))
  tag(-2, 0.95, "main")
  fbox(4, 0, 3.4, 1.3, [Remote\ main], col: cmain, tc: white)
  arr((-0.4, 0), (2.3, 0)); cap(1, 0.4, "push", col: cdark)
})
