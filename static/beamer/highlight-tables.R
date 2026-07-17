# Generate the regression tables used in the enclosing-box anti-pattern
# example (lesson/slides.qmd): a plain table (a TikZ box is drawn over it in
# highlight-bad.tex) and a tinytable-styled table where all rows except the
# Education coefficient are grayed out and its estimate is bold.
# Run from the project root: Rscript static/beamer/highlight-tables.R
library(fixest)
library(modelsummary)
library(tinytable)

models <- list(
  "(1)" = feols(Fertility ~ Education, data = swiss),
  "(2)" = feols(Fertility ~ Education + Agriculture, data = swiss),
  "(3)" = feols(Fertility ~ Education + Agriculture + Catholic + Infant.Mortality, data = swiss)
)

tab <- msummary(
  models,
  output = "tinytable",
  stars = TRUE,
  gof_map = c("nobs", "r.squared")
)

# Row layout: 1-2 Intercept, 3-4 Education, 5-6 Agriculture, 7-8 Catholic,
# 9-10 Infant.Mortality, 11-12 GOF
tab_styled <- tab |>
  style_tt(i = c(1:2, 5:12), color = "#8f8f8f") |>
  style_tt(i = 3, bold = TRUE)

save_tt(tab, "static/beamer/_regression-plain.tex", overwrite = TRUE)
save_tt(tab_styled, "static/beamer/_regression-styled.tex", overwrite = TRUE)
