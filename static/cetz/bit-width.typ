#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 6pt, fill: none)
#set text(font: "Noto Sans JP")

// A row of bit cells starting at (x, y), returning after drawing `digits`
// followed by an ellipsis, with a caption under the field.
#let bitfield(x, y, digits, label) = {
  import cetz.draw: *
  let w = 0.34
  for (i, d) in digits.enumerate() {
    rect((x + i * w, y - 0.25), (x + (i + 1) * w, y + 0.25),
      fill: cnode, stroke: 0.8pt + cdark)
    content((x + (i + 0.5) * w, y), text(size: 9pt, fill: cdark, str(d)))
  }
  content((x + digits.len() * w + 0.22, y), text(size: 11pt, fill: cdark, "…"))
  content((x + digits.len() * w / 2, y - 0.55), text(size: 9pt, fill: cgray, label))
}

// A memory bar from x0 to x1 with light address ticks.
#let membar(x0, x1, y, label, open: false) = {
  import cetz.draw: *
  rect((x0, y - 0.3), (x1, y + 0.3), fill: cbox, stroke: 1pt + cdark)
  let t = x0 + 0.2
  while t < x1 - 0.05 {
    line((t, y - 0.3), (t, y + 0.3), stroke: 0.5pt + cgray)
    t = t + 0.2
  }
  if open {
    content((x1 + 0.25, y), text(size: 11pt, fill: cdark, "…"))
  }
  content(((x0 + x1) / 2, y - 0.62), text(size: 10pt, fill: cdark, label))
}

#cetz.canvas({
  import cetz.draw: *

  // Column headers
  content((-3.4, 3.35), text(size: 10pt, fill: cgray, weight: "bold", "Address"))
  content((2.6, 3.35), text(size: 10pt, fill: cgray, weight: "bold", "Memory (RAM)"))

  // 32-bit row
  content((-4.85, 2.4), anchor: "east", text(size: 12pt, fill: cdark, weight: "bold", "32-bit CPU"))
  bitfield(-4.7, 2.4, (1, 0, 1, 1, 0), "32 bits")
  arr((-2.1, 2.4), (-0.4, 2.4), lc: cgray)
  membar(0, 1.6, 2.4, [$2^32$ addresses = 4 GB])

  // 64-bit row
  content((-4.85, 0.5), anchor: "east", text(size: 12pt, fill: cdark, weight: "bold", "64-bit CPU"))
  bitfield(-4.7, 0.5, (1, 0, 1, 1, 0, 0, 1, 0, 1, 1), "64 bits")
  arr((-0.9, 0.5), (-0.4, 0.5), lc: cgray)
  membar(0, 5.6, 0.5, [$2^64$ addresses ≈ 16 EB], open: true)

  // Honesty note: the bars cannot be drawn to scale
  content((0, -0.75), anchor: "west",
    text(size: 9pt, fill: cgray, [not to scale: $2^64$ is 4 billion times $2^32$]))
})
