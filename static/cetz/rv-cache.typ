#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // Invisible padding so box strokes near the edges are not clipped.
  rect((-8.9, -0.9), (4.0, 5.2), stroke: none)

  // Global cache at the bottom: the shared foundation every project draws from.
  fbox(0, 0, 7.0, 1.2, [Global cache\ \~/.cache/rv], col: cmain, tc: white)

  // Repository feeds the cache from the side.
  fbox(-6.9, 0, 3.0, 1.1, [Repository\ (CRAN / P3M)], col: cbox)

  // Per-project libraries sit on top of the cache.
  fbox(-2.0, 2.3, 3.2, 1.1, [Project A\ rv/library/...], col: cnode)
  fbox(2.0, 2.3, 3.2, 1.1, [Project B\ rv/library/...], col: cnode)

  // R sessions on top, each seeing only its own library.
  fbox(-2.0, 4.4, 3.2, 0.9, [R session (A)], col: cbox)
  fbox(2.0, 4.4, 3.2, 0.9, [R session (B)], col: cbox)

  // Repository -> cache (downloaded once per version).
  arr((-5.4, 0), (-3.5, 0))
  cap(-4.45, 0.45, "download", col: cgray)

  // Cache -> each project library (copied / linked, no rebuild). Arrows go up.
  arr((-2.0, 0.6), (-2.0, 1.75))
  arr((2.0, 0.6), (2.0, 1.75))
  cap(0, 1.2, "copy / link", col: cgray)

  // Library -> R session (activated on startup by .Rprofile).
  arr((-2.0, 2.85), (-2.0, 3.95))
  arr((2.0, 2.85), (2.0, 3.95))
  cap(0, 3.4, ".libPaths()", col: cgray)
})
