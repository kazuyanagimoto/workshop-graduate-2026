// A number typed by hand stays stale; inline code is updated with the
// pipeline. The estimates are those of the targets-quarto example before and
// after the change to clean_did(), read from the deck's measured results
// (slides/ai-pipeline/data/quarto-example.csv, made by
// slides/ai-pipeline/code/make-example-results.R), so compile from the
// repository root with `--root .`.
// Shared with the workshop deck (anim-inline in slides/ai-pipeline/typst/quarto.typ).
#import "deck-helpers.typ": *
#show: figure-page

#let runs = csv("/slides/ai-pipeline/data/quarto-example.csv", row-type: dictionary)
#let est(name) = {
  let v = calc.round(float(runs.find(r => r.scenario == name).estimate), digits: 2)
  let parts = str(v).split(".")
  let dec = if parts.len() > 1 { parts.at(1) } else { "" }
  parts.at(0) + "." + dec + "0" * (2 - dec.len())
}
#let (before, after) = (est("base"), est("clean"))

#stage(26, 10.2, {
  import cetz.draw: *
  let lane(y, title, src, value, state) = {
    content((0.2, y + 0.9), anchor: "west", lab(title, size: 14pt, weight: "medium"))
    // Source.
    rect((0.2, y - 1.1), (15.4, y + 0.4), radius: 5pt, fill: c-panel, stroke: none)
    content((0.6, y - 0.35), anchor: "west", src)
    arrow((15.6, y - 0.35), (17.2, y - 0.35), w: 1.6pt, head: 1.3)
    // Rendered sentence.
    rect((17.5, y - 1.1), (25.8, y + 0.4), radius: 2pt, fill: white, stroke: 1.2pt + c-jet)
    let num-fill = if state == "stale" { c-accent2 } else { c-ok }
    content((17.9, y - 0.35), anchor: "west", {
      lab("the estimate is ", size: 12pt)
      box(fill: num-fill, radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, mono(value, size: 12pt, fill: white))
      lab(".", size: 12pt)
    })
    if state == "stale" { chip((25.6, y + 0.4), "stale", fill: c-accent2, anchor: "east") }
    if state == "fresh" { chip((25.6, y + 0.4), "updated", fill: c-ok, anchor: "east") }
  }
  content((7.8, 9.8), lab("manuscript source", size: 11pt, fill: c-muted))
  content((21.65, 9.8), lab("rendered PDF", size: 11pt, fill: c-muted))
  lane(7.9, "Typed by hand", mono("the estimate is " + before + ".", size: 12pt), before, "stale")
  lane(4.6, "Inline code", {
    mono("the estimate is ", size: 12pt)
    box(fill: c-accent.lighten(78%), radius: 3pt, inset: (x: 4pt, y: 3pt), baseline: 3pt, mono("`r sprintf(\"%.2f\", est)`", size: 12pt))
    mono(".", size: 12pt)
  }, after, "fresh")
  content((0.2, 1.6), anchor: "west", box(fill: c-accent2, radius: 4pt, inset: (x: 8pt, y: 5pt), {
    mono("clean_did()", size: 11pt, fill: white)
    h(0.5em)
    lab("edited, then", size: 11pt, fill: white)
    h(0.5em)
    mono("tar_make()", size: 11pt, fill: white)
  }))
  content((25.8, 1.6), anchor: "east", lab([the table in the same PDF now says #after], size: 12pt, fill: c-muted))
})
