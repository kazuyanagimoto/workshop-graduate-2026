# Generate the two penguin bar charts used in the font-size anti-pattern
# example (lesson/slides.qmd): the ggplot2 default versus the polished
# version from the visualization chapter with a slide-friendly base_size.
# Run from the project root: Rscript static/beamer/fontsize-plots.R
library(dplyr)
library(ggplot2)
library(MetBrewer)

penguins_bar <- penguins |>
  filter(!is.na(sex))

# Default settings: this is what you get with no styling at all
p_default <- penguins_bar |>
  ggplot(aes(x = species, fill = sex)) +
  geom_bar(position = "dodge")

# Polished version from the visualization chapter, with base_size raised
# so the text stays readable after shrinking onto a slide
p_polished <- penguins_bar |>
  ggplot(aes(x = forcats::fct_rev(species), fill = sex)) +
  geom_bar(position = "dodge") +
  coord_flip() +
  labs(
    x = NULL,
    y = NULL,
    fill = NULL,
    title = "Number of Penguins by Species and Sex"
  ) +
  scale_fill_manual(values = met.brewer("Kandinsky")) +
  theme_minimal(base_size = 20) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.position = "inside",
    legend.position.inside = c(0.9, 0.5),
    plot.title.position = "plot"
  ) +
  guides(fill = guide_legend(reverse = TRUE))

ggsave(
  "static/beamer/plot-fontsize-default.pdf",
  p_default,
  width = 8, height = 4.2, device = cairo_pdf
)
ggsave(
  "static/beamer/plot-fontsize-polished.pdf",
  p_polished,
  width = 8, height = 4.2, device = cairo_pdf
)
