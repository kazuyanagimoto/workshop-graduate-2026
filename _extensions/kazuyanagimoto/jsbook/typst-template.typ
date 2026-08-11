// jsbook for Quarto/Typst
//
// The grid (baseline, text block, CJK font covers, level-2+ headings) comes
// from Haruhiko Okumura's `js` package running in `book: true` mode. On top of
// that this partial adds the pieces a Quarto book needs and `js` does not
// provide: a title page, front/main matter page numbering, part pages,
// appendix numbering, and running heads that know about appendices.
#import "@preview/js:0.1.3": *

// ---------------------------------------------------------------- utilities

#let _to-str(it) = {
  if it == none {
    ""
  } else if type(it) == str {
    it
  } else if type(it) == content {
    if it.has("text") {
      _to-str(it.text)
    } else if it.has("children") {
      it.children.map(_to-str).fold("", (a, b) => a + b)
    } else if it.has("body") {
      _to-str(it.body)
    } else {
      ""
    }
  } else {
    str(it)
  }
}

#let _blank(it) = _to-str(it).trim() == ""

// Font families arrive either as a single name (`mainfont: Foo`) or as a Typst
// array (`_brand.yml` typography, which Quarto hands over as a font list).
#let _families(spec) = {
  if spec == none { () } else if type(spec) == array { spec } else { (spec,) }
}

#let _first-family(spec) = _families(spec).at(0, default: none)

// `js` tags the latin family with `covers` so that CJK glyphs fall through to
// the CJK family. Same idea, but for a whole fallback chain.
#let _font-list(latin, cjk, covers) = {
  _families(latin).map(name => (name: name, covers: covers)) + _families(cjk)
}

// `js`'s own default for `non-cjk`, needed here because the font lists above
// are built outside of `js`.
#let JS-NON-CJK = regex("[\u{0000}-\u{2023}]")

#let _js-author(author) = {
  let lines = ("name", "affiliation", "email")
    .map(k => author.at(k, default: none))
    .filter(v => not _blank(v))
  if lines.len() == 0 { none } else if lines.len() == 1 { lines.first() } else { lines }
}

#let _color(value) = if value == none { none } else { rgb(_to-str(value)) }

// -------------------------------------------------------- parts and matters

// Part headings are ordinary level-1 headings tagged with a sentinel
// supplement, which is how the heading show rule tells them from chapters.
#let JS-PART-SUPPLEMENT = [jsbook-part]
#let js-part-counter = counter("js-part")

#let part(body) = [
  #js-part-counter.step()
  #heading(level: 1, numbering: none, supplement: JS-PART-SUPPLEMENT, outlined: true)[#body]
]

#let js-frontmatter = $if(frontmatter)$true$else$false$endif$

// Emitted by jsbook.lua as `#show: jsbook-mainmatter` in front of the first
// numbered chapter — the equivalent of LaTeX's \mainmatter.
#let jsbook-mainmatter(doc) = {
  pagebreak(weak: true, to: "odd")
  if js-frontmatter {
    counter(page).update(1)
    set page(numbering: "1")
    doc
  } else {
    doc
  }
}

// Emitted by jsbook.lua as `#show: jsbook-appendix` — LaTeX's \appendix.
#let jsbook-appendix(doc) = {
  js-appendix-state.update(true)
  counter(heading).update(0)
  set heading(numbering: "A.1.1")
  doc
}

// ------------------------------------------------------------------- jsbook

