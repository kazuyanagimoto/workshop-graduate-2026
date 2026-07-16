// ===========================================================================
// Shared CeTZ helpers and palette for the Git & GitHub lesson diagrams.
// Each diagram file does `#import "helpers.typ": *` and then calls
// `cetz.canvas({ ... })`. Re-exports `cetz` so importers can reach it.
// ===========================================================================
#import "@preview/cetz:0.4.2"

// Site theme palette (kazuyanagimoto/quarto-clean-typst defaults, see _brand.yml)
#let cdark = rgb("#131516")          // jet: foreground / outlines
#let cmain = rgb("#107895")          // accent: main branch
#let cdev  = rgb("#9a2515")          // accent2: dev branch / HEAD / highlights
#let cpink = rgb("#e64173")          // pink: extra categorical color
#let cnode = cmain.lighten(85%)      // commit fill
#let cbox  = cmain.lighten(93%)      // light container fill
#let chot  = cdev.lighten(85%)       // "changed / conflicting" fill
#let cgray = cdark.lighten(55%)      // muted

// A commit node (circle + label).
#let cm(x, y, lab, bg: cnode) = {
  import cetz.draw: *
  circle((x, y), radius: 0.42, fill: bg, stroke: 1.1pt + cdark)
  content((x, y), text(size: 11pt, weight: "medium", fill: cdark, lab))
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
    text(size: 10pt, fill: white, weight: "bold", lab)))
}

// A fixed-size labelled box centred at (x, y).
#let fbox(x, y, w, h, body, col: cnode, lc: cdark, tc: cdark) = {
  import cetz.draw: *
  rect((x - w/2, y - h/2), (x + w/2, y + h/2), fill: col, stroke: 1pt + lc, radius: 4pt)
  content((x, y), text(size: 12pt, fill: tc, body))
}

// A small caption near a coordinate.
#let cap(x, y, body, col: cdark, sz: 10pt) = {
  import cetz.draw: *
  content((x, y), text(size: sz, fill: col, body))
}
