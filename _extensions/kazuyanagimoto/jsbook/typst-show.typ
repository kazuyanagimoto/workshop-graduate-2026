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
$endif$
$if(seriffont)$
  seriffont: "$seriffont$",
$elseif(mainfont)$
  seriffont: "$mainfont$",
$endif$
$if(seriffont-cjk)$
  seriffont-cjk: "$seriffont-cjk$",
$elseif(CJKmainfont)$
  seriffont-cjk: "$CJKmainfont$",
$endif$
$if(sansfont)$
  sansfont: "$sansfont$",
$endif$
$if(sansfont-cjk)$
  sansfont-cjk: "$sansfont-cjk$",
$elseif(CJKsansfont)$
  sansfont-cjk: "$CJKsansfont$",
$endif$
$if(mathfont)$
  mathfont: ($for(mathfont)$"$mathfont$",$endfor$),
$endif$
$if(codefont)$
  codefont: ($for(codefont)$"$codefont$",$endfor$),
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
