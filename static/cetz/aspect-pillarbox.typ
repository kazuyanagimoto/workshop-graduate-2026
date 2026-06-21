// Anti-pattern figure: a 4:3 slide shown on a 16:9 monitor leaves bars
// (pillarboxes) on the left and right. Self-contained (no external image) so it
// builds through the same typst -> svg target as the CeTZ diagrams.
//
// The slide mimics a default Beamer title slide closely: Computer Modern Sans
// (Latin Modern Sans, found via --font-path in the targets pipeline), Beamer's
// default sizes at an 11pt base, the structure blue, and a vertically centred
// title block.
//
// Monitor = 16:9, height 9.6cm; slide = 4:3, 12.8cm x 9.6cm (real Beamer frame
// size) centred, so (17.07 - 12.8) / 2 = 2.13cm of bar shows on each side.

#let mon-h = 9.6cm
#let mon-w = 9.6cm * 16 / 9   // 16:9
#let sl-w = 12.8cm            // 4:3 frame
#let sl-h = 9.6cm

#set page(width: mon-w, height: mon-h, margin: 0pt, fill: rgb("#3a3b3f"))

#let bblue = rgb("#3333b3") // Beamer default structure/title blue

#let slide-body = {
  set text(font: "Latin Modern Sans", fill: black)
  set align(center)
  // Beamer default title-page sizes at an 11pt base, vertically centred block.
  stack(
    dir: ttb,
    text(14.4pt, fill: bblue)[A Typical Beamer Talk],   // \Large
    v(9pt),                                             // 0.25em of title
    text(12pt, fill: bblue)[Default Theme, Default Everything], // \large
    v(29pt),                                            // title box sep + 1em + author sep
    text(10.95pt)[Your Name],                           // \normalsize
    v(17pt),                                            // author sep + institute sep
    text(9pt)[Your University],                         // \footnotesize
    v(18pt),
    text(10.95pt)[June 21, 2026],                       // \normalsize
  )
}

#place(center + horizon, box(width: sl-w, height: sl-h, fill: white)[
  #place(center + horizon, dy: -0.17cm, slide-body)
])
