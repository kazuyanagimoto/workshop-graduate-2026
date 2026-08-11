# Empiricist's Workflow — 実証研究のためのモダンなツールと作法

Course materials for a graduate workshop at Kobe University, built as a [Quarto](https://quarto.org/) book.

Rendered site: <https://kazuyanagimoto.com/workshop-graduate-2026>

## Reproducing the book

### Requirements

- [R](https://cran.r-project.org/) 4.6, ideally installed through [rig](https://github.com/r-lib/rig) (`rig add release`)
- [rv](https://github.com/A2-ai/rv), which installs the R packages pinned in `rv.lock`
- [Quarto](https://quarto.org/) (the version the site was last built with is recorded in `_variables.yml`)

The PDF edition is typeset by Typst, which ships with Quarto, so no TeX distribution is needed to build the book. The monospace face is declared in `_brand.yml` and Quarto fetches it from Google Fonts while rendering, so nothing has to be installed for it. The Japanese faces are different: Google Fonts serves CJK families as unicode-range subsets and Quarto downloads only one of them, which carries the kana but almost no kanji, so [Harano Aji](https://github.com/trueroad/HaranoAjiFonts) has to be present as a system font (`brew install --cask font-harano-aji`; the CI workflow pulls the tarball, since it is not packaged for Ubuntu). Run `quarto typst fonts` (which prints to stderr) to check that Typst can see it.

Rebuilding the figures with `targets` is the one part that still needs a TeX distribution, because the slides and citation chapters illustrate Beamer and BibTeX with genuinely LaTeX-compiled examples:

- [TinyTeX](https://yihui.org/tinytex/) or another TeX Live
- `pdf2svg` (`brew install pdf2svg` / `apt install pdf2svg`), which turns those compiled PDFs into the SVGs the book embeds

### Rendering

The `_freeze/` directory and every generated figure are committed, so rebuilding the book needs neither the R packages nor a working figure pipeline:

```sh
quarto render
```

### Re-running the code

To install the pinned package versions into the project library and rebuild the figures and data from source:

```sh
rv sync
Rscript -e 'targets::tar_make()'
```

The `targets` pipeline compiles the CeTZ, Beamer, LaTeX and Quarto figure sources under `static/`, downloads the NYC taxi Parquet file used in the large-data chapter, and fetches the Employment Status Survey from e-Stat. That last target needs an e-Stat application id in a project-local `.Renviron` (which is gitignored); see the API chapter for how to obtain one:

```sh
ESTAT_APP_ID=your_key_here
```

Finally, to execute the chapter code again instead of reusing the frozen output:

```sh
quarto render --execute
```

## Licenses

All prose and images are licensed under [Creative Commons Attribution-NonCommercial 4.0 (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

All code is licensed under the [MIT License](LICENSE.md).
