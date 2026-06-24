#import "helpers.typ": *
#set page(width: auto, height: auto, margin: 8pt, fill: none)
#set text(font: "Noto Sans JP")

#cetz.canvas({
  import cetz.draw: *

  let box(cx, cy, w, h, title, sub, fill) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: fill, stroke: 1pt + cdark, radius: 4pt)
    content((cx, cy + 0.2), text(size: 11pt, weight: "bold", fill: cdark, title))
    content((cx, cy - 0.28), text(size: 7.5pt, fill: cgray, sub))
  }

  box(0, 0, 3.2, 1.3, "クライアント", "あなたのスクレイパー", cbox)
  box(7, 0, 3.2, 1.3, "サーバー", "Web サイト", cnode)

  // Request: client -> server.
  arr((1.7, 0.35), (5.3, 0.35), lc: cdev)
  content((3.5, 0.72), [
    #text(size: 9pt, weight: "bold", fill: cdev)[リクエスト]
    #h(5pt) #text(size: 7pt, fill: cgray)[GET /page]
  ])

  // Response: server -> client.
  arr((5.3, -0.35), (1.7, -0.35), lc: cmain)
  content((3.5, -0.72), [
    #text(size: 9pt, weight: "bold", fill: cmain)[レスポンス]
    #h(5pt) #text(size: 7pt, fill: cgray)[200 OK + HTML / JSON]
  ])
})
