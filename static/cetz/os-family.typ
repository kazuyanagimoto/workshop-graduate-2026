#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

// A genealogy node: name on top, year below in gray.
#let node(x, y, name, year, col: cnode, tc: cdark, hw: 1.25) = {
  import cetz.draw: *
  rect((x - hw, y - 0.45), (x + hw, y + 0.45), fill: col, stroke: 1pt + cdark, radius: 4pt)
  content((x, y + 0.12), text(size: 11pt, fill: tc, weight: "bold", name))
  content((x, y - 0.2), text(size: 9pt, fill: if tc == white { cbox } else { cgray }, year))
}

#cetz.canvas({
  import cetz.draw: *

  // Lane labels
  content((-4.8, 4.1), text(size: 10pt, fill: cgray, weight: "bold", "Unix family"))
  content((-4.65, -1.1), text(size: 10pt, fill: cgray, weight: "bold", "Windows family"))

  // Unix family
  node(-4.8, 2.2, "Unix", "1969, Bell Labs")
  node(-1.6, 3.2, "BSD", "1978")
  node(2.1, 3.2, "macOS / iOS", "2001 / 2007", col: cmain, tc: white, hw: 1.35)
  node(-1.6, 1.2, "Linux", "1991")
  node(2.65, 1.7, "Ubuntu / Debian", "distributions", col: cmain, tc: white, hw: 1.9)
  node(1.9, 0.55, "Android", "2008", col: cmain, tc: white)

  arr((-3.5, 2.5), (-2.9, 2.95))
  arr((-0.3, 3.2), (0.7, 3.2))
  arr((-0.3, 1.35), (0.7, 1.6))
  arr((-0.3, 1.0), (0.6, 0.72))

  // Linux is a from-scratch clone of Unix, not a descendant of its code
  line((-3.65, 1.9), (-2.85, 1.35), stroke: (paint: cgray, thickness: 1.1pt, dash: "dashed"),
    mark: (end: ">", fill: cgray))
  content((-3.4, 1.25), text(size: 9pt, fill: cgray, "Unix-like clone"))

  // Windows family (independent lineage)
  node(-4.8, -1.9, "MS-DOS", "1981")
  node(-1.6, -1.9, "Windows NT", "1993")
  node(2.65, -1.9, "Windows 10 / 11", "2015 / 2021", col: cmain, tc: white, hw: 1.9)

  arr((-3.5, -1.9), (-2.9, -1.9))
  arr((-0.3, -1.9), (0.7, -1.9))

  // WSL bridges the two families
  line((-1.4, 0.7), (1.2, -1.42), stroke: (paint: cdev, thickness: 1.1pt, dash: "dashed"),
    mark: (end: ">", fill: cdev))
  content((1.3, -0.6), text(size: 10pt, fill: cdev, weight: "bold", "WSL (2016)"))
})
