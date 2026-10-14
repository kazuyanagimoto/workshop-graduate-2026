# ============================================================================
# Frozen results of the textbook's Quarto + {targets} example
# (static/data/targets-quarto.zip), for the slides that show what reruns
# after a change.
#
# The script unpacks the example into a temporary directory, builds it, applies
# each change the slides discuss, and records what tar_make() did and what the
# manuscript's inline number became. The deck reads the CSV it writes, so the
# numbers on the slides are measured, not typed in.
#
# Run from this deck's folder, with a library that has the example's packages
# (targets, tarchetypes, fixest, modelsummary, tinytable, ggfixest, quarto):
#
#   Rscript --no-init-file code/make-example-results.R
# ============================================================================
zip_path <- normalizePath(
  file.path("..", "..", "static", "data", "targets-quarto.zip")
)
out_path <- file.path(normalizePath("data"), "quarto-example.csv")

work <- tempfile("targets-quarto-")
dir.create(work)
unzip(zip_path, exdir = work)
root <- file.path(work, "targets-quarto")

# Replace `old` with `new` in a file of the example; fail if `old` is absent.
edit_file <- function(file, old, new) {
  path <- file.path(root, file)
  text <- paste(readLines(path), collapse = "\n")
  stopifnot(grepl(old, text, fixed = TRUE))
  writeLines(sub(old, new, text, fixed = TRUE), path)
}

# Build the pipeline and report what ran, plus the inline number of the
# manuscript (the estimate in column (3) of the regression table).
build <- function(scenario, change) {
  withr::with_dir(root, {
    outdated <- targets::tar_outdated(callr_function = callr::r)
    targets::tar_make(callr_function = callr::r, reporter = "silent")
    progress <- targets::tar_progress()
    model <- targets::tar_read(models_did)[["(3)"]]
    data.frame(
      scenario = scenario,
      change = change,
      n_targets = nrow(progress),
      completed = sum(progress$progress == "completed"),
      skipped = sum(progress$progress == "skipped"),
      outdated = paste(sort(outdated), collapse = " "),
      estimate = unname(coef(model)[["post::1:treat"]]),
      nobs = nobs(model)
    )
  })
}

theme_old <- "theme_set(theme_classic(base_size = 11))"
theme_new <- "theme_set(theme_minimal(base_size = 11))"
event_old <- "feols(y ~ x1 + i(rel_period, treat, ref = -1) | id + period,"
event_new <- "feols(y ~ i(rel_period, treat, ref = -1) | id + period,"
clean_old <- "      rel_period = period - period_treated\n    )"
clean_new <- paste0(clean_old, " |>\n    filter(abs(x1) < 8)")

results <- list(build("base", "none"))

# A: the look of the figures, set in the manuscript.
edit_file("manuscript/main.qmd", theme_old, theme_new)
results <- c(results, list(build("theme", "theme_set() in main.qmd")))
edit_file("manuscript/main.qmd", theme_new, theme_old)
build("reset", "none")

# B: the event-study specification.
edit_file("R/tar_analysis.R", event_old, event_new)
results <- c(results, list(build("event", "estimate_event()")))
edit_file("R/tar_analysis.R", event_new, event_old)
build("reset", "none")

# C: the cleaning step, upstream of everything.
edit_file("R/tar_data.R", clean_old, clean_new)
results <- c(results, list(build("clean", "clean_did()")))

write.csv(do.call(rbind, results), out_path, row.names = FALSE)
unlink(work, recursive = TRUE)
