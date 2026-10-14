// Step 1 of the clean room: dummy data share the schema of the real data, not
// their values. All rows are illustrative, not records from the research data.
// Shared with the workshop deck (fig-dummy-data in slides/ai-pipeline/typst/cleanroom.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 5.2, {
  import cetz.draw: *
  let data-panel(x, rows, col) = {
    rect((x, 0.3), (x + 9.8, 4.3), radius: 6pt, fill: white, stroke: 1.2pt + col)
    content((x + 4.9, 2.3), box(width: 9cm, {
      set text(font: "Fira Code", size: 14pt, ligatures: false, features: (calt: 0))
      std.table(
        columns: (1.2cm, 1.6cm, 1.8cm, 3.2cm, 1.2cm),
        stroke: none,
        inset: (x: 1pt, y: 5pt),
        table.header([id], [year], [black], [log_salary], [cem]),
        table.hline(stroke: 0.7pt + c-faint),
        ..rows.flatten().map(v => text(fill: col, v)),
      )
    }))
  }
  dest-heading(0.3, 10.1, 4.75, "Real data", "stays with you", c-accent2)
  data-panel(0.3, (
    ("1", "1911", "0", "7.25", "1.4"),
    ("1", "1913", "0", "7.56", "1.4"),
    ("2", "1911", "1", "6.93", "0.8"),
  ), c-accent2)
  dest-heading(15.9, 25.7, 4.75, "Dummy data", "to the clean room", c-accent)
  data-panel(15.9, (
    ("501", "1911", "1", "8.31", "1.0"),
    ("501", "1913", "1", "8.96", "1.0"),
    ("502", "1911", "0", "5.12", "0.7"),
  ), c-accent)
  // The header row crosses, at the height of the header; the value rows do not.
  arrow((10.4, 3.5), (15.6, 3.5), col: c-accent, w: 1.8pt, head: 1.2)
  content((13.0, 4.05), lab("names and types", size: 11pt, weight: "medium", fill: c-accent))
  arrow((10.4, 1.9), (15.6, 1.9), col: c-accent2, dash: "dashed", w: 1.4pt)
  cross-mark(13.0, 1.9, s: 1.6, col: c-accent2)
  content((13.0, 2.45), lab("values", size: 11pt, weight: "medium", fill: c-accent2))
  content((0.3, -0.35), anchor: "west", lab("All values are illustrative, not records from the data.", size: 9.5pt, fill: c-muted))
})
