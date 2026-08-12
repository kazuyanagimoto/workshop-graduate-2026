// Page geometry is owned entirely by the `js` package (see typst-template.typ),
// which derives the text block from `papersize`, `fontsize`, `baselineskip`,
// `textwidth` and `lines-per-page` the way jsarticle/jsbook does.
//
// Quarto's stock page.typ partial is deliberately replaced by this no-op so that
// its `us-letter` / `1.25in` defaults never fight with the js layout.
$if(logo)$
#set page(background: align($logo.location$, box(inset: $logo.inset$, image("$logo.path$", width: $logo.width$$if(logo.alt)$, alt: "$logo.alt$"$endif$))))
$endif$
