# CeTZ diagrams: static/cetz/*.typ -> static/cetz/*.svg, compiled with Typst.

# Directory of TeX Live's Latin Modern Sans OTFs (== Computer Modern Sans), so
# Typst can reproduce Beamer's default font. NULL if TinyTeX is not on PATH.
lm_font_dir <- function() {
  # system2() errors (not warns) when the binary is missing, so check first:
  # GUI-launched R sessions often lack TinyTeX's bin directory on PATH.
  if (!nzchar(Sys.which("kpsewhich"))) {
    return(NULL)
  }
  f <- suppressWarnings(system2(
    "kpsewhich",
    "lmsans10-regular.otf",
    stdout = TRUE,
    stderr = FALSE
  ))
  if (length(f) && nzchar(f[1]) && file.exists(f[1])) dirname(f[1]) else NULL
}

# Compile one .typ to a sibling .svg and return the SVG path (so the target can
# track it with format = "file"). `helpers` and `inputs` are passed only to
# register the dependencies; their values are paths. The Latin Modern font path
# lets figures that ask for "Latin Modern Sans" resolve it (harmless for the
# rest). The root is the project, so a figure can read a file elsewhere in the
# repository by its absolute path, e.g. "/static/aneja-xu/table2.csv".
compile_typ_to_svg <- function(typ, helpers, inputs) {
  svg <- sub("\\.typ$", ".svg", typ)
  fdir <- lm_font_dir()
  font_args <- if (!is.null(fdir)) c("--font-path", fdir) else character(0)
  processx::run(
    "quarto",
    c("typst", "compile", "--root", ".", font_args, typ, svg)
  )
  svg
}

# Modules the diagrams import. They are not standalone documents.
cetz_helper_paths <- file.path(
  "static",
  "cetz",
  c("helpers.typ", "deck-helpers.typ")
)

# Diagram sources: every .typ under static/cetz except the helper modules.
cetz_typ_paths <- function() {
  files <- list.files("static/cetz", pattern = "\\.typ$", full.names = TRUE)
  setdiff(files, cetz_helper_paths)
}

# Other files the diagrams read: the logos, and the measured results that
# ai-mask.typ and targets-inline.typ print.
cetz_input_paths <- function() {
  c(
    list.files("static/cetz/logos", full.names = TRUE),
    "static/aneja-xu/table2.csv",
    "slides/ai-pipeline/data/quarto-example.csv"
  )
}

tar_cetz <- tar_plan(
  # Shared helper modules and inputs, tracked as files so that an edit
  # invalidates every SVG.
  tar_target(cetz_helpers, cetz_helper_paths, format = "file"),
  tar_target(cetz_inputs, cetz_input_paths(), format = "file"),

  # One file-target per diagram source; reacts to additions/removals on rerun.
  tar_files_input(cetz_typ, cetz_typ_paths()),

  # Compile each source to SVG. Branches over cetz_typ (one per file) and also
  # depends on the helpers and inputs, so an edit to either rebuilds all
  # diagrams.
  tar_target(
    cetz_svg,
    compile_typ_to_svg(cetz_typ, cetz_helpers, cetz_inputs),
    pattern = map(cetz_typ),
    format = "file"
  )
)
