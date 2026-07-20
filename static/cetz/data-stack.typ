#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A tier box with a bold title and a small grey subtitle.
  let box(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.18), text(size: 13pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.28), text(size: 9.5pt, fill: cgray, sub))
  }

  let mid = 3.5
  let ex1 = 1.5 // Polars centre
  let ex2 = 5.5 // DuckDB centre

  // --- Tiers -----------------------------------------------------------------
  box(mid, 3.5, 7.4, 1.3, "Your R code", "dplyr verbs: filter() |> summarise()", cbox)
  box(ex1, 1.0, 3.4, 1.3, "Polars", "dataframe library", cnode)
  box(ex2, 1.0, 3.4, 1.3, "DuckDB", "SQL engine", cnode)
  box(mid, -1.5, 7.4, 1.3, "Parquet file", "columnar format (on disk)", cbox)

  // --- Connectors (code <-> engines), one per engine, tagged with its wrapper -
  line((ex1, 2.85), (ex1, 1.65), stroke: 1pt + cgray)
  line((ex2, 2.85), (ex2, 1.65), stroke: 1pt + cgray)
  tag(ex1, 2.25, "tidypolars", col: cmain)
  tag(ex2, 2.25, "duckplyr", col: cdev)

  // --- Connectors (engines <-> file) -----------------------------------------
  line((ex1, 0.35), (ex1, -0.85), stroke: 1pt + cgray)
  line((ex2, 0.35), (ex2, -0.85), stroke: 1pt + cgray)
  tag(mid, -0.25, "read only needed columns & rows", col: cgray)

  // --- Right-hand tier labels ------------------------------------------------
  content((7.55, 3.5), anchor: "west", text(size: 10pt, fill: cgray, "Interface"))
  content((7.55, 1.0), anchor: "west", text(size: 10pt, fill: cgray, "Engine"))
  content((7.55, -1.5), anchor: "west", text(size: 10pt, fill: cgray, "Storage"))

  // --- Data-flow arrow (disk -> engine -> your result) -----------------------
  arr((-0.65, -2.05), (-0.65, 4.05), lc: cdev)
  content((-0.95, 1.0), std.rotate(90deg,
    text(size: 10pt, weight: "bold", fill: cdev, "Data flow")))
})
