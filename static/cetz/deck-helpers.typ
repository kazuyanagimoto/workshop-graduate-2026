// ===========================================================================
// Drawing helpers for the figures the book shares with the workshop deck
// (lesson/targets.qmd: targets-*.typ, lesson/ai.qmd: ai-*.typ).
//
// These are taken from slides/ai-pipeline/typst/lib.typ, so that a figure the
// book shares with the deck looks the same in both. The deck labels its
// diagrams in Japanese; the book's figures are in English.
//
// Each figure file does `#import "deck-helpers.typ": *`, sets the page with
// `#show: figure-page`, and draws with `stage(w, h, { ... })`.
// ===========================================================================
#import "@preview/cetz:0.5.2"

// cetz.draw exports functions called `fill`, `stroke` and `anchor`. A helper
// that takes parameters with those names cannot `import cetz.draw: *`, so such
// helpers reach the drawing functions through this alias.
#let d = cetz.draw

// ---- Palette (the same values as _brand.yml) -------------------------------
#let c-jet = rgb("#131516")
#let c-accent = rgb("#107895")
#let c-accent2 = rgb("#9a2515")
#let c-muted = c-jet.lighten(46%)
#let c-faint = c-jet.lighten(84%)
#let c-tint = c-accent.lighten(90%)
#let c-tint2 = c-accent2.lighten(88%)
#let c-panel = rgb("#f2f4f5")
// Target statuses, as tar_visnetwork() colours them.
#let c-outdated = rgb("#78B7C5")
#let c-ok = rgb("#354823")
#let c-run = rgb("#DC863B")
#let c-ghost = c-jet.lighten(88%)
#let status-colors = (outdated: c-outdated, ok: c-ok, run: c-run, ghost: c-ghost)

// ---- Page and text ---------------------------------------------------------
// A page that fits the drawing, for compiling one figure to one SVG.
#let figure-page(body) = {
  set page(width: auto, height: auto, margin: 8pt, fill: none)
  set text(font: "Noto Sans JP")
  body
}

// Sizes passed to `mono` and `lab` are design sizes; `fs` scales all text at
// once, as in the deck.
#let fs = 1.3
#let mono(body, size: 13pt, fill: c-jet, weight: "regular") = text(
  font: "Fira Code",
  size: size * fs,
  fill: fill,
  weight: weight,
  body,
)
#let lab(body, size: 13pt, fill: c-jet, weight: "regular") = text(
  size: size * fs,
  fill: fill,
  weight: weight,
  body,
)

// A canvas with a fixed bounding box of w x h cm.
#let stage(w, h, body) = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  rect((0, 0), (w, h), stroke: none)
  body
})

// ---- Small shapes ----------------------------------------------------------
#let check-mark(x, y, s: 1, col: white, w: 1.9pt) = {
  import cetz.draw: *
  line(
    (x - 0.17 * s, y - 0.01 * s),
    (x - 0.05 * s, y - 0.13 * s),
    (x + 0.18 * s, y + 0.14 * s),
    stroke: (paint: col, thickness: w, cap: "round", join: "round"),
  )
}

#let cross-mark(x, y, s: 1, col: white, w: 1.9pt) = {
  import cetz.draw: *
  let st = (paint: col, thickness: w, cap: "round")
  line((x - 0.13 * s, y - 0.13 * s), (x + 0.13 * s, y + 0.13 * s), stroke: st)
  line((x - 0.13 * s, y + 0.13 * s), (x + 0.13 * s, y - 0.13 * s), stroke: st)
}

// An arrow between two points.
#let arrow(a, b, col: c-muted, w: 1.4pt, dash: none, head: 1.1) = {
  import cetz.draw: *
  line(a, b, stroke: (paint: col, thickness: w, dash: dash), mark: (
    end: ">",
    fill: col,
    scale: head,
  ))
}

// A polyline with an arrow head at its end.
#let arrow-path(..pts, col: c-muted, w: 1.4pt, dash: none, head: 1.1) = {
  import cetz.draw: *
  line(..pts.pos(), stroke: (paint: col, thickness: w, dash: dash, join: "round"), mark: (
    end: ">",
    fill: col,
    scale: head,
  ))
}

// A small rounded label.
#let chip(pos, body, fill: c-accent, tc: white, size: 11pt, anchor: "center", weight: "medium") = {
  d.content(pos, anchor: anchor, box(
    fill: fill,
    inset: (x: 7pt, y: 4pt),
    radius: 4pt,
    text(size: size * fs, fill: tc, weight: weight, body),
  ))
}

// A rounded box with a title and an optional second line.
#let bnode(
  pos,
  w,
  h,
  title,
  sub: none,
  fill: white,
  stroke: 1.1pt + c-jet,
  tc: c-jet,
  sc: c-muted,
  size: 13pt,
  sub-size: 10.5pt,
  code: false,
  radius: 5pt,
) = {
  let (x, y) = pos
  d.rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), fill: fill, stroke: stroke, radius: radius)
  let t = if code { mono(title, size: size, fill: tc) } else { lab(title, size: size, fill: tc, weight: "medium") }
  if sub == none {
    d.content((x, y), t)
  } else {
    d.content((x, y + 0.3), t)
    d.content((x, y - 0.36), lab(sub, size: sub-size, fill: sc))
  }
}

