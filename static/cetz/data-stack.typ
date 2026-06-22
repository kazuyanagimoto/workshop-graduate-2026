#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A tier box with a bold title and a small grey subtitle.
  let box(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.14), text(size: 11pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.24), text(size: 7.5pt, fill: cgray, sub))
  }

  let mid = 3.5
  let ex1 = 1.75 // Polars centre
  let ex2 = 5.25 // DuckDB centre

  // --- Tiers -----------------------------------------------------------------
  box(mid, 3.0, 7.4, 1.1, "あなたの R コード", "dplyr の動詞: filter() |> summarise()", cbox)
  box(ex1, 1.0, 3.4, 1.1, "Polars", "dataframe library", cnode)
  box(ex2, 1.0, 3.4, 1.1, "DuckDB", "in-process SQL engine", cnode)
  box(mid, -1.0, 7.4, 1.1, "Parquet ファイル", "列指向フォーマット (ディスク上)", cbox)

  // --- Connectors (code <-> engines), one per engine, tagged with its wrapper -
  line((ex1, 2.45), (ex1, 1.55), stroke: 1pt + cgray)
  line((ex2, 2.45), (ex2, 1.55), stroke: 1pt + cgray)
  tag(ex1, 2.0, "tidypolars", col: cmain)
  tag(ex2, 2.0, "duckplyr", col: cdev)

  // --- Connectors (engines <-> file) -----------------------------------------
  line((ex1, 0.45), (ex1, -0.45), stroke: 1pt + cgray)
  line((ex2, 0.45), (ex2, -0.45), stroke: 1pt + cgray)
  tag(mid, 0.0, "必要な列・行だけ読む", col: cgray)

  // --- Right-hand tier labels ------------------------------------------------
  content((7.45, 3.0), anchor: "west", text(size: 8pt, fill: cgray, "書き方"))
  content((7.45, 1.0), anchor: "west", text(size: 8pt, fill: cgray, "処理エンジン"))
  content((7.45, -1.0), anchor: "west", text(size: 8pt, fill: cgray, "保存形式"))

  // --- Data-flow arrow (disk -> engine -> your result) -----------------------
  arr((-0.45, -1.4), (-0.45, 3.4), lc: cdev)
  content((-0.75, 1.0), std.rotate(90deg,
    text(size: 8pt, weight: "bold", fill: cdev, "データの流れ")))
})
