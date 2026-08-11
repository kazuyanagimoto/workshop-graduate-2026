# Standalone Quarto figures: static/quarto/_*.qmd -> static/quarto/*.svg.

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

tar_figure_qmd <- tar_plan(
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
