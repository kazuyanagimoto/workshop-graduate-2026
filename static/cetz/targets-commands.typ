// The four commands to remember.
// Shared with the workshop deck (fig-commands in slides/ai-pipeline/typst/targets.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 11.2, {
  import cetz.draw: *
  let card(x, cmds, what, body) = {
    rect((x - 3.1, 0.3), (x + 3.1, 11.0), radius: 7pt, fill: c-panel, stroke: none)
    for (i, cmd) in cmds.enumerate() {
      content((x, 10.1 - i * 0.75), mono(cmd, size: 12.5pt, fill: c-accent))
    }
    content((x, 1.6), box(width: 5.6cm, align(center, {
      set par(leading: 0.45em)
      lab(what, size: 12pt)
    })))
    body
  }
  let mini(x, y, sts) = {
    let pts = ((x - 1.8, y), (x, y), (x + 1.8, y))
    tedge(pts.at(0), pts.at(1), ra: 0.4, rb: 0.4)
    tedge(pts.at(1), pts.at(2), ra: 0.4, rb: 0.4)
    for (i, p) in pts.enumerate() {
      tnode(p, "", status: sts.at(i), r: 0.4)
    }
  }
  card(3.2, ("tar_visnetwork()",), "Shows the graph\nand its status", {
    mini(3.2, 5.9, ("ok", "outdated", "outdated"))
  })
  card(9.73, ("tar_outdated()",), "Lists the\noutdated targets", {
    content((9.73, 6.3), mono("\"penguins_cleaned\"", size: 10pt))
    content((9.73, 5.5), mono("\"penguins_summary\"", size: 10pt))
  })
  card(16.27, ("tar_make()",), "Reruns the outdated\ntargets in order", {
    mini(16.27, 6.9, ("ok", "run", "outdated"))
    arrow((16.27, 6.2), (16.27, 5.3), w: 1.6pt, head: 1.3)
    mini(16.27, 4.6, ("ok", "ok", "ok"))
  })
  card(22.8, ("tar_read()", "tar_load()"), "Reads a stored\nresult", {
    tnode((21.4, 5.9), "", status: "ok", r: 0.4)
    arrow((22.0, 5.9), (23.0, 5.9), w: 1.6pt, head: 1.3)
    // A small table.
    rect((23.2, 5.1), (24.9, 6.7), stroke: 1.1pt + c-jet, fill: white)
    line((23.2, 6.2), (24.9, 6.2), stroke: 1.1pt + c-jet)
    line((23.2, 5.65), (24.9, 5.65), stroke: 0.7pt + c-muted)
    line((24.05, 5.1), (24.05, 6.7), stroke: 0.7pt + c-muted)
  })
})
