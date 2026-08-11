# ============================================================================
# targets pipeline for the workshop.
#
# Each stage lives in its own file under R/ and defines a single `tar_<stage>`
# plan; this file only loads them and runs them in order. The stages are:
#
#   tar_data        datasets the chapters read (NYC taxi Parquet, e-Stat)
#   tar_cetz        CeTZ diagrams      static/cetz/*.typ   -> *.svg
#   tar_beamer      Beamer decks       static/beamer/*.tex -> <stem>-<page>.svg
#   tar_tex         LaTeX figures      static/tex/*.tex    -> <stem>.svg
#   tar_figure_qmd  Quarto figures     static/quarto/_*.qmd -> <stem>.svg
#   tar_book        the book itself, rendered with Quarto
#
# Each source is tracked as a file, so only out-of-date outputs rebuild.
#
#   Rscript -e 'targets::tar_make()'        # build out-of-date outputs
#   Rscript -e 'targets::tar_visnetwork()'  # inspect the dependency graph
# ============================================================================
library(targets)
library(tarchetypes)

tar_option_set(packages = c("processx", "tinytex", "xfun", "curl"))

tar_source()

list(
  tar_data,
  tar_cetz,
  tar_beamer,
  tar_tex,
  tar_figure_qmd,
  tar_book
)
