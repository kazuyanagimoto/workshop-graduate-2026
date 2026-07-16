#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A small ".git" chip: the repository each machine holds.
  let gitchip(cx, cy) = {
    rect((cx - 0.62, cy - 0.22), (cx + 0.62, cy + 0.22),
      fill: white, stroke: 0.8pt + cdev, radius: 3pt)
    content((cx, cy), text(size: 11pt, weight: "bold", fill: cdev)[#fa-folder() #h(2pt) .git])
  }

  // A local machine: a monitor holding its own .git, labelled below.
  let computer(cx, cy) = {
    rect((cx - 0.95, cy), (cx + 0.95, cy + 1.1), fill: cbox, stroke: 1pt + cdark, radius: 3pt)
    gitchip(cx, cy + 0.55)
    line((cx, cy), (cx, cy - 0.24), stroke: 1.5pt + cdark)
    line((cx - 0.38, cy - 0.24), (cx + 0.38, cy - 0.24), stroke: 1.5pt + cdark)
    cap(cx, cy - 0.55, "local repository", col: cgray)
  }

  // GitHub: the remote, holding the shared .git.
  rect((-1.6, 1.9), (1.6, 3.15), fill: cmain, stroke: 1pt + cdark, radius: 4pt)
  content((0, 2.82), text(size: 13pt, fill: white)[#fa-github() #h(4pt) GitHub])
  gitchip(0, 2.3)
  cap(0, 1.3, "remote repository", col: cgray)

  computer(-2.8, -0.6)
  computer(2.8, -0.6)

  // push (up) and pull (down) sync each .git with the remote.
  arr((-2.55, 0.6), (-1.3, 1.85), lc: cdev)
  arr((-1.6, 1.85), (-2.85, 0.6), lc: cmain)
  arr((2.55, 0.6), (1.3, 1.85), lc: cdev)
  arr((1.6, 1.85), (2.85, 0.6), lc: cmain)
  content((-1.4, 0.95), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((-2.95, 1.55), text(size: 10pt, weight: "bold", fill: cmain)[pull])
  content((1.4, 0.95), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((2.95, 1.55), text(size: 10pt, weight: "bold", fill: cmain)[pull])
})
