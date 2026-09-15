#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 12pt, fill: none)
#set text(font: "Noto Sans JP")

// Target status of the penguins pipeline in the targets chapter, redrawn from
// targets::tar_network() after each step (not a tar_visnetwork() screenshot).

#cetz.canvas({
  import cetz.draw: *

  let cup = cdark.lighten(88%)

  // A target (solid outline) or function (dashed outline), filled by status.
  let node(cx, cy, w, lab, out, fn) = {
    rect((cx - w / 2, cy - 0.45), (cx + w / 2, cy + 0.45),
      fill: if out { chot } else { cup },
      stroke: (
        paint: if out { cdev } else { cdark },
        thickness: 1pt,
        dash: if fn { "dashed" } else { "solid" },
      ),
      radius: 4pt)
    content((cx, cy), text(size: 9pt, fill: cdark, raw(lab)))
  }

  // One dependency graph; `s` maps each node name to whether it is outdated.
  let panel(y0, title, s) = {
    content((0, y0 + 2.5), anchor: "west",
      text(size: 11pt, weight: "bold", fill: cdark, title))

    node(9.5, y0 + 1.5, 3.4, "clean_penguins()", s.clean_penguins, true)
    node(14.4, y0 + 1.5, 4.2, "summarize_penguins()", s.summarize_penguins, true)
    node(1.5, y0, 3.0, "penguins_file", s.penguins_file, false)
    node(5.3, y0, 3.0, "penguins_raw", s.penguins_raw, false)
    node(9.5, y0, 3.4, "penguins_clean", s.penguins_clean, false)
    node(14.4, y0, 4.2, "penguins_summary", s.penguins_summary, false)

    arr((3.0, y0), (3.8, y0))
    arr((6.8, y0), (7.8, y0))
    arr((11.2, y0), (12.3, y0))
    arr((9.5, y0 + 1.05), (9.5, y0 + 0.45))
    arr((14.4, y0 + 1.05), (14.4, y0 + 0.45))
  }

  panel(0, "(a) After tar_make()", (
    clean_penguins: false, summarize_penguins: false,
    penguins_file: false, penguins_raw: false,
    penguins_clean: false, penguins_summary: false,
  ))
  panel(-3.6, "(b) After editing clean_penguins()", (
    clean_penguins: true, summarize_penguins: false,
    penguins_file: false, penguins_raw: false,
    penguins_clean: true, penguins_summary: true,
  ))
  panel(-7.2, "(c) After overwriting data/penguins.csv", (
    clean_penguins: false, summarize_penguins: false,
    penguins_file: true, penguins_raw: true,
    penguins_clean: true, penguins_summary: true,
  ))

  // --- Legend ---------------------------------------------------------------
  let ly = -8.8
  let swatch(x, fill, lc, dash, lab) = {
    rect((x, ly - 0.2), (x + 0.7, ly + 0.2), fill: fill,
      stroke: (paint: lc, thickness: 1pt, dash: dash), radius: 2pt)
    content((x + 0.9, ly), anchor: "west", text(size: 9pt, fill: cdark, lab))
  }
  swatch(0, cup, cdark, "solid", "up to date")
  swatch(3.2, chot, cdev, "solid", "outdated")
  swatch(6.2, white, cdark, "solid", "target")
  swatch(8.8, white, cdark, "dashed", "function")
})
