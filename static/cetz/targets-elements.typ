// The three elements of a pipeline: files, objects and functions.
// Shared with the workshop deck (anim-elements in slides/ai-pipeline/typst/targets.typ).
#import "deck-helpers.typ": *
#show: figure-page

#let card(x, title, fn, desc, shape) = {
  import cetz.draw: *
  rect((x - 4.05, 5.0), (x + 4.05, 10.2), radius: 7pt, fill: c-panel, stroke: none)
  shape
  content((x, 8.0), lab(title, size: 17pt, weight: "medium"))
  content((x, 7.1), mono(fn, size: 12pt, fill: c-accent))
  content((x, 5.85), box(width: 7.8cm, align(center, {
    set par(leading: 0.45em)
    lab(desc, size: 10pt, fill: c-muted)
  })))
}

#stage(26, 10.4, {
  import cetz.draw: *
  card(4.5, "File", "tar_file()", "The path, plus a fingerprint\nof the contents", {
    doc-icon((4.5, 9.25), w: 1.05, h: 1.3, tag: "csv")
  })
  card(13, "Object", "name = ...", "Any R object, such as\na data frame or a model", {
    circle((13, 9.25), radius: 0.5, fill: c-ok, stroke: none)
  })
  card(21.5, "Function", "function(inputs) ...", "Takes all inputs as arguments,\nreturns an object or a path", {
    line((21.5 - 0.58, 8.85), (21.5 + 0.58, 8.85), (21.5, 9.8), close: true, fill: c-ok, stroke: none)
  })
  let y = 1.9
  doc-icon((3.0, y + 0.1), w: 1.3, h: 1.6, tag: "csv")
  arrow((3.8, y), (5.9, y), w: 1.6pt, head: 1.3)
  tnode((6.6, y), "penguins_file", status: "outdated")
  tedge((6.6, y), (12.6, y))
  tnode((12.6, y), "penguins", status: "outdated")
  tedge((12.6, y), (20.2, y))
  tnode((20.2, y), "penguins_cleaned", status: "outdated")
  tnode((16.4, y + 1.6), "clean_penguins()", status: "outdated", kind: "function", above: true)
  tedge((16.4, y + 1.6), (20.2, y), ra: 0.58)
})
