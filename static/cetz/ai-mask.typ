// Step 1 of the clean room: every number in the manuscript is inline code, so
// a script can swap each for an ID and keep the value in the answer key.
// The sentence is an English manuscript. The values in the answer key are the
// replication's Table II, column (3), read from static/aneja-xu/table2.csv, so
// compile from the repository root with `--root .`.
// Shared with the workshop deck (fig-mask in slides/ai-pipeline/typst/cleanroom.typ).
#import "deck-helpers.typ": *
#show: figure-page

// Three decimals, with a typographic minus sign.
#let fmt3(x) = {
  let v = calc.round(float(x), digits: 3)
  let parts = str(calc.abs(v)).split(".")
  let dec = if parts.len() > 1 { parts.at(1) } else { "" }
  let out = parts.at(0) + "." + dec + "0" * (3 - dec.len())
  if v < 0 { "−" + out } else { out }
}
#let col3 = csv("/static/aneja-xu/table2.csv", row-type: dictionary).find(r => r.column == "3")
#let (est, se) = (fmt3(col3.estimate), fmt3(col3.std_error))
#stage(26, 7.5, {
  import cetz.draw: *
  let num(body, fill, tc) = box(fill: fill, radius: 3pt, inset: (x: 5pt, y: 3pt), baseline: 3pt, mono(body, size: 11.5pt, fill: tc))
  let sentence(x0, x1, y, a, b, fill, tc, edge) = {
    rect((x0, y - 0.9), (x1, y + 0.9), radius: 3pt, fill: white, stroke: 1.2pt + edge)
    content((x0 + 0.5, y), anchor: "west", {
      lab("The coefficient on Black × Wilson is ", size: 12pt)
      num(a, fill, tc)
      lab(" (", size: 12pt)
      num(b, fill, tc)
      lab(").", size: 12pt)
    })
  }
  content((3.9, 6.95), anchor: "west", lab("Manuscript (.qmd)", size: 10.5pt, fill: c-muted))
  sentence(3.9, 22.1, 5.65, "`r did$est`", "`r did$se`", c-accent.lighten(78%), c-jet, c-jet)
  for x in (8.3, 21.4) {
    arrow-path((13.0, 4.65), (13.0, 3.95), (x, 3.95), (x, 2.25), w: 1.6pt, head: 1.2)
  }
  // The masked manuscript is the only version the clean room sees.
  dest-heading(0.3, 16.3, 2.6, "Masked manuscript", "to the clean room", c-accent)
  sentence(0.3, 16.3, 1.25, "[R-042]", "[R-043]", c-jet, white, c-accent)
  // The answer key stays behind.
  dest-heading(17.1, 25.7, 2.6, "answer.csv", "stays with you", c-accent2, code: true)
  rect((17.1, 0.35), (25.7, 2.15), radius: 3pt, fill: white, stroke: 1.2pt + c-accent2)
  content((17.6, 1.63), anchor: "west", mono("R-042, " + est + ", did$est", size: 10.5pt))
  content((17.6, 0.87), anchor: "west", mono("R-043, " + se + ", did$se", size: 10.5pt))
})
