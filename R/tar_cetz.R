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

tar_cetz <- tar_plan(
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
  )
)
