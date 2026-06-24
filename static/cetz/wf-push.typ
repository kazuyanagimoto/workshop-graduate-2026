#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A git tree: C1-C2 on main, with D1-D2 on dev branched up from C2.
  // `hot` highlights the dev commits (used on the remote, freshly pushed).
  let graph(ox, hot) = {
    let dbg = if hot { rgb("#fbe3da") } else { cnode }
    cm(ox, 0, "C1"); cm(ox + 1.5, 0, "C2")
    arr((ox + 0.45, 0), (ox + 1.05, 0))
    cm(ox + 3.0, 1.1, "D1", bg: dbg); cm(ox + 4.5, 1.1, "D2", bg: dbg)
    arr((ox + 1.85, 0.25), (ox + 2.55, 0.85))
    arr((ox + 3.45, 1.1), (ox + 4.05, 1.1))
    seg((ox + 1.5, 0.42), (ox + 1.5, 0.72), lc: cmain); tag(ox + 1.5, 0.95, "main")
    seg((ox + 4.5, 1.52), (ox + 4.5, 1.82), lc: cdev); tag(ox + 4.5, 2.05, "dev", col: cdev)
  }

  let zone(x0, x1, label) = {
    rect((x0, -0.7), (x1, 2.65), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
    content((x0 + 0.25, 2.35), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray, label))
  }

  // Local: built main (C1-C2) and dev (D1-D2).
  zone(-0.6, 5.2, "Local")
  graph(0, false)

  // Remote: shares main; push adds the dev branch (highlighted).
  zone(7.0, 12.8, "Remote")
  graph(7.6, true)

  // push the dev branch from local to remote
  arr((5.3, 1.1), (6.9, 1.1))
  content((6.1, 1.5), text(size: 9pt, weight: "bold", fill: cdark)[git push dev])
})
