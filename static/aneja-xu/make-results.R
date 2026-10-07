# ============================================================================
# Frozen results for lesson/ai.qmd (replication of Aneja and Xu 2022, QJE).
#
# The chapter does not estimate anything itself: the data are too large for the
# book's repository. This script downloads the authors' replication package
# from Harvard Dataverse (https://doi.org/10.7910/DVN/SNQLEI, CC0), runs the
# analyses the chapter discusses, and writes small CSVs next to itself. The
# chapter reads those CSVs, the same way a note or a deck in template-research
# carries a frozen copy of its results.
#
# It needs haven and HonestDiD, which are not in the book's rv library, so run
# it with the user library and without the project's .Rprofile:
#
#   Rscript --no-init-file static/aneja-xu/make-results.R
# ============================================================================
suppressPackageStartupMessages({
  library(dplyr)
  library(fixest)
})

out_dir <- file.path("static", "aneja-xu")
cache_dir <- file.path("data", "aneja-xu")

# ---- Data -------------------------------------------------------------------

# The Dataverse file id of replication.zip; the archive holds the do-files and
# data/register_panel.dta (the matched register panel used in Tables I-III).
download_package <- function(dir) {
  zip <- file.path(dir, "replication.zip")
  if (!file.exists(zip)) {
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
    url <- "https://dataverse.harvard.edu/api/access/datafile/5244851"
    curl::curl_download(url, zip, mode = "wb")
  }
  unzip(zip, files = "data/register_panel.dta", exdir = dir)
}

clean_register <- function(raw) {
  raw |>
    haven::zap_labels() |>
    filter(!is.na(year)) |>
    transmute(
      id,
      year,
      transition = if_else(w == 1, "taft_wilson", "mckinley_roosevelt"),
      black = b,
      log_salary,
      salary_pctile,
      per_annum = d_unit3,
      age_bins,
      cem
    )
}

register <- clean_register(haven::read_dta(download_package(cache_dir)))

# Matched Taft-Wilson sample: observations with a positive CEM weight.
matched <- register |>
  filter(transition == "taft_wilson", cem > 0) |>
  mutate(black_wilson = black * (year >= 1913))

# ---- Table II ---------------------------------------------------------------

est <- function(fml, data) {
  feols(fml, data, weights = ~cem, cluster = ~id)
}

m2 <- est(log_salary ~ black_wilson | id + year, matched)
# Column (1) has no individual FE but reports the same N as the other
# columns, so it runs on column (2)'s estimation sample.
m1 <- est(log_salary ~ black + black_wilson | year, matched[obs(m2), ])
m3 <- est(log_salary ~ black_wilson | id + year + age_bins^black, matched)
m4 <- est(per_annum ~ black_wilson | id + year + age_bins^black, matched)
m5 <- est(salary_pctile ~ black_wilson | id + year + age_bins^black, matched)

# Published values, transcribed from Table II of the paper.
published <- tibble(
  column = 1:5,
  outcome = c(
    "log_salary",
    "log_salary",
    "log_salary",
    "per_annum",
    "salary_pctile"
  ),
  published_estimate = c(-0.079, -0.069, -0.034, -0.020, -2.089),
  published_se = c(0.012, 0.009, 0.010, 0.008, 0.443),
  published_nobs = 92687
)

table2 <- published |>
  mutate(
    estimate = sapply(list(m1, m2, m3, m4, m5), \(m) coef(m)[["black_wilson"]]),
    std_error = sapply(list(m1, m2, m3, m4, m5), \(m) se(m)[["black_wilson"]]),
    nobs = sapply(list(m1, m2, m3, m4, m5), nobs)
  )
write.csv(table2, file.path(out_dir, "table2.csv"), row.names = FALSE)

# Why N is below the matched sample: people observed in only one year are
# singletons once individual FE are absorbed, and they are dropped.
singletons <- matched |> count(id) |> filter(n == 1) |> nrow()
stopifnot(nrow(matched) - nobs(m2) == singletons)
sample_sizes <- tibble(
  n_matched = nrow(matched),
  n_singletons = singletons,
  n_estimation = nobs(m2)
)
write.csv(sample_sizes, file.path(out_dir, "sample.csv"), row.names = FALSE)

# ---- Event study (Figure II) ------------------------------------------------

# Same specification as column (3), with Black interacted with each register
# year. 1911, the last register before Wilson took office, is the reference.
event <- est(
  log_salary ~ i(year, black, ref = 1911) | id + year + age_bins^black,
  matched
)
event_study <- tibble(
  year = as.integer(sub("year::(\\d+):black", "\\1", names(coef(event)))),
  estimate = unname(coef(event)),
  std_error = unname(se(event))
) |>
  bind_rows(tibble(year = 1911L, estimate = 0, std_error = 0)) |>
  arrange(year)
write.csv(event_study, file.path(out_dir, "event-study.csv"), row.names = FALSE)

# ---- HonestDiD --------------------------------------------------------------

# Two pre-periods (1907, 1909) and five post-periods (1913-1921). vcov()
# returns a "fixest_vcov" object, which HonestDiD rejects, so strip the class.
betahat <- coef(event)
sigma <- unclass(vcov(event))
attr(sigma, "type") <- NULL
n_pre <- 2
n_post <- 5
mbar <- seq(0, 2, by = 0.25)

honest <- function(l_vec, target) {
  original <- HonestDiD::constructOriginalCS(
    betahat,
    sigma,
    numPrePeriods = n_pre,
    numPostPeriods = n_post,
    l_vec = l_vec
  )
  robust <- HonestDiD::createSensitivityResults_relativeMagnitudes(
    betahat,
    sigma,
    numPrePeriods = n_pre,
    numPostPeriods = n_post,
    Mbarvec = mbar,
    l_vec = l_vec
  )
  bind_rows(
    tibble(
      mbar = NA_real_,
      lb = as.numeric(original$lb),
      ub = as.numeric(original$ub),
      method = "Original"
    ),
    tibble(mbar = robust$Mbar, lb = robust$lb, ub = robust$ub, method = "C-LF")
  ) |>
    mutate(target = target, .before = 1)
}

honestdid <- bind_rows(
  honest(HonestDiD::basisVector(1, n_post), "first"),
  honest(rep(1 / n_post, n_post), "average")
)
write.csv(honestdid, file.path(out_dir, "honestdid.csv"), row.names = FALSE)
