#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let node(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.22), text(size: 13pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.3), text(size: 10pt, fill: cgray, sub))
  }

  node(0, 0, 3, 1.6, "Client", "Web browser", cbox)
  node(7.5, 0, 3, 1.6, "Server", "Website", cnode)

  // Request: client -> server.
  arr((1.7, 0.5), (5.8, 0.5), lc: cdev)
  content((3.75, 1.22), text(size: 11.5pt, weight: "bold", fill: cdev)[Request])
  content((3.75, 0.84), text(size: 10pt, fill: cgray)[GET /page])

  // Response: server -> client.
  arr((5.8, -0.5), (1.7, -0.5), lc: cmain)
  content((3.75, -1.22), text(size: 11.5pt, weight: "bold", fill: cmain)[Response])
  content((3.75, -0.84), text(size: 10pt, fill: cgray)[200 OK + HTML])
})
