// ===========================================================================
// Shared drawing helpers for the deck.
//
// Every animated diagram is a function of the subslide index `s`: the slide
// calls `#slide(repeat: n, self => anim-x(self.subslide))` and the function
// redraws the whole picture for that frame. Each frame draws into a canvas of
// the same size (see `stage`), so nothing jumps between frames.
//
// Text inside the diagrams is English (repository policy); the captions under
// them are Japanese, like the rest of the slide text.
// ===========================================================================
#import "@preview/cetz:0.5.2"
#import "@preview/touying-quarto-clean:0.2.0": *

// cetz.draw exports functions called `fill`, `stroke` and `anchor`. A helper
// that takes parameters with those names cannot `import cetz.draw: *`, so such
// helpers reach the drawing functions through this alias.
#let d = cetz.draw

// ---- Palette (the same values as _brand.yml) -------------------------------
#let c-jet = rgb("#131516")
#let c-accent = rgb("#107895")
#let c-accent2 = rgb("#9a2515")
#let c-pink = rgb("#e64173")
#let c-muted = c-jet.lighten(46%)
#let c-faint = c-jet.lighten(84%)
#let c-tint = c-accent.lighten(90%)
#let c-tint2 = c-accent2.lighten(88%)
#let c-panel = rgb("#f2f4f5")

// Target status colours follow targets::tar_visnetwork(), so the diagrams look
// like what participants see on their own screens.
#let c-outdated = rgb("#78B7C5")
#let c-ok = rgb("#354823")
#let c-run = rgb("#DC863B")
#let c-ghost = c-jet.lighten(88%)
#let status-colors = (outdated: c-outdated, ok: c-ok, run: c-run, ghost: c-ghost)

// ---- Text ------------------------------------------------------------------
// Sizes passed to `mono` and `lab` are design sizes; `fs` scales all diagram
// text at once, so legibility on a projector can be tuned in one place.
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

// ---- Canvas ----------------------------------------------------------------
// A canvas with a fixed bounding box of w x h cm.
#let stage(w, h, body) = align(center, cetz.canvas(length: 1cm, {
  import cetz.draw: *
  rect((0, 0), (w, h), stroke: none)
  body
}))

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

// A speech bubble whose tail points down-left or down-right.
#let bubble(pos, w, h, body, fill: white, stroke: 1.1pt + c-jet, tail: "left", size: 12.5pt, tc: c-jet) = {
  let (x, y) = pos
  let (l, r, b, t) = (x - w / 2, x + w / 2, y - h / 2, y + h / 2)
  let tx = if tail == "left" { l + 0.7 } else { r - 0.7 }
  let dir = if tail == "left" { -1 } else { 1 }
  if tail != none {
    d.line((tx - 0.22, b + 0.02), (tx + dir * 0.25, b - 0.42), (tx + 0.22, b + 0.02), close: true, fill: fill, stroke: stroke)
  }
  d.rect((l, b), (r, t), radius: 7pt, fill: fill, stroke: stroke)
  if tail != none {
    // Hide the seam between the tail and the bubble.
    d.line((tx - 0.2, b), (tx + 0.2, b), stroke: 2pt + fill)
  }
  d.content((x, y), box(width: (w - 0.5) * 1cm, align(center, text(size: size * fs, fill: tc, body))))
}

// ---- Dependency graphs -----------------------------------------------------
// One node of a dependency graph, drawn the way tar_visnetwork() draws it:
// a circle for a target, a triangle for a function, coloured by status.
#let tnode(
  pos,
  label,
  status: "ok",
  kind: "target",
  r: 0.5,
  size: 13pt,
  above: false,
  side: none,
  ring: none,
  note: none,
) = {
  import cetz.draw: *
  let (x, y) = pos
  let col = status-colors.at(status)
  // `side` places the label below, above, left or right of the node; the older
  // `above` flag is kept as a shorthand.
  let side = if side != none { side } else if above { "above" } else { "below" }
  if kind == "function" {
    let h = r * 1.2
    line((x - h, y - h * 0.75), (x + h, y - h * 0.75), (x, y + h), close: true, fill: col, stroke: none)
  } else {
    circle((x, y), radius: r, fill: col, stroke: none)
  }
  // Redundant encoding of the status, for readers who cannot rely on colour.
  if kind != "function" {
    if status == "ok" { check-mark(x, y, s: r / 0.4, w: 2.2pt) }
    if status == "run" {
      line((x - 0.12, y - 0.2), (x - 0.12, y + 0.2), (x + 0.21, y), close: true, fill: white, stroke: none)
    }
  }
  if ring != none {
    circle((x, y), radius: r + 0.2, stroke: (paint: ring, thickness: 1.8pt, dash: "dashed"), fill: none)
  }
  let lc = if status == "ghost" { c-muted } else { c-jet }
  if side == "above" {
    content((x, y + r + 0.24), anchor: "south", mono(label, size: size, fill: lc))
  } else if side == "right" {
    content((x + r + 0.25, y), anchor: "west", mono(label, size: size, fill: lc))
  } else if side == "left" {
    content((x - r - 0.25, y), anchor: "east", mono(label, size: size, fill: lc))
  } else {
    content((x, y - r - 0.22), anchor: "north", mono(label, size: size, fill: lc))
  }
  if note != none {
    content((x, y - r - 0.22 - size.pt() * fs / 28.35 - 0.24), anchor: "north", note)
  }
}

