#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A box with a title and an optional muted subtitle.
  let node(cx, cy, w, title, sub, fill, tc: cdark, sc: cgray) = {
    rect((cx - w / 2, cy - 0.55), (cx + w / 2, cy + 0.55),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    if sub == none {
      content((cx, cy), text(size: 11pt, weight: "medium", fill: tc, title))
    } else {
      content((cx, cy + 0.17), text(size: 11pt, weight: "medium", fill: tc, title))
      content((cx, cy - 0.25), text(size: 8.5pt, fill: sc, sub))
    }
  }

  // A polyline with an arrow head at the end.
  let path(..pts, lc: cdark, dash: none) = {
    line(..pts, stroke: (paint: lc, thickness: 1.1pt, dash: dash),
      mark: (end: ">", fill: lc))
  }

  // --- Zones ------------------------------------------------------------------
  // The answer key never leaves the left zone; the replicator never sees code.
  rect((-0.6, -0.9), (8.4, 11.8), fill: none,
    stroke: (paint: cgray, thickness: 1pt, dash: "dashed"), radius: 6pt)
  cap(3.9, 11.35, text(weight: "bold", "Your project"), sz: 12pt)

  rect((9.4, -0.9), (22.8, 11.8), fill: none,
    stroke: (paint: cgray, thickness: 1pt, dash: "dashed"), radius: 6pt)
  cap(16.1, 11.35, text(weight: "bold", "Clean room (another AI)"), sz: 12pt)

  // --- Your project: Steps 0, 1, and 3 -----------------------------------------
  node(4.2, 9.4, 6.0, "manuscript + pipeline", "numbers as inline code", white)
  tag(1.95, 10.3, "Step 0", col: cdev)

  node(4.2, 6.8, 6.0, "masking & dummy-data scripts", none, white)
  tag(1.95, 7.7, "Step 1", col: cdev)

  node(4.2, 4.2, 4.8, "answer.csv", "value + expression per ID", white)

  node(4.2, 1.2, 6.0, "compare & triage", "code, paper, or replicator?", white)
  tag(1.95, 2.1, "Step 3", col: cdev)

  arr((4.2, 8.85), (4.2, 7.35))           // manuscript -> scripts
  arr((4.2, 6.25), (4.2, 4.75))           // scripts -> answer.csv
  arr((4.2, 3.65), (4.2, 1.75))           // answer.csv -> compare

  // Step 3 loops back to Step 0 when the code or the paper must change.
  path((1.2, 1.2), (0.2, 1.2), (0.2, 9.4), (1.15, 9.4), lc: cdev)
  content((-0.2, 5.3), angle: 90deg,
    text(size: 9pt, fill: cdev, "fix the code or the paper, back to Step 0"))

  // --- Clean room: Step 2 ------------------------------------------------------
  node(12.0, 9.4, 4.6, "masked manuscript", "numbers replaced by IDs", white)
  node(12.0, 6.8, 4.6, "dummy data", "same columns, random values", white)
  node(12.0, 4.2, 4.6, "TASK.md, AGENTS.md", "task and rules", white)

  node(19.0, 6.8, 4.4, "replicator", "another AI, no code", cmain,
    tc: white, sc: cbox)
  tag(17.55, 7.7, "Step 2", col: cdev)

  node(15.6, 1.2, 4.4, "replication.csv", "its code run on real data", white)
  node(20.2, 1.2, 4.2, "ambiguity.md", "what the paper left open", white)

  arr((7.2, 7.15), (9.65, 9.1))           // scripts -> masked manuscript
  arr((7.2, 6.8), (9.65, 6.8))            // scripts -> dummy data
  arr((14.3, 9.2), (16.75, 7.2))          // inputs -> replicator
  arr((14.3, 6.8), (16.75, 6.8))
  arr((14.3, 4.4), (16.75, 6.4))
  arr((18.2, 6.25), (16.0, 1.75))         // replicator -> replication.csv
  arr((19.8, 6.25), (20.2, 1.75))         // replicator -> ambiguity.md

  // --- Back to the key side ----------------------------------------------------
  arr((13.4, 1.2), (7.25, 1.2))           // replication.csv -> compare
  path((20.2, 0.65), (20.2, -0.35), (4.2, -0.35), (4.2, 0.6))  // ambiguity.md

  // Feedback to the replicator carries identifiers and sections, never values.
  path((7.2, 1.55), (8.9, 2.6), (17.1, 2.6), (17.1, 6.2),
    lc: cdev, dash: "dashed")
  cap(11.6, 2.9, "IDs and sections only", col: cdev, sz: 9pt)
})
