#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let mid = 3.5

  // A wide tier box with a bold title and a small grey subtitle.
  let box(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.14), text(size: 13pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.24), text(size: 9.5pt, fill: cgray, sub))
  }

  // A small engine box (centred title, no subtitle).
  let ebox(cx, title) = {
    rect((cx - 1.0, 1.55), (cx + 1.0, 2.45), fill: cnode, stroke: 1pt + cdark, radius: 4pt)
    content((cx, 2.0), text(size: 12pt, weight: "bold", fill: cdark, title))
  }

  // --- Engines that share Arrow (top) ----------------------------------------
  ebox(2.0, "Polars")
  ebox(5.0, "DuckDB")
  // They hand data to each other without copying.
  arr((3.0, 2.0), (4.0, 2.0), lc: cmain)
  arr((4.0, 2.0), (3.0, 2.0), lc: cmain)
  content((mid, 2.62), text(size: 10pt, weight: "bold", fill: cmain, "コピーなしで受け渡し"))

  // --- Memory: Arrow ---------------------------------------------------------
  box(mid, 0.2, 7.0, 1.0, "Arrow", "列指向・メモリ (RAM) — エンジン共通の形式", cnode)
  line((2.0, 1.55), (2.0, 0.7), stroke: 1pt + cgray)
  line((5.0, 1.55), (5.0, 0.7), stroke: 1pt + cgray)

  // --- Disk: Parquet ---------------------------------------------------------
  box(mid, -1.6, 7.0, 1.0, "Parquet", "列指向・ディスク", cbox)
  arr((mid, -1.1), (mid, -0.3), lc: cdev)
  content((mid + 0.6, -0.7), anchor: "west", text(size: 10pt, fill: cdev, "読み込み"))
})