// A dependency edge that stops short of both node circles.
#let tedge(a, b, col: c-muted, dash: none, w: 1.7pt, ra: 0.5, rb: 0.5, gap: 0.14) = {
  import cetz.draw: *
  let dx = b.at(0) - a.at(0)
  let dy = b.at(1) - a.at(1)
  let d = calc.sqrt(dx * dx + dy * dy)
  let (ux, uy) = (dx / d, dy / d)
  line(
    (a.at(0) + ux * (ra + gap), a.at(1) + uy * (ra + gap)),
    (b.at(0) - ux * (rb + gap), b.at(1) - uy * (rb + gap)),
    stroke: (paint: col, thickness: w, dash: dash),
    mark: (end: ">", fill: col, scale: 1.3),
  )
}

// A whole graph. `nodes` maps a name to (pos, label, kind, above); `edges` is
// an array of (from, to); `st` maps names to a status and `default` covers the
// rest. Nodes listed in `hidden` are skipped together with their edges.
#let tgraph(
  nodes,
  edges,
  st: (:),
  default: "ok",
  hidden: (),
  rings: (:),
  notes: (:),
  size: 13pt,
  r: 0.5,
  hidden-edges: (),
) = {
  for (a, b) in edges {
    if a not in hidden and b not in hidden and (a, b) not in hidden-edges {
      let sa = st.at(a, default: default)
      let col = if sa == "outdated" { c-outdated.darken(8%) } else if sa == "ghost" { c-faint } else { c-muted.lighten(25%) }
      let fa = nodes.at(a).at("kind", default: "target") == "function"
      tedge(nodes.at(a).pos, nodes.at(b).pos, ra: if fa { r * 1.15 } else { r }, rb: r, col: col)
    }
  }
  for (name, n) in nodes {
    if name not in hidden {
      tnode(
        n.pos,
        n.at("label", default: name),
        status: st.at(name, default: default),
        kind: n.at("kind", default: "target"),
        above: n.at("above", default: false),
        side: n.at("side", default: none),
        ring: rings.at(name, default: none),
        note: notes.at(name, default: none),
        size: size,
        r: r,
      )
    }
  }
}

// Legend for the graph vocabulary. `items` picks the statuses to show;
// `vertical` stacks the entries instead of laying them out in a row.
#let status-legend(pos, items: ("outdated", "ok"), shapes: true, size: 11pt, gap: 3.6, vertical: false) = {
  import cetz.draw: *
  let (x, y) = pos
  let names = (outdated: "Outdated", ok: "Up to date", run: "Running")
  let at(i) = if vertical { (x, y - i * 0.62) } else { (x + i * gap, y) }
  let i = 0
  for it in items {
    let (px, py) = at(i)
    circle((px, py), radius: 0.22, fill: status-colors.at(it), stroke: none)
    content((px + 0.4, py), anchor: "west", lab(names.at(it), size: size, fill: c-muted))
    i += 1
  }
  if shapes {
    let (px, py) = at(i)
    circle((px, py), radius: 0.22, fill: c-muted, stroke: none)
    content((px + 0.4, py), anchor: "west", lab("Target", size: size, fill: c-muted))
    let (fx, fy) = if vertical { at(i + 1) } else { (px + 2.9, py) }
    line((fx - 0.25, fy - 0.19), (fx + 0.25, fy - 0.19), (fx, fy + 0.25), close: true, fill: c-muted, stroke: none)
    content((fx + 0.4, fy), anchor: "west", lab("Function", size: size, fill: c-muted))
  }
}

// ---- Panels outside the canvas ---------------------------------------------
// Progress dots plus the Japanese caption of the current frame. The height is
// fixed so that the layout does not move from frame to frame.
// Keep captions on one line. If two are needed, break between full sentences.
#let stepbar(s, n, body, height: 2.3em) = block(width: 100%, height: height, above: 0.4em, {
  set align(horizon)
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.9em,
    align: horizon,
    box(for i in range(1, n + 1) {
      box(circle(
        radius: 4pt,
        stroke: none,
        fill: if i == s { c-accent } else if i < s { c-accent.lighten(55%) } else { c-faint },
      ))
      h(3.5pt)
    }),
    text(size: 0.95em, body),
  )
})

