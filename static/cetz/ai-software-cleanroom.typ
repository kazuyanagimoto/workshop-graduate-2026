// Clean room design in software: the second team implements the same
// behaviour from a specification, without ever seeing the original code.
// The Compaq BIOS example is described by its founder in the PBS interview.
// Shared with the workshop deck (anim-software-cleanroom in slides/ai-pipeline/typst/cleanroom.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 9.2, {
  import cetz.draw: *
  // The original implementation is available only to the analysis team.
  doc-icon((2.0, 6.2), w: 1.6, h: 2.0, lines: 4)
  content((2.0, 7.85), lab("IBM PC BIOS", size: 11.5pt, weight: "medium"))
  content((2.0, 4.65), lab("original code", size: 10pt, fill: c-accent2))
  arrow((3.05, 6.2), (4.5, 6.2), w: 1.6pt, head: 1.2)
  rect((4.7, 5.0), (10.1, 7.4), radius: 6pt, fill: c-panel, stroke: none)
  person-icon((5.8, 6.1), s: 0.85, col: c-muted)
  content((6.7, 6.6), anchor: "west", lab("Team A", size: 12pt, weight: "medium"))
  content((6.7, 5.85), anchor: "west", lab("studies behavior", size: 10.5pt))
  content((7.4, 8.1), lab("may read the original code", size: 10pt, fill: c-muted))
  arrow((10.3, 6.2), (11.95, 6.2), w: 1.6pt, head: 1.2)
  doc-icon((13.0, 6.2), w: 1.4, h: 1.8, lines: 3, stroke: 1.3pt + c-accent)
  content((13.0, 7.85), lab("Functional spec", size: 11pt, weight: "medium", fill: c-accent))
  content((13.0, 4.65), lab("inputs / outputs", size: 10pt, fill: c-muted))
  // Only the functional specification may cross the boundary.
  rect((15.3, 0.4), (25.7, 9.0), radius: 8pt, stroke: (paint: c-accent, thickness: 1.1pt, dash: "dashed"))
  content((20.5, 8.4), lab("Clean room", size: 12pt, weight: "medium", fill: c-accent))
  arrow((14.05, 6.2), (16.3, 6.2), col: c-accent, w: 1.8pt, head: 1.2)
  rect((16.5, 5.0), (24.0, 7.4), radius: 6pt, fill: white, stroke: 1.2pt + c-accent)
  person-icon((17.7, 6.1), s: 0.85, col: c-accent)
  content((18.7, 6.6), anchor: "west", lab("Team B", size: 12pt, weight: "medium"))
  content((18.7, 5.85), anchor: "west", lab("codes from the spec", size: 10.5pt))
  content((20.25, 4.45), lab("has never seen the original code", size: 10pt, fill: c-accent))
  arrow-path((3.05, 5.5), (4.3, 4.7), (4.3, 3.25), (14.9, 3.25), col: c-accent2, dash: "dashed", w: 1.4pt)
  cross-mark(15.3, 3.25, s: 1.7, col: c-accent2)
  content((9.3, 3.85), lab("no original code crosses", size: 11pt, fill: c-accent2, weight: "medium"))
  arrow((20.25, 4.0), (20.25, 2.9), col: c-accent, w: 1.8pt, head: 1.2)
  bnode((20.25, 1.85), 7.5, 1.7, "Compatible BIOS", sub: "same behavior, different code", size: 12pt, sub-size: 10.5pt, stroke: 1.2pt + c-accent)
})
