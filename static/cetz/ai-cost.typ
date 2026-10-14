// Writing got cheap with AI; checking did not. Block lengths carry no data.
// Shared with the workshop deck (anim-cost in slides/ai-pipeline/typst/intro.typ).
#import "deck-helpers.typ": *
#show: figure-page

#stage(26, 7.0, {
  import cetz.draw: *
  let x-start = 4.6
  let w-check = 7.8
  let row(y, name, w-write, strong) = {
    content((0.2, y), anchor: "west", lab(name, size: 14pt, weight: "medium"))
    rect((x-start, y - 0.85), (x-start + w-write, y + 0.85), radius: 5pt, fill: c-accent.lighten(55%), stroke: none)
    content((x-start + w-write / 2, y), lab(if w-write > 4 { "Write the code" } else { "Write" }, size: 14pt))
    let x0 = x-start + w-write + 0.25
    rect((x0, y - 0.85), (x0 + w-check, y + 0.85), radius: 5pt, fill: if strong { c-accent2 } else { c-accent2.lighten(60%) }, stroke: none)
    content((x0 + w-check / 2, y), lab("Check the result", size: 14pt, fill: if strong { white } else { c-jet }))
  }
  row(6.0, "Before AI", 12.4, false)
  row(3.4, "With AI", 2.6, true)
  let x0 = x-start + 2.6 + 0.25
  line((x0, 2.3), (x0, 2.0), (x0 + w-check, 2.0), (x0 + w-check, 2.3), stroke: 1.4pt + c-accent2)
  let qs = (
    "Is the specification what you meant?",
    "Is the sample restricted correctly?",
    "Do the numbers come from the current code?",
  )
  for (i, q) in qs.enumerate() {
    content((x0 + 0.2, 1.3 - i * 0.75), anchor: "west", lab(q, size: 12pt))
  }
  content((x0 + w-check + 0.5, 3.4), anchor: "west", lab("Checking is\nthe researcher's job", size: 13pt, fill: c-accent2, weight: "medium"))
})
