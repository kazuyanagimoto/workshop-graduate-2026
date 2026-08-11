# Beamer decks: static/beamer/*.tex -> one SVG per slide.
#
# These are raw .tex compiled by TinyTeX (NOT through Quarto), so the output is
# the genuine default Beamer look, navigation symbols and all.

# Compile a raw Beamer .tex with TinyTeX, then split every page into an SVG.
# Returns the PDF path plus all per-page SVG paths so the target tracks them as
# files. Compilation runs inside the source's directory so the PDF and the SVGs
# land next to the .tex; TinyTeX cleans up the auxiliary files itself.
compile_beamer_to_svg <- function(tex) {
  stem <- tools::file_path_sans_ext(basename(tex))
  outdir <- dirname(tex)

  xfun::in_dir(outdir, {
    tinytex::latexmk(basename(tex), engine = "pdflatex", clean = TRUE)
  })
  pdf_out <- file.path(outdir, paste0(stem, ".pdf"))

  # (Re)generate one SVG per page, clearing any stale pages first.
  svg_glob <- paste0("^", stem, "-\\d+\\.svg$")
  file.remove(list.files(outdir, pattern = svg_glob, full.names = TRUE))
  processx::run(
    "pdf2svg",
    c(pdf_out, file.path(outdir, paste0(stem, "-%d.svg")), "all")
  )

  svgs <- list.files(outdir, pattern = svg_glob, full.names = TRUE)
  # Order by page number rather than lexicographically (so 2 < 10).
  svgs <- svgs[order(as.integer(sub(".*-(\\d+)\\.svg$", "\\1", svgs)))]
  c(pdf_out, svgs)
}

beamer_tex_paths <- function() {
  # Skip underscore-prefixed files: they are \input fragments (e.g. the
  # regression tables from highlight-tables.R), not standalone decks.
  list.files("static/beamer", pattern = "^[^_].*\\.tex$", full.names = TRUE)
}

tar_beamer <- tar_plan(
  # One file-target per Beamer source.
  tar_files_input(beamer_tex, beamer_tex_paths()),

  # Compile each deck with TinyTeX and split it into per-slide SVGs (plus PDF).
  tar_target(
    beamer_svg,
    compile_beamer_to_svg(beamer_tex),
    pattern = map(beamer_tex),
    format = "file"
  )
)