// A sheet of paper with a folded corner; `lines` draws that many text rules.
#let doc-icon(pos, w: 1.5, h: 1.9, fill: white, stroke: 1.1pt + c-jet, lines: 0, line-col: c-faint, tag: none, tag-fill: c-jet) = {
  let (x, y) = pos
  let f = calc.min(w, h) * 0.26
  let (l, r, b, t) = (x - w / 2, x + w / 2, y - h / 2, y + h / 2)
  d.line((l, b), (r, b), (r, t - f), (r - f, t), (l, t), close: true, fill: fill, stroke: stroke)
  d.line((r - f, t), (r - f, t - f), (r, t - f), stroke: stroke)
  for i in range(lines) {
    let yy = t - f - 0.18 - i * (h - f - 0.4) / calc.max(lines, 1)
    d.line((l + 0.2, yy), (r - 0.2 - (if calc.rem(i, 3) == 2 { 0.35 } else { 0 }), yy), stroke: 1.6pt + line-col)
  }
  if tag != none {
    d.content((x, b + 0.3), box(fill: tag-fill, inset: (x: 3.5pt, y: 2pt), radius: 2pt, mono(tag, size: 8pt, fill: white)))
  }
}

// A database cylinder, so the data reads differently from code and paper.
#let data-icon(pos, w: 1.3, h: 1.5, col: c-jet) = {
  import cetz.draw: *
  let (x, y) = pos
  let ry = h * 0.15
  let st = 1.1pt + col
  let (l, r, b, t) = (x - w / 2, x + w / 2, y - h / 2 + ry, y + h / 2 - ry)
  circle((x, b), radius: (w / 2, ry), fill: white, stroke: st)
  rect((l, b), (r, t), fill: white, stroke: none)
  line((l, b), (l, t), stroke: st)
  line((r, b), (r, t), stroke: st)
  circle((x, t), radius: (w / 2, ry), fill: white, stroke: st)
}

// A person (head and shoulders).
#let person-icon(pos, s: 1, col: c-jet) = {
  import cetz.draw: *
  let (x, y) = pos
  circle((x, y + 0.42 * s), radius: 0.24 * s, fill: col, stroke: none)
  arc((x + 0.42 * s, y - 0.36 * s), start: 0deg, stop: 180deg, radius: (0.42 * s, 0.52 * s), fill: col, stroke: none, mode: "CLOSE")
}

// A robot head, for the AI. `face` colours the eyes and the mouth.
#let ai-icon(pos, s: 1, col: c-accent, face: white) = {
  import cetz.draw: *
  let (x, y) = pos
  line((x, y + 0.42 * s), (x, y + 0.62 * s), stroke: 1.6pt + col)
  circle((x, y + 0.66 * s), radius: 0.07 * s, fill: col, stroke: none)
  rect((x - 0.45 * s, y - 0.36 * s), (x + 0.45 * s, y + 0.42 * s), radius: 0.14 * s, fill: col, stroke: none)
  circle((x - 0.17 * s, y + 0.1 * s), radius: 0.085 * s, fill: face, stroke: none)
  circle((x + 0.17 * s, y + 0.1 * s), radius: 0.085 * s, fill: face, stroke: none)
  line((x - 0.16 * s, y - 0.16 * s), (x + 0.16 * s, y - 0.16 * s), stroke: (paint: face, thickness: 1.5pt, cap: "round"))
}

// A caption above a box: what it is on the left, where it goes on the right.
// `code` sets the name in the monospace font, for a file name.
#let dest-heading(x0, x1, y, what, dest, col, code: false) = {
  let name = if code { mono } else { lab }
  d.content((x0, y), anchor: "west", name(what, size: 10.5pt, fill: c-muted))
  d.content((x1, y), anchor: "east", lab(dest, size: 10.5pt, fill: col, weight: "medium"))
}

// ---- Dependency graphs -----------------------------------------------------
// One node of a dependency graph, drawn the way tar_visnetwork() draws it:
// a circle for a target, a triangle for a function, coloured by status.
#let tnode(pos, label, status: "ok", kind: "target", r: 0.5, size: 13pt, above: false) = {
  import cetz.draw: *
  let (x, y) = pos
  let col = status-colors.at(status)
  if kind == "function" {
    let h = r * 1.2
    line((x - h, y - h * 0.75), (x + h, y - h * 0.75), (x, y + h), close: true, fill: col, stroke: none)
  } else {
    circle((x, y), radius: r, fill: col, stroke: none)
    // Redundant encoding of the status, for readers who cannot rely on colour.
    if status == "ok" { check-mark(x, y, s: r / 0.4, w: 2.2pt) }
    if status == "run" {
      line((x - 0.12, y - 0.2), (x - 0.12, y + 0.2), (x + 0.21, y), close: true, fill: white, stroke: none)
    }
  }
  let lc = if status == "ghost" { c-muted } else { c-jet }
  if label != "" {
    if above {
      content((x, y + r + 0.24), anchor: "south", mono(label, size: size, fill: lc))
    } else {
      content((x, y - r - 0.22), anchor: "north", mono(label, size: size, fill: lc))
    }
  }
}

// A dependency edge that stops short of both node circles.
#let tedge(a, b, col: c-muted, w: 1.7pt, ra: 0.5, rb: 0.5, gap: 0.14) = {
  import cetz.draw: *
  let dx = b.at(0) - a.at(0)
  let dy = b.at(1) - a.at(1)
  let dd = calc.sqrt(dx * dx + dy * dy)
  let (ux, uy) = (dx / dd, dy / dd)
  line(
    (a.at(0) + ux * (ra + gap), a.at(1) + uy * (ra + gap)),
    (b.at(0) - ux * (rb + gap), b.at(1) - uy * (rb + gap)),
    stroke: (paint: col, thickness: w),
    mark: (end: ">", fill: col, scale: 1.3),
  )
}
