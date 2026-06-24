#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A git tree. `withM` adds the merge commit M (main on M, else on C2);
  // `withDev` shows the dev label on D2.
  let graph(ox, withM, withDev) = {
    cm(ox, 0, "C1"); cm(ox + 1.3, 0, "C2")
    arr((ox + 0.4, 0), (ox + 0.9, 0))
    cm(ox + 2.6, 0.95, "D1"); cm(ox + 3.9, 0.95, "D2")
    arr((ox + 1.6, 0.2), (ox + 2.2, 0.7))
    arr((ox + 3.0, 0.95), (ox + 3.5, 0.95))
    if withDev {
      seg((ox + 3.9, 1.37), (ox + 3.9, 1.62), lc: cdev); tag(ox + 3.9, 1.85, "dev", col: cdev)
    }
    if withM {
      cm(ox + 5.2, 0, "M")
      arr((ox + 4.3, 0.7), (ox + 4.85, 0.2))
      arr((ox + 1.65, 0), (ox + 4.8, 0))
      seg((ox + 5.2, 0.42), (ox + 5.2, 0.67), lc: cmain); tag(ox + 5.2, 0.9, "main")
    } else {
      seg((ox + 1.3, 0.42), (ox + 1.3, 0.67), lc: cmain); tag(ox + 1.3, 0.9, "main")
    }
  }

  let zone(x0, x1, label) = {
    rect((x0, -0.7), (x1, 2.3), stroke: (dash: "dashed", paint: cgray), radius: 6pt)
    content((x0 + 0.25, 2.05), anchor: "west", text(size: 10pt, weight: "bold", fill: cgray, label))
  }

  // Local: main still at C2, with the now-merged dev left over.
  zone(-0.6, 4.6, "Local")
  graph(0, false, true)

  // Remote: main already advanced to M by the Pull Request.
  zone(6.0, 12.5, "Remote")
  graph(6.5, true, false)

  // pull the merged main down to the local repo
  arr((5.9, 0.35), (4.7, 0.35))
  content((5.3, 0.72), text(size: 9pt, weight: "bold", fill: cdark)[git pull])
})
