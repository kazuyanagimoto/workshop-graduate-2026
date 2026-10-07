# Figures quoted from published papers: static/paper/*.pdf -> *.svg.

# The pipeline starts from the cropped PDFs, which are committed; the papers
# themselves stay in the Zotero library and are not part of the pipeline. A
# crop is made once, by hand, with pdftocairo, which drops everything outside
# the box, so the cropped PDF carries the figure alone. The box is in points
# from the top-left corner of the page (render the page at 72 dpi, where one
# pixel is one point, to read it off):
#
#   pdftocairo -pdf -f PAGE -l PAGE -x X -y Y -W WIDTH -H HEIGHT \
#     -paperw WIDTH -paperh HEIGHT -nocenter -noshrink \
#     PAPER.pdf static/paper/CITEKEY-figN.pdf

# Convert the single page of a cropped PDF to a sibling SVG and return its
# path, so the target can track it with format = "file".
convert_pdf_to_svg <- function(pdf) {
  svg <- sub("\\.pdf$", ".svg", pdf)
  processx::run("pdf2svg", c(pdf, svg, "1"))
  svg
}

paper_pdf_paths <- function() {
  list.files("static/paper", pattern = "\\.pdf$", full.names = TRUE)
}

tar_paper <- tar_plan(
  # One file-target per cropped figure.
  tar_files_input(paper_pdf, paper_pdf_paths()),

  # Convert each cropped PDF to an SVG.
  tar_target(
    paper_svg,
    convert_pdf_to_svg(paper_pdf),
    pattern = map(paper_pdf),
    format = "file"
  )
)
