# ============================================================================
# targets pipeline for the workshop's static figures.
#
#   1. CeTZ diagrams   static/cetz/*.typ    -> static/cetz/*.svg
#   2. Beamer decks    static/beamer/*.tex  -> static/beamer/<stem>-<page>.svg
#   3. LaTeX figures   static/tex/*.tex     -> static/tex/<stem>.svg
#   4. Quarto figures  static/quarto/_*.qmd -> static/quarto/<stem>.svg
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

tar_option_set(packages = c("processx", "tinytex", "xfun", "curl"))

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
  # Skip underscore-prefixed files: they are \input fragments (e.g. the
  # regression tables from highlight-tables.R), not standalone decks.
  list.files("static/beamer", pattern = "^[^_].*\\.tex$", full.names = TRUE)
}

# --- LaTeX figures: one .tex -> one .svg ------------------------------------

# Compile a standalone LaTeX figure with TinyTeX (latexmk runs bibtex, so
# natbib + BibTeX citations resolve) and convert page 1 to an SVG. The page is
# sized by the document's own geometry, so no cropping is needed. `refs` only
# registers the .bib dependency, so editing the bibliography rebuilds the SVG.
# The intermediate PDF is discarded; only the SVG is kept (and committed).
compile_tex_to_svg <- function(tex, refs) {
  stem <- tools::file_path_sans_ext(basename(tex))
  outdir <- dirname(tex)

  # biblatex documents need the Biber backend; plain BibTeX otherwise.
  src <- readLines(tex, warn = FALSE)
  bib_engine <- if (any(grepl("biblatex", src))) "biber" else "bibtex"

  xfun::in_dir(outdir, {
    tinytex::latexmk(basename(tex), engine = "pdflatex",
      bib_engine = bib_engine, clean = TRUE)
  })
  pdf_out <- file.path(outdir, paste0(stem, ".pdf"))
  svg_out <- file.path(outdir, paste0(stem, ".svg"))

  processx::run("pdf2svg", c(pdf_out, svg_out, "1"))
  file.remove(pdf_out)
  svg_out
}

tex_paths <- function() {
  list.files("static/tex", pattern = "\\.tex$", full.names = TRUE)
}

# --- Quarto figures: one .qmd -> one .svg -----------------------------------

# Render a standalone Quarto document to PDF (Quarto resolves citations with
# Pandoc citeproc) and convert page 1 to an SVG. Sources are prefixed with `_`
# so the book project ignores them; the SVG is named without the prefix. `refs`
# only registers the .bib dependency. The intermediate PDF is discarded.
compile_qmd_to_svg <- function(qmd, refs) {
  stem <- tools::file_path_sans_ext(basename(qmd))
  outdir <- dirname(qmd)

  # Render the format declared in the .qmd (pdf via LaTeX, or typst); both
  # write a sibling <stem>.pdf.
  xfun::in_dir(outdir, {
    processx::run("quarto", c("render", basename(qmd)))
  })
  pdf_out <- file.path(outdir, paste0(stem, ".pdf"))
  svg_out <- file.path(outdir, paste0(sub("^_", "", stem), ".svg"))

  processx::run("pdf2svg", c(pdf_out, svg_out, "1"))
  file.remove(pdf_out)
  svg_out
}

qmd_paths <- function() {
  list.files("static/quarto", pattern = "\\.qmd$", full.names = TRUE)
}

# --- Data: download the NYC taxi parquet -----------------------------------

# Download one month of NYC TLC Yellow Taxi trip records (Parquet) into data/.
# Used by lesson/computation-data.qmd. The file is gitignored; this target
# fetches it on demand and skips the download if it is already present.
# Source: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
download_taxi <- function(path) {
  if (!file.exists(path)) {
    dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
    url <- paste0(
      "https://d37ci6vzurychx.cloudfront.net/trip-data/",
      "yellow_tripdata_2024-01.parquet"
    )
    curl::curl_download(url, path, mode = "wb")
  }
  path
}

list(
  # --- Data ---
  # NYC taxi parquet, downloaded into data/ (gitignored) on first build.
  tar_target(
    taxi_parquet,
    download_taxi("data/yellow_tripdata_2024-01.parquet"),
    format = "file"
  ),

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
  ),

  # --- LaTeX figures (static/tex) ---
  # Shared bibliography, tracked as a file so edits invalidate the figures.
  tar_target(tex_refs, "static/tex/references.bib", format = "file"),

  # One file-target per LaTeX figure source.
  tar_files_input(tex_src, tex_paths()),

  # Compile each .tex to a single SVG; depends on tex_refs so a bibliography
  # edit rebuilds every figure.
  tar_target(
    tex_svg,
    compile_tex_to_svg(tex_src, tex_refs),
    pattern = map(tex_src),
    format = "file"
  ),

  # --- Quarto figures (static/quarto) ---
  # Shared bibliography, tracked as a file so edits invalidate the figures.
  tar_target(quarto_refs, "static/quarto/references.bib", format = "file"),

  # One file-target per Quarto source.
  tar_files_input(quarto_qmd, qmd_paths()),

  # Render each .qmd to a single SVG; depends on quarto_refs.
  tar_target(
    quarto_svg,
    compile_qmd_to_svg(quarto_qmd, quarto_refs),
    pattern = map(quarto_qmd),
    format = "file"
  )
)
