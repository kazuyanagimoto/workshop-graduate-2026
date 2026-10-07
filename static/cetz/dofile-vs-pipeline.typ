#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A box with a title and an optional muted subtitle.
  let node(cx, cy, w, title, sub, fill, tc: cdark, sc: cgray) = {
    rect((cx - w / 2, cy - 0.5), (cx + w / 2, cy + 0.5),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    if sub == none {
      content((cx, cy), text(size: 11pt, weight: "medium", fill: tc, title))
    } else {
      content((cx, cy + 0.16), text(size: 11pt, weight: "medium", fill: tc, title))
      content((cx, cy - 0.24), text(size: 8.5pt, fill: sc, sub))
    }
  }

  // --- Left: the replication package ----------------------------------------
  // Every do-file reads the data on its own; two of them run the same
  // event-study regression.
  cap(3.0, 6.2, text(weight: "bold", "Replication package"), sz: 12pt)

  node(1.2, 2.4, 2.9, "register_panel", ".dta", cbox)
  let dofiles = (
    ("table 1.do", 4.8, cnode),
    ("table 2.do", 3.6, cnode),
    ("figure 1.do", 2.4, cnode),
    ("figure 2.do", 1.2, chot),
    ("figure 3.do", 0.0, chot),
  )
  for (lab, y, col) in dofiles {
    node(4.9, y, 2.4, lab, none, col)
    arr((2.65, 2.4), (3.65, y))
  }
  cap(4.9, -0.85, "same event study, run twice", col: cdev, sz: 9pt)

  // Divider between the two panels.
  line((7.1, -1.1), (7.1, 6.5), stroke: (paint: cgray, thickness: 0.8pt, dash: "dashed"))

  // --- Right: the targets pipeline ------------------------------------------
  // The event study is one target that both figures read.
  cap(14.2, 6.2, text(weight: "bold", "targets pipeline"), sz: 12pt)

  node(9.0, 2.4, 2.9, "register_panel", "file", cbox)
  node(12.0, 2.4, 2.0, "register", "cleaned", cnode)
  node(15.6, 4.2, 3.6, "analysis_did", none, cnode)
  node(15.6, 2.4, 3.6, "analysis_event", none, cmain, tc: white)
  node(15.6, 0.6, 3.6, "analysis_placebo", none, cnode)

  // The manuscript draws the tables and figures from the targets.
  rect((18.0, -0.3), (20.8, 5.4), fill: none,
    stroke: (paint: cgray, thickness: 0.8pt, dash: "dashed"), radius: 4pt)
  cap(19.4, 5.05, "manuscript/", col: cgray, sz: 9pt)
  node(19.4, 4.2, 2.2, "Table II", none, cbox)
  node(19.4, 2.4, 2.2, "Figure II", none, cbox)
  node(19.4, 0.6, 2.2, "Figure III", none, cbox)

  arr((10.45, 2.4), (10.95, 2.4), lc: cmain)
  arr((13.0, 2.6), (13.75, 4.0), lc: cmain)
  arr((13.0, 2.4), (13.75, 2.4), lc: cmain)
  arr((13.0, 2.2), (13.75, 0.8), lc: cmain)
  arr((17.4, 4.2), (18.25, 4.2), lc: cmain)
  arr((17.4, 2.4), (18.25, 2.4), lc: cmain)
  arr((17.4, 2.2), (18.25, 0.8), lc: cmain)
  arr((17.4, 0.6), (18.25, 0.6), lc: cmain)
})
