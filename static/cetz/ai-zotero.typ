// Collecting and reading papers with AI and Zotero: DOIs make fake papers
// fail to import, and page numbers make every claim checkable.
// Shared with the workshop deck (anim-zotero in slides/ai-pipeline/typst/reading.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 10.6, {
  import cetz.draw: *
  ai-icon((1.5, 7.7), s: 1.3)
  circle((2.55, 8.75), radius: 0.28, fill: white, stroke: 1.4pt + c-accent)
  line((2.75, 8.55), (3.05, 8.25), stroke: (paint: c-accent, thickness: 1.4pt, cap: "round"))
  content((1.5, 6.3), box(width: 3.0cm, align(center, lab("AI + search", size: 11pt))))
  arrow((2.7, 7.6), (3.9, 7.6), w: 1.7pt, head: 1.3)

  rect((4.1, 4.9), (12.0, 10.4), radius: 7pt, fill: c-panel, stroke: none)
  content((4.6, 9.65), anchor: "west", lab("DOI list", size: 12pt, weight: "medium"))
  content((4.6, 8.15), anchor: "west", mono("10.1093/qje/qjab040", size: 10pt))
  line((4.6, 7.35), (11.5, 7.35), stroke: 0.8pt + c-faint)
  content((4.6, 6.55), anchor: "west", mono("10.1093/restud/rdad018", size: 10pt))

  arrow((12.2, 7.6), (13.5, 7.6), w: 1.7pt, head: 1.3)
  content((12.85, 8.15), lab("import", size: 9pt, fill: c-muted))
  rect((13.7, 4.9), (20.1, 10.4), radius: 7pt, fill: c-tint, stroke: none)
  content((16.9, 9.85), lab("Zotero", size: 12pt, weight: "medium", fill: c-accent.darken(15%)))
  for r in range(2) {
    for c in range(3) {
      doc-icon((14.9 + c * 1.65, 8.75 - r * 1.65), w: 0.85, h: 1.05, fill: white, stroke: 1pt + c-accent.darken(10%))
    }
  }
  content((16.9, 5.35), lab("PDFs attached", size: 10.5pt, fill: c-accent.darken(15%)))

  arrow((16.9, 4.7), (16.9, 3.5), w: 1.7pt, head: 1.3)
  content((17.2, 4.1), anchor: "west", lab("reads the full text via MCP", size: 10pt, fill: c-muted))
  ai-icon((16.9, 2.3), s: 1.2)
  arrow((18.1, 2.2), (19.6, 2.2), w: 1.7pt, head: 1.3)
  rect((19.8, 0.8), (25.8, 3.6), radius: 4pt, fill: white, stroke: 1.2pt + c-jet)
  content((22.8, 2.75), lab("summary + evidence", size: 11pt))
  content((22.8, 1.65), box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 5pt, y: 3pt), lab("p. 926", size: 11pt)))

  person-icon((23.2, 8.1), s: 1.4)
  content((23.2, 6.65), box(width: 5.2cm, align(center, lab("checks the page in the original", size: 11pt))))
  arrow((23.2, 3.8), (23.2, 5.6), col: c-accent, w: 1.8pt, head: 1.3)
  arrow((22.0, 8.3), (20.3, 8.3), col: c-accent, w: 1.8pt, head: 1.3)
})