#let book(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  abstract: none,
  abstract-title: none,
  keywords: (),
  lang: "ja",
  region: "JP",
  paper: "a4",
  fontsize: 10pt,
  seriffont: "New Computer Modern",
  seriffont-cjk: "Harano Aji Mincho",
  sansfont: "Source Sans Pro",
  sansfont-cjk: "Harano Aji Gothic",
  mathfont: none,
  codefont: none,
  heading-family: none,
  heading-weight: none,
  heading-style: none,
  heading-color: none,
  baselineskip: auto,
  textwidth: auto,
  lines-per-page: auto,
  cols: 1,
  cjkheight: 0.88,
  non-cjk: auto,
  chapter-prefix: "第",
  chapter-suffix: "章",
  appendix-prefix: "付録",
  appendix-suffix: "",
  part-prefix: "第",
  part-suffix: "部",
  sectionnumbering: "1.1.1",
  toc: true,
  toc_title: none,
  toc_depth: none,
  toc_indent: auto,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  doc,
) = {
  let js-authors = authors.map(_js-author).filter(a => a != none)
  let skip = if baselineskip == auto { 1.73 * fontsize } else { baselineskip }

  set document(
    title: _to-str(title),
    keywords: keywords,
  )
  set document(
    author: js-authors.map(array2text).map(_to-str),
  ) if js-authors.len() > 0

  // `js` takes one family per role and builds the covers-tagged font list
  // itself, so it only ever sees the first family; the full fallback chains
  // are re-applied inside its body below.
  let covers = if non-cjk == auto { JS-NON-CJK } else { non-cjk }
  let serif-list = _font-list(seriffont, seriffont-cjk, covers)
  let sans-list = _font-list(sansfont, sansfont-cjk, covers)
  let emph-list = _font-list(seriffont, sansfont-cjk, covers)
  let heading-list = if heading-family == none {
    sans-list
  } else {
    _font-list(heading-family, sansfont-cjk, covers)
  }

  // The title page follows the heading typography (brand.yml `headings`) when
  // one is given; otherwise it stays in the body font, as jsbook does.
  let title-style = (:)
  if heading-family != none { title-style.insert("font", heading-list) }
  if heading-weight != none { title-style.insert("weight", heading-weight) }
  if heading-style != none { title-style.insert("style", heading-style) }
  if heading-color != none { title-style.insert("fill", heading-color) }

  let js-args = (
    lang: lang,
    seriffont: _first-family(seriffont),
    seriffont-cjk: _first-family(seriffont-cjk),
    sansfont: _first-family(sansfont),
    sansfont-cjk: _first-family(sansfont-cjk),
    paper: paper,
    fontsize: fontsize,
    baselineskip: baselineskip,
    textwidth: textwidth,
    lines-per-page: lines-per-page,
    book: true,
    cols: cols,
    cjkheight: cjkheight,
  )
  if non-cjk != auto {
    js-args.insert("non-cjk", non-cjk)
  }

  // "第1章" / "付録A", used by both the chapter opener and the running head.
  let chapter-label(n, appendix) = {
    if appendix {
      appendix-prefix + numbering("A", n) + appendix-suffix
    } else {
      chapter-prefix + numbering("1", n) + chapter-suffix
    }
  }
  let part-label(n) = part-prefix + numbering("I", n) + part-suffix

  js(
    ..js-args,
    {
      set text(region: region)
      set heading(numbering: sectionnumbering)
      // `js` sets `supplement: none`; Quarto needs the 図/表 prefixes back.
      set ref(supplement: auto)

      // Full font fallback chains (`js` only saw the first family of each).
      set text(font: serif-list)
      show strong: set text(font: sans-list)
      show emph: set text(font: emph-list)
      show heading: set text(font: heading-list)
      show heading: set text(weight: heading-weight) if heading-weight != none
      show heading: set text(style: heading-style) if heading-style != none
      show heading: set text(fill: heading-color) if heading-color != none

      show math.equation: set text(font: mathfont) if mathfont != none
      show raw: set text(font: codefont) if codefont != none

      show link: set text(fill: _color(linkcolor)) if linkcolor != none
      show ref: set text(fill: _color(citecolor)) if citecolor != none
      show link: it => {
        if filecolor != none and type(it.dest) == label {
          text(it, fill: _color(filecolor))
        } else {
          text(it)
        }
      }

      // Chapter-scoped float numbers (図 1.1). Front matter has no chapter
      // number, so fall back to a flat counter there.
      set figure(
        numbering: num => {
          let ch = counter(heading).get().first()
          if ch == 0 {
            numbering("1", num)
          } else if js-appendix-state.get() {
            numbering("A.1", ch, num)
          } else {
            numbering("1.1", ch, num)
          }
        },
      )

      // --- running heads ------------------------------------------------
      // Same shape as `js`: verso carries the chapter, recto the section,
      // and pages that open a chapter or a part carry nothing. Unlike `js`
      // this one knows that appendix chapters are "付録A", not "第1章".
      set page(header: context {
        let p = here().page()
        let h1 = heading.where(level: 1)
        let h1p = query(h1).map(it => it.location().page())
        let previous-h1 = query(h1.before(here())).at(-1, default: none)
        // A part page and the blank verso that follows it carry no head.
        let after-part = (
          previous-h1 != none and previous-h1.supplement == JS-PART-SUPPLEMENT
        )
        if p > 1 and not p in h1p and not after-part {
          let n = if page.numbering == none { "" } else { counter(page).display() }
          if calc.odd(p) {
            let h2 = heading.where(level: 2)
            let h2last = query(h2.before(here())).at(-1, default: none)
            let h2next = query(h2.after(here())).at(0, default: none)
            if h2next != none and h2next.location().page() == p { h2last = h2next }
            if h2last != none {
              let c = counter(heading).at(h2last.location())
              stack(
                spacing: 0.2em,
                if h2last.numbering == none {
                  [ #h2last.body #h(1fr) #n ]
                } else {
                  [
                    #numbering(
                      if js-appendix-state.at(h2last.location()) { "A.1" } else { "1.1" },
                      ..c.slice(0, 2),
                    )#h(1em)#h2last.body #h(1fr) #n
                  ]
                },
                // Follow the text colour so that a brand.yml foreground /
                // background pair does not leave a black rule behind.
                line(stroke: (thickness: 0.4pt, paint: text.fill), length: 100%),
              )
            }
          } else {
            let h1last = query(h1.before(here())).at(-1, default: none)
            let h1next = query(h1.after(here())).at(0, default: none)
            if h1next != none and h1next.location().page() == p { h1last = h1next }
            if h1last != none {
              let c = counter(heading).at(h1last.location())
              stack(
                spacing: 0.2em,
                if h1last.numbering == none {
                  [ #n #h(1fr) #h1last.body ]
                } else {
                  [
                    #n #h(1fr) #chapter-label(
                      c.first(),
                      js-appendix-state.at(h1last.location()),
                    )#h(1em)#h1last.body
                  ]
                },
                // Follow the text colour so that a brand.yml foreground /
                // background pair does not leave a black rule behind.
                line(stroke: (thickness: 0.4pt, paint: text.fill), length: 100%),
              )
            }
          }
        }
      })

      // --- chapter openers and part pages --------------------------------
      show heading.where(level: 1): it => {
        if it.supplement == JS-PART-SUPPLEMENT {
          // The `fr` spacing has to sit directly in the page flow, not inside a
          // block, for the part title to centre on the page.
          pagebreak(weak: true, to: "odd")
          set par(first-line-indent: 0em, justify: false)
          v(1fr)
          align(center, context text(2 * fontsize, part-label(js-part-counter.get().first())))
          v(2 * skip)
          align(center, text(2.5 * fontsize, it.body))
          v(2fr)
          pagebreak(weak: true)
        } else {
          pagebreak(weak: true, to: "odd")
          block[
            #set par(first-line-indent: 0em, spacing: 3 * fontsize, leading: 3 * fontsize)
            #v(2 * skip)
            #if it.numbering != none {
              context text(
                2 * fontsize,
                chapter-label(counter(heading).get().first(), js-appendix-state.get()),
              )
              linebreak()
            }
            #text(2.5 * fontsize, it.body)
            #v(2 * skip)
          ]
        }
      }

      // --- title page -----------------------------------------------------
      page(numbering: none, header: none, footer: none)[
        #set align(center)
        #set par(first-line-indent: 0em, justify: false)
        #v(1fr)
        #if title != none { text(2.4 * fontsize, ..title-style, title) }
        #if subtitle != none {
          v(1.2em)
          text(1.5 * fontsize, ..title-style, subtitle)
        }
        #v(2fr)
        #if js-authors.len() > 0 {
          text(1.3 * fontsize, js-authors.map(boxtable).join("      "))
        }
        #if date != none {
          v(1.5em)
          date
        }
        #v(2fr)
      ]

      // Front matter is numbered in lower-case roman; jsbook-mainmatter later
      // restarts the counter in arabic. The `set` has to live in this scope,
      // not inside the `if`, or it would only cover the `if` branch.
      if js-frontmatter { counter(page).update(1) }
      set page(numbering: "i") if js-frontmatter

      if abstract != none {
        block(width: 100%)[
          #if abstract-title != none {
            align(center, text(1.2 * fontsize, abstract-title))
            v(1em)
          }
          #abstract
        ]
        pagebreak(weak: true)
      }

      if toc {
        show outline.entry: it => {
          if it.element.func() == heading and it.element.supplement == JS-PART-SUPPLEMENT {
            v(skip / 2, weak: true)
            strong(
              link(
                it.element.location(),
                part-label(js-part-counter.at(it.element.location()).first())
                  + h(1em)
                  + it.element.body,
              ),
            )
          } else {
            it
          }
        }
        outline(
          title: if toc_title == none { auto } else { toc_title },
          depth: toc_depth,
          indent: toc_indent,
        )
      }

      doc
    },
  )
}