// Picks the caption of frame `s` from an array and shows it with the dots.
#let stepcap(s, caps, height: 2.3em) = stepbar(s, caps.len(), caps.at(s - 1), height: height)

// Source code with a file tab. Lines whose index is in `hl` are highlighted;
// lines from index `upto` on are laid out but hidden (not yet "typed").
#let code-box(lines, hl: (), upto: none, lang: "r", size: 13.5pt, width: 100%, file: none, dim: ()) = block(width: width, {
  // Raw text defaults to 0.8em, so its size is set explicitly here.
  show raw: set text(size: size)
  if file != none {
    block(below: 0pt, fill: c-jet.lighten(25%), inset: (x: 9pt, y: 4.5pt), radius: (top: 4pt), mono(
      file,
      size: 9.5pt,
      fill: white,
    ))
  }
  block(
    width: 100%,
    above: 0pt,
    fill: c-panel,
    radius: if file != none { (bottom: 5pt, top-right: 5pt) } else { 5pt },
    inset: (x: 7pt, y: 7pt),
    {
      for (i, l) in lines.enumerate() {
        let body = box(
          width: 100%,
          inset: (x: 4pt, y: 3pt),
          radius: 2pt,
          fill: if i in hl { c-accent.lighten(78%) } else { none },
          text(fill: if i in dim { c-muted.lighten(30%) } else { c-jet }, raw(if l == "" { " " } else { l }, lang: if i in dim { none } else { lang })),
        )
        block(spacing: 0pt, if upto != none and i >= upto { hide(body) } else { body })
      }
    },
  )
})

// Console output. Each line is content; build lines with the helpers below.
#let console-box(lines, width: 100%, height: auto, size: 13pt) = block(
  width: width,
  height: height,
  fill: c-jet.lighten(8%),
  radius: 5pt,
  inset: (x: 11pt, y: 9pt),
  {
    set text(font: "Fira Code", size: size, fill: white)
    for l in lines { block(spacing: 0.66em, l) }
  },
)
#let cl-cmd(cmd) = [#text(fill: c-outdated)[>] #cmd]
#let cl-dispatch(name) = text(fill: white.darken(25%))[\+ #name dispatched]
#let cl-done(name) = [#text(fill: rgb("#9fd18b"))[ok] #name completed]
#let cl-end(done, skipped) = text(fill: rgb("#9fd18b"))[ok ended pipeline [#done completed, #skipped skipped]]

// ---- Slide kinds -----------------------------------------------------------
// A white callout distinguishes exercises without colouring the whole slide.
// Keep the task, essential code and closing check together in one panel.
#let exercise(num: 1, time: 10, body) = slide(config: config-page(fill: white))[
  // Keep programming operators such as |> in their literal character forms.
  #set text(ligatures: false, features: (calt: 0))
  #set par(leading: 0.65em, spacing: 0.75em)
  #set enum(spacing: 0.65em)
  #block(
    width: 100%,
    breakable: false,
    fill: white,
    stroke: (rest: 0.7pt + c-faint, left: 3pt + c-accent),
    radius: 6pt,
    inset: (x: 16pt, y: 14pt),
  )[
    #block(
      width: 100%,
      above: 0pt,
      below: 12pt,
      inset: (bottom: 10pt),
      stroke: (bottom: 0.6pt + c-faint),
      grid(
        columns: (1fr, auto),
        align: horizon,
        text(size: 16pt, fill: c-accent, weight: "medium")[演習 #num],
        text(size: 14pt, fill: c-muted)[目安 #time 分],
      ),
    )
    #body
  ]
]

// Closing questions stay on one line whenever possible.
#let exercise-note(label, body) = block(width: 100%, above: 0.75em)[
  #grid(
    columns: (6.5em, 1fr),
    column-gutter: 0.8em,
    align: top,
    text(size: 17pt, fill: c-accent, weight: "medium", label),
    text(size: 17pt, body),
  )
]

// Section slide: show the part title.
#let deck-section-slide(self: none, body) = touying-slide-wrapper(self => {
  let main-body = {
    set align(left + horizon)
    block(text(
      size: 1.9em,
      fill: self.colors.primary,
      weight: "medium",
      utils.display-current-heading(level: 1),
    ))
  }
  self = utils.merge-dicts(self, config-page(margin: (left: 2em, right: 2em, top: 1em)))
  touying-slide(self: self, main-body)
})

// An example prompt, set off from the slide text. Used through `.prompt`.
#let prompt-card(body) = block(
  width: 100%,
  fill: c-tint,
  radius: 6pt,
  inset: (x: 0.9em, y: 0.65em),
  stroke: (left: 3.5pt + c-accent),
  text(size: 0.8em, body),
)
