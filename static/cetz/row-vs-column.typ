#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

// Per-column tints (light fills, dark text) and their saturated header colours,
// all derived from the site theme palette in helpers.typ.
#let c1 = cmain.lighten(65%) // id   (accent teal)
#let c2 = cdev.lighten(70%)  // fare (accent2 red)
#let c3 = cpink.lighten(65%) // tip  (pink)
#let c1d = cmain
#let c2d = cdev
#let c3d = cpink
#let skip = cdark.lighten(90%) // a skipped (unread) cell

#cetz.canvas({
  import cetz.draw: *

  let ch = 0.6

  // --- Storage-tape geometry (defined first so everything shares a centre) ---
  let sw = 0.8
  let gg = 0.35
  let xpos(i) = sw / 2 + i * sw + calc.floor(i / 3) * gg
  let mid = (xpos(0) - sw / 2 + xpos(8) + sw / 2) / 2 // common centre line

  let cols = (c1, c2, c3)

  // A cell. `target = true` draws the thick border used for the wanted column.
  let cell(cx, cy, body, fill, tc: cdark, w: 1.25, target: false) = {
    let st = if target { 1.8pt + cdev } else { 0.8pt + cdark }
    rect((cx - w / 2, cy - ch / 2), (cx + w / 2, cy + ch / 2), fill: fill, stroke: st)
    content((cx, cy), text(size: 10pt, fill: tc, body))
  }

  // --- Logical table (centred on `mid`) --------------------------------------
  let cw = 1.25
  let lx = (mid - cw, mid, mid + cw)
  content((mid, 5.2), text(size: 11pt, weight: "bold", fill: cdark, "Logical table"))
  cell(lx.at(0), 4.55, "id", c1d, tc: white)
  cell(lx.at(1), 4.55, "fare", c2d, tc: white)
  cell(lx.at(2), 4.55, "tip", c3d, tc: white)
  let vals = (("1", "7.0", "1.5"), ("2", "9.0", "0.0"), ("3", "5.0", "2.0"))
  for r in range(3) {
    for c in range(3) {
      cell(lx.at(c), 3.95 - r * 0.6, vals.at(r).at(c), cols.at(c))
    }
  }

  // Query cue (centred).
  content((mid, 1.95), text(size: 11pt, weight: "bold", fill: cdev,
    [Q: read the *fare* column]))

  // A bracket drawn below a span of the tape, with a label underneath.
  let read_bracket(i0, i1, ytape, label, col) = {
    let x0 = xpos(i0) - sw / 2
    let x1 = xpos(i1) + sw / 2
    let yb = ytape - ch / 2 - 0.16
    line((x0, yb), (x1, yb), stroke: 1.2pt + col)
    line((x0, yb), (x0, yb + 0.13), stroke: 1.2pt + col)
    line((x1, yb), (x1, yb + 0.13), stroke: 1.2pt + col)
    content(((x0 + x1) / 2, yb - 0.32), text(size: 10pt, weight: "medium", fill: col, label))
  }

  // Row-oriented: every field of a record sits together; fare is scattered, so
  // collecting the fare column means reading the whole file.
  content((mid, 1.35), text(size: 11pt, weight: "bold", fill: cdark, "Row-oriented (CSV)"))
  let row_items = (
    ("1", c1, false), ("7.0", c2, true), ("1.5", c3, false),
    ("2", c1, false), ("9.0", c2, true), ("0.0", c3, false),
    ("3", c1, false), ("5.0", c2, true), ("2.0", c3, false),
  )
  for i in range(9) {
    let it = row_items.at(i)
    cell(xpos(i), 0.8, it.at(0), it.at(1), w: sw, target: it.at(2))
  }
  read_bracket(0, 8, 0.8, "read all 9 cells to get fare", cdark)

  // Column-oriented: each column sits together; reading fare touches one block
  // and skips id / tip entirely (shown greyed out).
  content((mid, -1.35),
    text(size: 11pt, weight: "bold", fill: cdark, "Column-oriented (Parquet)"))
  let col_items = (
    ("1", skip, false), ("2", skip, false), ("3", skip, false),
    ("7.0", c2, true), ("9.0", c2, true), ("5.0", c2, true),
    ("1.5", skip, false), ("0.0", skip, false), ("2.0", skip, false),
  )
  for i in range(9) {
    let it = col_items.at(i)
    let tc = if it.at(1) == skip { cgray } else { cdark }
    cell(xpos(i), -1.9, it.at(0), it.at(1), tc: tc, w: sw, target: it.at(2))
  }
  content((xpos(1), -1.9 - ch / 2 - 0.45), text(size: 9pt, fill: cgray, "skipped"))
  content((xpos(7), -1.9 - ch / 2 - 0.45), text(size: 9pt, fill: cgray, "skipped"))
  read_bracket(3, 5, -1.9, "read only 3 cells", cdev)
})
