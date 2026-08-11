# The book itself, rendered from the figures and data the stages above produce.

# The generated figures the chapters embed. tar_quarto() works out the Quarto
# project's own inputs by itself (the .qmd sources, _quarto.yml, the files
# listed under `resources`), but the figures are embedded as plain markdown
# images, so it cannot see them; without this, a rebuilt diagram would leave
# the rendered book untouched.
book_figures <- function() {
  dirs <- file.path("static", c("cetz", "beamer", "tex", "quarto"))
  sort(list.files(dirs, pattern = "\\.svg$", full.names = TRUE))
}

# One caveat worth knowing: extra_files controls *invalidation*, not execution
# order. tar_quarto() takes its target dependencies from the tar_read() and
# tar_load() calls inside the chapters (here: employment_status), and there is
# no public way to add more, so `book` is not downstream of the figure targets
# in the graph and targets may dispatch it before them. A run that rebuilds a
# figure therefore renders the book from the previous version of it, and a
# second tar_make() picks up the new one. Only the local _book/ output is
# affected -- the figures themselves are committed, and CI renders the site
# from those with plain `quarto render`.
tar_book <- tar_plan(
  tar_quarto(book, path = ".", extra_files = book_figures())
)
