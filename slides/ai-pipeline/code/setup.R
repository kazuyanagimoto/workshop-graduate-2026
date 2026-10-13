# Frozen setup for this deck.
#
# Like every deck in the research template, this one never reads a live
# pipeline: the results it shows are copies kept in data/, and the figures are
# drawn from those copies when the deck is rendered.
#
#   data/sample.csv, event-study.csv, honestdid.csv, table2.csv
#       copies of static/aneja-xu/*.csv (made by static/aneja-xu/make-results.R)
#   data/quarto-example.csv
#       made by code/make-example-results.R
library(dplyr)
library(ggplot2)

deck_brand <- rmarkdown::yaml_front_matter("index.qmd")$brand
font_family <- deck_brand$typography$base$family

# ---- theme (frozen copy) ----------------------------------------------------

color_jet <- "#131516"
color_accent <- "#107895"
color_accent2 <- "#9a2515"

theme_slide <- function(size_base = 20) {
  theme_classic(base_size = size_base, base_family = font_family) +
    theme(
      text = element_text(color = color_jet),
      axis.text = element_text(color = color_jet),
      axis.line = element_line(linewidth = 0.3),
      axis.ticks = element_line(linewidth = 0.3),
      legend.title = element_blank(),
      legend.key = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(hjust = 0, face = "bold"),
      plot.margin = margin(t = 5, r = 20, b = 5, l = 5)
    )
}

# ---- frozen results ---------------------------------------------------------

sample_sizes <- read.csv("data/sample.csv")
event_study <- read.csv("data/event-study.csv")
honestdid <- read.csv("data/honestdid.csv")
table2 <- read.csv("data/table2.csv")
quarto_example <- read.csv("data/quarto-example.csv")

# ---- numbers shown on the slides --------------------------------------------

fmt_int <- function(x) format(x, big.mark = ",")
# A number with a true minus sign instead of a hyphen.
fmt_num <- function(x, digits = 3) {
  sub("-", "−", sprintf(paste0("%.", digits, "f"), x), fixed = TRUE)
}

# Largest pre-period change between consecutive registers (1907-1911).
pre <- event_study |> filter(year <= 1911) |> arrange(year)
max_pre <- max(abs(diff(pre$estimate)))

# Breakdown: the last Mbar on the grid whose robust CI excludes zero, and the
# first one whose CI includes it.
breakdown <- honestdid |>
  filter(method == "C-LF") |>
  mutate(covers_zero = lb <= 0 & ub >= 0) |>
  summarize(
    last_robust = max(mbar[!covers_zero]),
    first_zero = min(mbar[covers_zero]),
    .by = target
  )
bd_first <- breakdown |> filter(target == "first")
bd_avg <- breakdown |> filter(target == "average")

did3 <- table2 |> filter(column == 3)

# Table III, column (2) of Aneja and Xu (2022), as printed in the paper. The
# deck does not re-estimate it, so this is a quotation, not a computed value.
published_tab3_col2 <- list(estimate = -0.008, std_error = 0.008)

# ---- figures ----------------------------------------------------------------

# Event study of the Black-white log salary gap, with 95% confidence intervals.
plot_event <- function() {
  event_study |>
    mutate(
      lb = estimate - qnorm(0.975) * std_error,
      ub = estimate + qnorm(0.975) * std_error
    ) |>
    ggplot(aes(x = year, y = estimate, ymin = lb, ymax = ub)) +
    geom_hline(yintercept = 0, color = "gray60") +
    geom_vline(xintercept = 1912, linetype = "dashed", color = "gray40") +
    geom_line(color = color_accent) +
    geom_pointrange(color = color_accent, size = 0.7, linewidth = 0.8) +
    scale_x_continuous(breaks = event_study$year) +
    labs(x = "Year of the register", y = "Log salary, Black vs. white") +
    theme_slide(size_base = 17)
}

# Robust confidence intervals under relative magnitudes. Intervals with Mbar
# above `max_mbar` are left out, but the axes stay the same in every frame.
plot_honestdid <- function(max_mbar = Inf) {
  mbar_grid <- as.character(sort(unique(na.omit(honestdid$mbar))))
  d <- honestdid |>
    mutate(
      x = if_else(method == "Original", "Orig.", as.character(mbar)),
      x = factor(x, levels = c("Orig.", mbar_grid)),
      target = factor(
        target,
        levels = c("first", "average"),
        labels = c("Effect in 1913", "Average effect, 1913-1921")
      ),
      type = case_when(
        method == "Original" ~ "Original",
        lb <= 0 & ub >= 0 ~ "Robust, includes zero",
        .default = "Robust, excludes zero"
      ),
      type = factor(
        type,
        levels = c("Original", "Robust, excludes zero", "Robust, includes zero")
      )
    )
  shown <- d |> filter(method == "Original" | mbar <= max_mbar)
  ggplot(d, aes(x = x, ymin = lb, ymax = ub)) +
    geom_blank() +
    geom_hline(yintercept = 0, color = "gray60") +
    geom_errorbar(
      aes(color = type, linetype = type),
      data = shown,
      width = 0.35,
      linewidth = 1,
      show.legend = TRUE
    ) +
    facet_wrap(~target, ncol = 2, scales = "free_y") +
    scale_x_discrete(
      drop = FALSE,
      breaks = c("Orig.", "0", "0.5", "1", "1.5", "2")
    ) +
    scale_color_manual(
      values = c(
        "Original" = "gray45",
        "Robust, excludes zero" = color_accent,
        "Robust, includes zero" = color_accent2
      ),
      drop = FALSE
    ) +
    scale_linetype_manual(
      values = c(
        "Original" = "dashed",
        "Robust, excludes zero" = "solid",
        "Robust, includes zero" = "solid"
      ),
      drop = FALSE
    ) +
    labs(x = expression(bar(M)), y = "95% confidence interval") +
    theme_slide(size_base = 17) +
    # No panel corner stays free once every interval is drawn, so the legend
    # goes above the panels.
    theme(legend.position = "top")
}

# Write one frame of an animation to output/ as SVG and return its path.
save_frame <- function(plot, name, width = 9.4, height = 4) {
  dir.create("output", showWarnings = FALSE)
  path <- file.path("output", paste0(name, ".svg"))
  grDevices::svg(path, width = width, height = height)
  print(plot)
  grDevices::dev.off()
  path
}
