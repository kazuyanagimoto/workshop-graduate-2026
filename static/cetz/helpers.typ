// ===========================================================================
// Shared CeTZ helpers and palette for the Git & GitHub lesson diagrams.
// Each diagram file does `#import "helpers.typ": *` and then calls
// `cetz.canvas({ ... })`. Re-exports `cetz` so importers can reach it.
// ===========================================================================
#import "@preview/cetz:0.4.2"

#let cdark = rgb("#04364A")   // foreground / outlines
#let cmain = rgb("#1C5253")   // main branch
#let cdev  = rgb("#E8743B")   // dev branch / HEAD
#let cnode = rgb("#dbe9ee")   // commit fill
#let cbox  = rgb("#eef3f5")   // light container fill
#let cgray = rgb("#9aa5ab")   // muted

// A commit node (circle + label).
#let cm(x, y, lab, bg: cnode) = {
  import cetz.draw: *
  circle((x, y), radius: 0.42, fill: bg, stroke: 1.1pt + cdark)
  content((x, y), text(size: 9pt, weight: "medium", fill: cdark, lab))
}

// An arrow between two coordinates.
#let arr(a, b, lc: cdark) = {
  import cetz.draw: *
  line(a, b, stroke: 1.1pt + lc, mark: (end: ">", fill: lc))
}

// A plain line (no arrow head).
#let seg(a, b, lc: cdark) = {
  import cetz.draw: *
  line(a, b, stroke: 1.1pt + lc)
}

// A small rounded label, e.g. a branch name.
#let tag(x, y, lab, col: cmain) = {
  import cetz.draw: *
  content((x, y), box(fill: col, inset: (x: 5pt, y: 3pt), radius: 3pt,
    text(size: 8pt, fill: white, weight: "bold", lab)))
}

// A fixed-size labelled box centred at (x, y).
#let fbox(x, y, w, h, body, col: cnode, lc: cdark, tc: cdark) = {
  import cetz.draw: *
  rect((x - w/2, y - h/2), (x + w/2, y + h/2), fill: col, stroke: 1pt + lc, radius: 4pt)
  content((x, y), text(size: 10pt, fill: tc, body))
}

// A small caption near a coordinate.
#let cap(x, y, body, col: cdark, sz: 8pt) = {
  import cetz.draw: *
  content((x, y), text(size: sz, fill: col, body))
}
