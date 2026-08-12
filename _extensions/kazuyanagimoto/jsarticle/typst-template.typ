// jsarticle for Quarto/Typst
//
// The heavy lifting (baseline grid, text block, heading spacing, CJK font
// covers) comes from Haruhiko Okumura's `js` package, which is a Typst port of
// the LaTeX jsarticle/jsbook classes. This partial only
//   1. adapts Quarto's metadata to the `js` function's arguments,
//   2. re-implements the title block so that Quarto's subtitle / abstract-title
//      / thanks metadata is honoured, and
//   3. undoes the few `js` defaults that conflict with Quarto's Lua filters
//      (notably `set ref(supplement: none)`, which would strip the "図"/"表"
//      prefix from every crossref).
#import "@preview/js:0.1.3": *

// ---------------------------------------------------------------- utilities

// Flatten content to a plain string. Quarto's `content-to-string` returns
// `none` for empty content, which makes `.trim()` fail, so use our own.
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

// Table rules. Typst draws a full grid by default (`1pt + black`) and `js`
// only thins it to jsarticle's `\arrayrulewidth` (0.4pt at 10pt) — the grid
// itself is Typst's default, not something jsarticle prescribes, so the
// booktabs look of most Japanese papers is available as well.
#let TABLE-STYLES = ("booktabs", "grid", "plain")

// Only tables that took the `stroke: none` above get the rules; anything with
// an explicit stroke (js's own `boxtable`, or a hand-written table) is left
// alone. Quarto emits the header rule itself as `table.hline()`.
#let _booktabs(it, style) = {
  if style == "booktabs" and it.stroke == none {
    block(stroke: (top: 0.08em, bottom: 0.08em), inset: 0pt, breakable: true, it)
  } else {
    it
  }
}

// Quarto's `simple` theorem appearance (the default) wraps the whole statement
// in `emph()`, following the latin convention of setting theorems in italics.
// `js` renders emphasis in gothic, because Japanese emphasises with a change of
// typeface rather than a slant, so the two together set the whole statement in
// gothic. theorion — which Quarto's theorems are built on — emits every
// environment as a `figure` whose `kind` is the environment name, which is
// narrow enough to put the body font back there. These are the environments of
// Quarto's `theorem_types`; the proof-like ones (proof, remark, solution) are
// not theorion frames and only ever emphasise their label.
#let _js-statement(body-font) = it => {
  show emph: set text(font: body-font)
  it
}

// Quarto hands us (name, affiliation, email) dictionaries; `js` wants either a
// bare name or an array of lines that `boxtable` stacks under each other.
#let _js-author(author) = {
  let lines = ("name", "affiliation", "email")
    .map(k => author.at(k, default: none))
    .filter(v => not _blank(v))
  if lines.len() == 0 { none } else if lines.len() == 1 { lines.first() } else { lines }
}

#let _color(value) = if value == none { none } else { rgb(_to-str(value)) }

// ------------------------------------------------------------- title block

#let js-title-block(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  abstract: none,
  abstract-title: none,
  thanks: none,
  heading-font: none,
  heading-weight: none,
  heading-style: none,
  heading-color: none,
) = {
  let has-any = (
    title != none or subtitle != none or authors.len() > 0 or date != none or abstract != none
  )
  if not has-any { return }

  // Title and subtitle follow the heading typography (brand.yml `headings`)
  // when one is given; otherwise they stay in the body font, as jsarticle
  // does. Applied as arguments rather than set rules so that the title block
  // keeps its exact shape when no brand typography is in play.
  let style = (:)
  if heading-font != none { style.insert("font", heading-font) }
  if heading-weight != none { style.insert("weight", heading-weight) }
  if heading-style != none { style.insert("style", heading-style) }
  if heading-color != none { style.insert("fill", heading-color) }

  place(top + center, scope: "parent", float: true, clearance: 2em)[
    #set align(center)
    #set par(first-line-indent: 0em, justify: false)
    #v(2em)
    #if title != none {
      text(1.7em, ..style)[#title#if thanks != none {
        footnote(thanks, numbering: "*")
        counter(footnote).update(n => n - 1)
      }]
    }
    #if subtitle != none {
      linebreak()
      v(0.4em)
      text(1.25em, ..style, subtitle)
    }
    #if authors.len() > 0 {
      v(1.5em)
      pad(x: 2em, authors.map(boxtable).join("      "))
    }
    #if date != none {
      v(1em)
      date
    }
    #if abstract != none {
      v(1.5em)
      block(width: 90%)[
        #set text(0.9em)
        #if abstract-title != none { emph(abstract-title) }
        #align(left, abstract)
      ]
    }
    #v(1.5em)
  ]
}

