#show: doc => book(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
      email: [$it.email$] ),
$endif$
$endfor$
  ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(abstract)$
  abstract: [$abstract$],
  abstract-title: [$labels.abstract$],
$endif$
$if(keywords)$
  keywords: ($for(keywords)$"$keywords$",$endfor$),
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$elseif(brand.typography.base.size)$
  fontsize: $brand.typography.base.size$,
$endif$
$if(mainfont)$
  seriffont: ("$mainfont$",),
$elseif(seriffont)$
  seriffont: "$seriffont$",
$elseif(brand.typography.base.family)$
  seriffont: $brand.typography.base.family$,
$endif$
$if(CJKmainfont)$
  seriffont-cjk: "$CJKmainfont$",
$elseif(seriffont-cjk)$
  seriffont-cjk: "$seriffont-cjk$",
$endif$
$if(sansfont)$
  sansfont: "$sansfont$",
$endif$
$if(CJKsansfont)$
  sansfont-cjk: "$CJKsansfont$",
$elseif(sansfont-cjk)$
  sansfont-cjk: "$sansfont-cjk$",
$endif$
$if(mathfont)$
  mathfont: ($for(mathfont)$"$mathfont$",$endfor$),
$endif$
$if(codefont)$
  codefont: ($for(codefont)$"$codefont$",$endfor$),
$elseif(monofont)$
  codefont: ("$monofont$",),
$elseif(brand.typography.monospace.family)$
  codefont: $brand.typography.monospace.family$,
$endif$
$if(brand.typography.headings.family)$
  heading-family: $brand.typography.headings.family$,
$endif$
$if(brand.typography.headings.weight)$
  heading-weight: $brand.typography.headings.weight$,
$endif$
$if(brand.typography.headings.style)$
  heading-style: "$brand.typography.headings.style$",
$endif$
$if(brand.typography.headings.color)$
  heading-color: $brand.typography.headings.color$,
$endif$
$if(baselineskip)$
  baselineskip: $baselineskip$,
$endif$
$if(textwidth)$
  textwidth: $textwidth$,
$endif$
$if(lines-per-page)$
  lines-per-page: $lines-per-page$,
$endif$
$if(columns)$
  cols: $columns$,
$endif$
$if(cjkheight)$
  cjkheight: $cjkheight$,
$endif$
$if(non-cjk)$
  non-cjk: $non-cjk$,
$endif$
$if(chapter-prefix)$
  chapter-prefix: "$chapter-prefix$",
$endif$
$if(chapter-suffix)$
  chapter-suffix: "$chapter-suffix$",
$endif$
$if(appendix-prefix)$
  appendix-prefix: "$appendix-prefix$",
$endif$
$if(appendix-suffix)$
  appendix-suffix: "$appendix-suffix$",
$endif$
$if(part-prefix)$
  part-prefix: "$part-prefix$",
$endif$
$if(part-suffix)$
  part-suffix: "$part-suffix$",
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc_title: [$toc-title$],
$endif$
$if(toc-depth)$
  toc_depth: $toc-depth$,
$endif$
$if(toc-indent)$
  toc_indent: $toc-indent$,
$endif$
$if(linkcolor)$
  linkcolor: [$linkcolor$],
$endif$
$if(citecolor)$
  citecolor: [$citecolor$],
$endif$
$if(filecolor)$
  filecolor: [$filecolor$],
$endif$
  doc,
)
