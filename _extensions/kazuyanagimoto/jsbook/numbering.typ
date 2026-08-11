// Chapter-scoped numbering for jsbook, with appendix support.
//
// Quarto injects a show rule that resets every float counter at each level-1
// heading, so all we have to do here is prefix the chapter number. Unnumbered
// front matter has a chapter counter of 0; there we fall back to a flat number
// so that captions read "図 1" rather than "図 0.1".

#let js-appendix-state = state("js-appendix", false)

#let js-chapter-index() = counter(heading).get().first()

// `flat` / `nested` are numbering patterns; `nested` receives the chapter first.
#let js-numbering(flat, nested, appendix-nested, ..values) = {
  let chapter = js-chapter-index()
  if chapter == 0 {
    numbering(flat, ..values)
  } else if js-appendix-state.get() {
    numbering(appendix-nested, chapter, ..values)
  } else {
    numbering(nested, chapter, ..values)
  }
}

#let equation-numbering = it => js-numbering("(1)", "(1.1)", "(A.1)", it)

#let callout-numbering = it => js-numbering("1", "1.1", "A.1", it)

#let subfloat-numbering(n-super, subfloat-idx) = {
  js-numbering("1a", "1.1a", "A.1a", n-super, subfloat-idx)
}

// Theorem configuration for theorion: level-1 headings are chapters.
#let theorem-inherited-levels = 1

#let theorem-numbering(loc) = {
  if js-appendix-state.at(loc) { "A.1" } else { "1.1" }
}

// jsbook-flavoured theorem heading: bold label run into the first line.
#let theorem-render(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" and full-title != auto and full-title != none {
    strong[#full-title]
    h(1em)
  }
  body
}
