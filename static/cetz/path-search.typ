#import "helpers.typ": *
#import "@preview/fontawesome:0.5.0": *
#set page(width: auto, height: auto, margin: 14pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  // A folder card: a directory on PATH with a couple of executables inside.
  let card(cx, path, found) = {
    let fill = if found { chot } else { cbox }
    let stroke = if found { 1.3pt + cdev } else { 1pt + cdark }
    rect((cx - 1.3, -0.1), (cx + 1.3, 1.65), fill: fill, stroke: stroke, radius: 4pt)
    content((cx, 1.35),
      text(size: 10pt, weight: "bold", fill: cdark)[#fa-folder() #h(3pt) #path])
    line((cx - 1.15, 1.08), (cx + 1.15, 1.08), stroke: 0.6pt + cgray)
  }

  // --- Instruction + search-order arrow -------------------------------------
  content((4.6, 3.3),
    text(size: 10.5pt, fill: cdark)[type `ls` #sym.arrow.r the shell scans #raw("$PATH") left to right])
  arr((0.2, 2.55), (9.0, 2.55), lc: cgray)
  for (i, cx) in ((1, 1.6), (2, 4.6), (3, 7.6)) {
    circle((cx, 2.55), radius: 0.24, fill: cmain, stroke: none)
    content((cx, 2.55), text(size: 9pt, weight: "bold", fill: white, str(i)))
  }

  // --- Three PATH directories -----------------------------------------------
  card(1.6, "/usr/local/bin", false)
  content((1.6, 0.72), text(size: 9pt, fill: cgray, "git   quarto"))
  content((1.6, 0.36), text(size: 9pt, fill: cgray, "node  uv"))

  card(4.6, "/usr/bin", false)
  content((4.6, 0.72), text(size: 9pt, fill: cgray, "python  make"))
  content((4.6, 0.36), text(size: 9pt, fill: cgray, "grep  awk"))

  card(7.6, "/bin", true)
  content((7.6, 0.72),
    text(size: 9.5pt, weight: "bold", fill: cdev, "ls") + text(size: 9pt, fill: cgray, "   cp   mv"))
  content((7.6, 0.36), text(size: 9pt, fill: cgray, "cat  echo"))

  // --- Results --------------------------------------------------------------
  content((1.6, -0.55), text(size: 9pt, fill: cgray)[#fa-xmark() #h(2pt) no `ls` here])
  content((4.6, -0.55), text(size: 9pt, fill: cgray)[#fa-xmark() #h(2pt) no `ls` here])
  content((7.6, -0.55), text(size: 9pt, weight: "bold", fill: cdev)[#fa-check() #h(2pt) found `ls`])

  arr((7.6, -0.85), (7.6, -1.35), lc: cdev)
  content((7.6, -1.62), text(size: 10.5pt, weight: "bold", fill: cdev, "runs /bin/ls"))
})
