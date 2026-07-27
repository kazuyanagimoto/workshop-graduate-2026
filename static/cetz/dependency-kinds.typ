#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *
  let scol = chot                 // OS world (rust tint)
  let bcol = cpink.lighten(85%)   // build world (pink tint)

  // A box with a prominent title and a muted example line underneath.
  let dbox(x, y, w, h, title, sub, col) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2),
      fill: col, stroke: 1pt + cdark, radius: 4pt)
    content((x, y + 0.19), text(size: 12pt, weight: "medium", fill: cdark, title))
    content((x, y - 0.24), text(size: 9.5pt, fill: cgray, sub))
  }

  // Invisible padding so nothing is clipped at the edges.
  rect((-5.8, -1.5), (5.8, 6.5), stroke: none)

  // The three kinds of dependencies, colour-coded by who provides them.
  dbox(0, 5.05, 5.0, 1.25, "1. Other R packages", "units, classInt, DBI, ...", cnode)
  dbox(-3.4, 0.0, 4.4, 1.25, "2. System libraries", "GDAL, GEOS, PROJ", scol)
  dbox(3.4, 0.0, 4.4, 1.25, "3. Build tools", "compiler (gcc / g++)", bcol)

  // The R package you actually want to install.
  dbox(0, 2.4, 3.6, 1.1, "R package", "(e.g. sf)", white)

  // It depends on all three kinds. Arrows start on the centre box edge and
  // stop just short of each target box, so they do not dig into the boxes.
  arr((0, 2.95), (0, 4.4))
  arr((-1.0, 1.85), (-2.85, 0.67))
  arr((1.0, 1.85), (2.85, 0.67))

  // Who provides / manages each kind.
  cap(0, 6.0, "resolved by rv / renv / pak", col: cgray, sz: 9pt)
  cap(-3.4, -1.0, "installed via apt / brew", col: cgray, sz: 9pt)
  cap(3.4, -1.0, "only when building from source", col: cgray, sz: 9pt)
})
