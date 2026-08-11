# Standalone LaTeX figures: static/tex/*.tex -> static/tex/*.svg.

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
    tinytex::latexmk(
      basename(tex),
      engine = "pdflatex",
      bib_engine = bib_engine,
      clean = TRUE
    )
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

tar_tex <- tar_plan(
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
  )
)
