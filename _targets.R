# ============================================================================
# targets pipeline for the workshop's static figures.
#
#   1. CeTZ diagrams   static/cetz/*.typ    -> static/cetz/*.svg
#   2. Beamer decks    static/beamer/*.tex  -> static/beamer/<stem>-<page>.svg
#
# The Beamer sources are raw .tex compiled by TinyTeX (NOT through Quarto), so
# the output is the genuine default Beamer look, navigation symbols and all.
#
# Each source is tracked as a file, so only out-of-date outputs rebuild.
#
#   Rscript -e 'targets::tar_make()'        # build out-of-date outputs
#   Rscript -e 'targets::tar_visnetwork()'  # inspect the dependency graph
# ============================================================================
library(targets)
library(tarchetypes)

tar_option_set(packages = c("processx", "tinytex", "xfun"))

# --- CeTZ: one .typ -> one .svg --------------------------------------------

# Directory of TeX Live's Latin Modern Sans OTFs (== Computer Modern Sans), so
# Typst can reproduce Beamer's default font. NULL if TinyTeX is not on PATH.
lm_font_dir <- function() {
  f <- suppressWarnings(system2("kpsewhich", "lmsans10-regular.otf",
    stdout = TRUE, stderr = FALSE))
  if (length(f) && nzchar(f[1]) && file.exists(f[1])) dirname(f[1]) else NULL
}

# Compile one .typ to a sibling .svg and return the SVG path (so the target can
# track it with format = "file"). `helpers` is passed only to register the
# dependency; its value is the helpers path. The Latin Modern font path lets
# figures that ask for "Latin Modern Sans" resolve it (harmless for the rest).
compile_typ_to_svg <- function(typ, helpers) {
  svg <- sub("\\.typ$", ".svg", typ)
  fdir <- lm_font_dir()
  font_args <- if (!is.null(fdir)) c("--font-path", fdir) else character(0)
  processx::run("quarto", c("typst", "compile", font_args, typ, svg))
  svg
}

# Diagram sources: every .typ under static/cetz except the shared helpers
# module, which is not a standalone document.
cetz_typ_paths <- function() {
  files <- list.files("static/cetz", pattern = "\\.typ$", full.names = TRUE)
  setdiff(files, file.path("static", "cetz", "helpers.typ"))
}

# --- Beamer: one .tex -> a PDF and one SVG per slide ------------------------

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
  processx::run("pdf2svg", c(pdf_out, file.path(outdir, paste0(stem, "-%d.svg")), "all"))

  svgs <- list.files(outdir, pattern = svg_glob, full.names = TRUE)
  # Order by page number rather than lexicographically (so 2 < 10).
  svgs <- svgs[order(as.integer(sub(".*-(\\d+)\\.svg$", "\\1", svgs)))]
  c(pdf_out, svgs)
}

beamer_tex_paths <- function() {
  list.files("static/beamer", pattern = "\\.tex$", full.names = TRUE)
}

list(
  # --- CeTZ ---
  # Shared helpers module, tracked as a file so edits invalidate every SVG.
  tar_target(cetz_helpers, "static/cetz/helpers.typ", format = "file"),

  # One file-target per diagram source; reacts to additions/removals on rerun.
  tar_files_input(cetz_typ, cetz_typ_paths()),

  # Compile each source to SVG. Branches over cetz_typ (one per file) and also
  # depends on cetz_helpers, so a helper edit rebuilds all diagrams.
  tar_target(
    cetz_svg,
    compile_typ_to_svg(cetz_typ, cetz_helpers),
    pattern = map(cetz_typ),
    format = "file"
  ),

  # --- Beamer ---
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