// ------------------------------------------------------------------ article

#let article(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  abstract: none,
  abstract-title: none,
  keywords: (),
  thanks: none,
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
  table-style: "booktabs",
  baselineskip: auto,
  textwidth: auto,
  lines-per-page: auto,
  cols: 1,
  book: false,
  cjkheight: 0.88,
  non-cjk: auto,
  sectionnumbering: none,
  page-numbering: "1",
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: auto,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  doc,
) = {
  let js-authors = authors.map(_js-author).filter(a => a != none)

  assert(
    table-style in TABLE-STYLES,
    message: "table-style must be one of " + TABLE-STYLES.join(", "),
  )

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
    book: book,
    cols: cols,
    cjkheight: cjkheight,
  )
  if non-cjk != auto {
    js-args.insert("non-cjk", non-cjk)
  }

  js(
    ..js-args,
    {
      // --- Quarto compatibility fixes, applied after `js`'s own rules -------
      set text(region: region)
      set page(numbering: page-numbering)
      set heading(numbering: sectionnumbering)
      // `js` sets `supplement: none`; Quarto needs the 図/表/式 prefixes back.
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

      // Theorem statements: keep the CJK body font, leave the latin italics
      // alone. One rule per environment rather than a blanket `show figure`,
      // so that Quarto's own floats are not touched.
      let statement = _js-statement(serif-list)
      show figure.where(kind: "theorem"): statement
      show figure.where(kind: "lemma"): statement
      show figure.where(kind: "corollary"): statement
      show figure.where(kind: "proposition"): statement
      show figure.where(kind: "conjecture"): statement
      show figure.where(kind: "definition"): statement
      show figure.where(kind: "example"): statement
      show figure.where(kind: "exercise"): statement
      show figure.where(kind: "algorithm"): statement

      // Tables: `grid` keeps `js`'s thin full grid, the other two drop it and
      // rely on the header rule Quarto emits. The column inset matches
      // jsarticle's `\tabcolsep` (6pt).
      set table(inset: (x: 6pt, y: 4pt), stroke: none) if table-style == "booktabs"
      set table.hline(stroke: 0.05em) if table-style == "booktabs"
      set table(inset: 6pt, stroke: none) if table-style == "plain"
      show table: it => _booktabs(it, table-style)

      show link: set text(fill: _color(linkcolor)) if linkcolor != none
      show ref: set text(fill: _color(citecolor)) if citecolor != none
      show link: it => {
        if filecolor != none and type(it.dest) == label {
          text(it, fill: _color(filecolor))
        } else {
          text(it)
        }
      }

      js-title-block(
        title: title,
        subtitle: subtitle,
        authors: js-authors,
        date: date,
        abstract: abstract,
        abstract-title: abstract-title,
        thanks: thanks,
        heading-font: if heading-family == none { none } else { heading-list },
        heading-weight: heading-weight,
        heading-style: heading-style,
        heading-color: heading-color,
      )

      if toc {
        outline(
          title: if toc_title == none { auto } else { toc_title },
          depth: toc_depth,
          indent: toc_indent,
        )
        v(1em)
      }

      doc
    },
  )
}
