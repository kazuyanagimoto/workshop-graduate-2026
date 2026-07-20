#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A small ".git" chip: the repository each machine holds.
  let gitchip(cx, cy) = {
    rect((cx - 0.72, cy - 0.27), (cx + 0.72, cy + 0.27),
      fill: chot, stroke: 0.8pt + cdev, radius: 3pt)
    content((cx, cy), text(size: 11pt, weight: "bold", fill: cdev)[#fa-folder() #h(2pt) .git])
  }

  // A local machine: a monitor holding its own .git, labelled below.
  let computer(cx, cy) = {
    rect((cx - 1.05, cy), (cx + 1.05, cy + 1.25), fill: cbox, stroke: 1pt + cdark, radius: 3pt)
    gitchip(cx, cy + 0.62)
    line((cx, cy), (cx, cy - 0.24), stroke: 1.5pt + cdark)
    line((cx - 0.38, cy - 0.24), (cx + 0.38, cy - 0.24), stroke: 1.5pt + cdark)
    cap(cx, cy - 0.6, "local repository", col: cgray)
  }

  // GitHub: the remote, holding the shared .git.
  rect((-1.9, 2.0), (1.9, 3.55), fill: cmain, stroke: 1pt + cdark, radius: 4pt)
  content((0, 3.15), text(size: 13pt, fill: white)[#fa-github() #h(4pt) GitHub])
  gitchip(0, 2.5)
  cap(0, 1.6, "remote repository", col: cgray)

  computer(-3.2, -0.9)
  computer(3.2, -0.9)

  // push (up) and pull (down) sync each .git with the remote.
  arr((-2.85, 0.5), (-1.5, 1.9), lc: cdev)
  arr((-1.85, 1.9), (-3.2, 0.5), lc: cmain)
  arr((2.85, 0.5), (1.5, 1.9), lc: cdev)
  arr((1.85, 1.9), (3.2, 0.5), lc: cmain)
  content((-1.65, 0.85), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((-3.35, 1.55), text(size: 10pt, weight: "bold", fill: cmain)[pull])
  content((1.65, 0.85), text(size: 10pt, weight: "bold", fill: cdev)[push])
  content((3.35, 1.55), text(size: 10pt, weight: "bold", fill: cmain)[pull])
})
