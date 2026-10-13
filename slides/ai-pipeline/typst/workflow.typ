// ===========================================================================
// Part 4: the research workflow, on the replication of Aneja and Xu (2022).
//
// `ax` is the dictionary of numbers the deck builds from data/*.csv.
// ===========================================================================
#import "lib.typ": *

// ---- 1. Two rounds of trial and error, feedback in between --------------------
#let anim-rounds(s) = {
  let cols = (
    (x: 3.3, w: 6.2, head: "Round 1", where: "notes/", fill: c-accent),
    (x: 9.95, w: 6.2, head: "Feedback", where: "slides/", fill: c-pink),
    (x: 16.6, w: 6.2, head: "Round 2", where: "notes/", fill: c-accent),
    (x: 23.0, w: 5.6, head: "Writing", where: "", fill: c-jet),
  )
  let cards = (
    (
      ("01-descriptive", "Who held which jobs?", "Figure I, Table I"),
      ("02-did", "Did the gap widen after 1913?", "Table II, Figure II"),
    ),
    (("YYMMDD_seminar", "Report the results, take questions", none),),
    (
      ("03-placebo", "Would any transition do this?", "Figure III"),
      ("04-mechanism", "Through which channel?", "Table III"),
      ("05-honestdid", "Robust to trend violations?", "an extension"),
    ),
    (
      ("manuscript/", "Write up what survived", none),
      ("R/tar_analysis.R", "Promote it to the pipeline", none),
    ),
  )
  stage(26, 10.6, {
    import cetz.draw: *
    for (k, col) in cols.enumerate() {
      if s >= k + 1 {
        chip((col.x - col.w / 2, 10.1), col.head, fill: col.fill, anchor: "west", size: 12pt)
        content((col.x + col.w / 2, 10.1), anchor: "east", mono(col.where, size: 9.5pt, fill: c-muted))
        for (i, (name, question, exhibit)) in cards.at(k).enumerate() {
          let y = 8.05 - i * 2.8
          let pipe = name == "R/tar_analysis.R"
          rect((col.x - col.w / 2, y - 1.25), (col.x + col.w / 2, y + 1.25), radius: 6pt, fill: if pipe { c-tint } else { c-panel }, stroke: if pipe and s == 5 { 1.5pt + c-accent } else { none })
          content((col.x - col.w / 2 + 0.3, y + 0.85), anchor: "west", mono(name, size: 10.5pt, fill: if pipe { c-accent.darken(15%) } else { c-jet }))
          content((col.x - col.w / 2 + 0.3, y + 0.25), anchor: "north-west", box(width: (col.w - 0.6) * 1cm, {
            set par(leading: 0.4em)
            lab(question, size: 10pt)
            if exhibit != none {
              linebreak()
              lab(exhibit, size: 9pt, fill: c-muted)
            }
          }))
        }
        if k > 0 {
          let prev = cols.at(k - 1)
          arrow((prev.x + prev.w / 2 + 0.05, 8.05), (col.x - col.w / 2 - 0.05, 8.05), col: c-jet, w: 1.8pt, head: 1.2)
        }
      }
    }
    if s == 5 {
      line((0.2, 0.95), (0.2, 0.7), (19.7, 0.7), (19.7, 0.95), stroke: 1.3pt + c-muted)
      content((9.95, 0.3), lab("outside the pipeline", size: 10.5pt, fill: c-muted))
      line((20.2, 0.95), (20.2, 0.7), (25.8, 0.7), (25.8, 0.95), stroke: 1.3pt + c-accent)
      content((23.0, 0.3), lab("the pipeline starts here", size: 10.5pt, fill: c-accent))
    }
  })
  stepcap(s, (
    [1周目: 記述統計と DID 推定で, 論文の中心となる結果にたどり着く],
    [途中結果をセミナーで報告し, 質問を受ける],
    [2周目: 受けた質問に, ノートを1つずつ作って答える],
    [結果が固まってから, 論文を書く],
    [論文に載せる分析だけをパイプラインに移し, 試行錯誤はノートに残す],
  ))
}

// ---- 2. Notes and slides are frozen, the manuscript is live -------------------
#let anim-frozen-live(s) = {
  let xs = (8.6, 13.9, 19.2, 24.3)
  let times = ("Round 1", "Seminar", "Writing", "Revision")
  let vcol = (c-accent.lighten(45%), c-pink.lighten(45%), c-run.lighten(35%), c-accent2.lighten(45%))
  let vdoc(x, y, v, frozen: false) = {
    import cetz.draw: *
    doc-icon((x, y), w: 1.25, h: 1.5, fill: vcol.at(v), stroke: (paint: c-jet, thickness: 1.1pt, dash: if frozen { "dashed" } else { none }))
    content((x, y - 0.12), mono("v" + str(v + 1), size: 10.5pt))
  }
  stage(26, 10.4, {
    import cetz.draw: *
    let rows = (
      (y: 8.3, name: "the pipeline", note: "keeps changing"),
      (y: 5.9, name: "notes/02-did/", note: "frozen snapshot"),
      (y: 3.7, name: "slides/seminar/", note: "frozen snapshot"),
      (y: 1.5, name: "manuscript/", note: "live: tar_load()"),
    )
    for r in rows {
      content((0.2, r.y + 0.28), anchor: "west", mono(r.name, size: 10.5pt))
      content((0.2, r.y - 0.38), anchor: "west", lab(r.note, size: 9.5pt, fill: c-muted))
    }
    for (t, x) in xs.enumerate() {
      if s >= t + 1 {
        content((x, 9.95), lab(times.at(t), size: 10.5pt, fill: c-muted))
        // The pipeline at time t.
        rect((x - 0.85, 7.75), (x + 0.85, 8.85), radius: 6pt, fill: vcol.at(t), stroke: 1.1pt + c-jet)
        content((x, 8.3), mono("v" + str(t + 1), size: 11pt))
        if t > 0 { arrow((xs.at(t - 1) + 1.0, 8.3), (x - 1.0, 8.3), col: c-jet, w: 1.7pt, head: 1.2) }
        // The note was made in round 1 and never changes.
        vdoc(x, 5.9, 0, frozen: t > 0)
        // The deck was made for the seminar and never changes.
        if t >= 1 { vdoc(x, 3.7, 1, frozen: t > 1) }
        // The manuscript always reads the current pipeline.
        if t >= 2 {
          vdoc(x, 1.5, t)
          arrow-path((x + 1.25, 7.75), (x + 1.25, 1.5), (x + 0.8, 1.5), col: c-accent, w: 1.6pt, head: 1.2)
        }
      }
    }
  })
  stepcap(s, (
    [1周目: ノートは, そのとき使ったデータと結果を自分のフォルダに持つ],
    [ノートとスライドは, パイプラインが変わっても作成時の記録を保つ],
    [パイプラインを読むのは論文だけ],
    [論文は常に最新で, ノートとスライドは後日も同じ結果になる],
  ))
}

// ---- 3. Each note: read the intent, then write the prompt ---------------------
#let anim-intent-prompt(s) = {
  stage(26, 9.6, {
    import cetz.draw: *
    let step(x, w, title, body, on, fill: c-panel) = {
      if on {
        rect((x - w / 2, 3.7), (x + w / 2, 8.5), radius: 7pt, fill: fill, stroke: none)
        content((x, 7.6), lab(title, size: 15pt, weight: "medium"))
        content((x, 5.6), box(width: (w - 0.5) * 1cm, align(center, {
          set par(leading: 0.5em)
          lab(body, size: 11.5pt, fill: c-muted)
        })))
      }
    }
    step(3.0, 5.6, "Exhibit", "a figure or a table in the paper", s >= 1)
    step(9.7, 5.6, "Intent", "what is it meant to show?", s >= 2, fill: c-tint)
    step(16.4, 5.6, "Prompt", "sample, outcome, fixed effects, weights, clustering", s >= 3, fill: c-tint)
    step(23.1, 5.6, "AI output", "code and results in the note", s >= 3)
    if s >= 2 {
      arrow((5.9, 6.1), (6.8, 6.1), col: c-accent, w: 2.2pt, head: 1.3)
      content((6.35, 9.15), lab("1. read", size: 12pt, fill: c-accent, weight: "medium"))
    }
    if s >= 3 {
      arrow((12.6, 6.1), (13.5, 6.1), col: c-accent, w: 2.2pt, head: 1.3)
      content((13.05, 9.15), lab("2. write", size: 12pt, fill: c-accent, weight: "medium"))
      arrow((19.3, 6.1), (20.2, 6.1), col: c-muted, w: 2.2pt, head: 1.3)
    }
    if s >= 4 {
      arrow-path((23.1, 3.5), (23.1, 1.9), (3.0, 1.9), (3.0, 3.5), col: c-accent2, w: 2.2pt, head: 1.3)
      content((13.05, 1.2), lab("3. compare the result with the paper", size: 12pt, fill: c-accent2, weight: "medium"))
    }
  })
  stepcap(s, (
    [出発点は論文の図表. 再現の練習なので, 答えは手元にある],
    [意図を読む: その図表が何を示すための分析かを, 論文から読み取る],
    [指示を書く: 分析の意図を, AI への指示に落とす],
    [結果を論文と照らす. 自分の研究なら意図はすでにあるので, 1つ目は要らない],
  ))
}

// ---- 4. Three questions at the seminar become three notes ---------------------
#let anim-feedback(s) = {
  let items = (
    (q: "Any new president reshuffles staff. Would any transition do this?", note: "03-placebo", sub: "Figure III of the paper"),
    (q: "Same job at lower pay, or a move to lower-paid jobs?", note: "04-mechanism", sub: "Table III of the paper"),
    (q: "Flat pre-trends do not guarantee parallel trends afterwards.", note: "05-honestdid", sub: "not in the paper"),
  )
  stage(26, 10.4, {
    import cetz.draw: *
    for (i, it) in items.enumerate() {
      let y = 8.7 - i * 3.3
      bubble((7.4, y), 14.4, 2.1, it.q, tail: "left", size: 11.5pt)
      if s >= i + 2 {
        arrow((14.9, y), (17.0, y), col: c-accent, w: 2pt, head: 1.3)
        let ext = i == 2
        rect((17.2, y - 1.05), (25.8, y + 1.05), radius: 6pt, fill: if ext { c-accent } else { c-tint }, stroke: none)
        content((17.6, y + 0.38), anchor: "west", mono("notes/" + it.note + "/", size: 10.5pt, fill: if ext { white } else { c-jet }))
        content((17.6, y - 0.42), anchor: "west", lab(it.sub, size: 10pt, fill: if ext { white } else { c-muted }))
      }
    }
  })
  stepcap(s, (
    [セミナーで, 3つの質問を受けた],
    [1つ目: 人種分離のない政権交代に同じ分析を当てはめる],
    [2つ目にはメカニズムの分析. 職名の固定効果で, 同じ職の中の変化だけを残す],
    [3つ目は論文にない拡張. 何を確かめるかは, 質問から自分で定める],
  ))
}

// ---- 5. Mechanism: same job at lower pay, or a lower-paid job -----------------
// A cartoon of the two channels; bar lengths stand for pay and carry no data.
#let anim-mechanism(s, ax) = {
  stage(26, 10.4, {
    import cetz.draw: *
    let bands = ((y: 8.4, name: "Job title A", note: "higher pay"), (y: 5.4, name: "Job title B", note: ""), (y: 2.4, name: "Job title C", note: "lower pay"))
    for b in bands {
      rect((3.9, b.y - 1.2), (15.6, b.y + 1.2), radius: 6pt, fill: c-panel, stroke: none)
      content((0.2, b.y + 0.25), anchor: "west", lab(b.name, size: 11pt))
      content((0.2, b.y - 0.4), anchor: "west", lab(b.note, size: 9.5pt, fill: c-muted))
    }
    // A worker with a bar for pay.
    let worker(x, y, col, who, pay) = {
      person-icon((x, y - 0.05), s: 0.85, col: col)
      content((x, y - 0.85), lab(who, size: 9pt, fill: col))
      rect((x + 0.8, y - 0.22), (x + 0.8 + pay, y + 0.22), radius: 2pt, fill: col.lighten(35%), stroke: none)
    }
    // The matched white worker stays in job B at the same pay throughout.
    worker(5.0, 5.55, c-muted, "White", 3.0)
    if s <= 2 {
      worker(10.4, 5.55, c-accent, "Black", if s == 1 { 3.0 } else { 1.9 })
    } else {
      worker(10.4, 2.55, c-accent, "Black", 1.9)
      arrow((10.4, 4.5), (10.4, 3.5), col: c-accent, w: 2pt, head: 1.3)
    }
    // The reading of each frame.
    let panel(title, body, col) = {
      rect((16.4, 5.6), (25.8, 9.6), radius: 6pt, fill: col.lighten(88%), stroke: none)
      content((16.8, 8.8), anchor: "west", lab(title, size: 11.5pt, weight: "medium", fill: col))
      content((16.8, 7.1), anchor: "west", box(width: 8.6cm, {
        set par(leading: 0.5em)
        lab(body, size: 10.5pt)
      }))
    }
    if s == 1 { panel("1911", "Matched on gender, department, contract, pay and age. Start them in the same job.", c-jet) }
    if s == 2 { panel("Channel 1", "After 1913 the Black worker keeps the job, but is paid less.", c-accent) }
    if s >= 3 { panel("Channel 2", "After 1913 the Black worker is moved to a lower-paid job.", c-accent) }
    if s >= 4 {
      rect((16.4, 0.6), (25.8, 5.0), radius: 6pt, fill: c-tint, stroke: none)
      content((16.8, 4.3), anchor: "west", lab("Black × Wilson, log salary", size: 10pt, fill: c-muted))
      content((16.8, 3.4), anchor: "west", lab("main specification", size: 10.5pt))
      content((25.4, 3.4), anchor: "east", mono(ax.did3_pub, size: 11.5pt))
      content((16.8, 2.5), anchor: "west", lab("+ job title fixed effects", size: 10.5pt))
      content((25.4, 2.5), anchor: "east", mono(ax.tab3_col2, size: 11.5pt, weight: "bold", fill: c-accent.darken(10%)))
      content((16.8, 1.3), anchor: "west", lab("Aneja and Xu (2022), Tables II and III", size: 8.5pt, fill: c-muted))
    }
    illus-tag(0.2, 0.1, anchor: "south-west")
  })
  stepcap(s, (
    [
      1911年の属性が近い黒人と白人を組にする.
      #linebreak()
      照合するのは性別, 部局, 契約形態, 賃金, 年齢である.
    ],
    [賃金差が開く経路の1つ目: 同じ職のまま, 賃金が下がる],
    [2つ目: 賃金の低い職に移される],
    [職名の固定効果で差がほぼ消えるので, 主な経路は職の移動である],
  ))
}

// ---- 6. Relative magnitudes: how far parallel trends may fail -----------------
// A drawing of the restriction itself, with made-up deviations before the
// reference period.
#let anim-rm(s) = {
  let xs = (3.4, 6.6, 9.8, 13.3, 16.8, 20.3, 23.8)
  let ts = ("−2", "−1", "0", "1", "2", "3", "4")
  let y0 = 5.0
  let step = 0.5
  stage(26, 10.4, {
    import cetz.draw: *
    // Allowed deviations after the reference period: a cone that widens by
    // Mbar times the largest pre-period step every period.
    let cone(m, fill) = line((xs.at(2), y0), (xs.at(6), y0 + 4 * m * step), (xs.at(6), y0 - 4 * m * step), close: true, fill: fill, stroke: none)
    if s >= 3 { cone(2, c-accent.lighten(86%)) }
    if s >= 2 { cone(1, c-accent.lighten(68%)) }
    // Time axis.
    line((1.6, y0), (25.2, y0), stroke: 1.2pt + c-jet)
    for (i, x) in xs.enumerate() {
      line((x, y0 - 0.12), (x, y0 + 0.12), stroke: 1.2pt + c-jet)
      content((x, 9.9), lab(if i == 0 { "t = " + ts.at(i) } else { ts.at(i) }, size: 10.5pt, fill: c-muted))
    }
    line((11.55, 0.6), (11.55, 9.5), stroke: (paint: c-muted, thickness: 1pt, dash: "dashed"))
    content((6.6, 9.1), lab("before", size: 10.5pt, fill: c-muted))
    content((18.5, 9.1), lab("after", size: 10.5pt, fill: c-muted))
    // Deviations from parallel trends before the reference period.
    let pre = ((xs.at(0), y0 + 0.75), (xs.at(1), y0 + 0.25), (xs.at(2), y0))
    line(..pre, stroke: 2pt + c-accent2)
    for p in pre { circle(p, radius: 0.16, fill: c-accent2, stroke: none) }
    // The largest step between neighbouring pre-periods.
    line((xs.at(0) - 0.45, y0 + 0.75), (xs.at(0) - 0.7, y0 + 0.75), (xs.at(0) - 0.7, y0 + 0.25), (xs.at(0) - 0.45, y0 + 0.25), stroke: 1.4pt + c-accent2)
    content((xs.at(0) + 0.2, y0 + 1.75), anchor: "west", lab("largest step before", size: 11pt, fill: c-accent2, weight: "medium"))
    if s >= 2 {
      content((xs.at(5), y0 + 0.75), box(fill: white.transparentize(15%), inset: 3pt, radius: 3pt, lab([$overline(M) = 1$], size: 11.5pt, fill: c-accent.darken(20%))))
      content((xs.at(2) + 0.3, 1.2), anchor: "west", lab("allowed deviations from parallel trends", size: 11pt, fill: c-accent.darken(20%)))
    }
    if s >= 3 {
      content((xs.at(5), y0 + 2.3), box(fill: white.transparentize(15%), inset: 3pt, radius: 3pt, lab([$overline(M) = 2$], size: 11.5pt, fill: c-accent.darken(20%))))
    }
    content((25.8, 0.1), anchor: "south-east", lab("relative magnitudes, Rambachan and Roth (2023)", size: 9pt, fill: c-muted))
    illus-tag(0.2, 0.1, anchor: "south-west")
  })
  stepcap(s, (
    [事前の期間で, 隣り合う時点の間のずれが最も大きいところを測る],
    [事後のずれは, 1期ごとにその $overline(M)$ 倍まで許す. $overline(M) = 1$ なら, 事前と同じ大きさまで],
    [$overline(M)$ を大きくすると制約が緩む. 基準時点から離れるほど, 許されるずれは積み上がる],
  ))
}

// ---- 7. HonestDiD results, revealed by Mbar -----------------------------------
// The frames are drawn by R from data/honestdid.csv (see index.qmd).
#let anim-honestdid(s, ax) = {
  align(center, image("../output/honestdid-" + str(s) + ".svg", height: 10cm))
  stepcap(s, (
    [元の信頼区間は, `fixest` の係数と標準誤差から作った区間と一致するはず],
    [$overline(M) = 0$ では事後の平行トレンドが厳密に成り立つので, 元の区間に近くなるはず],
    [
      $overline(M)$ が大きいほど制約が緩み, 区間は広がるはずである.
      #linebreak()
      1913年の効果は $overline(M) = #ax.bd_first_last$ まで 0 を含まない.
    ],
    [期間が長いほどずれが積み上がり, 平均効果は $overline(M) = #ax.bd_avg_zero$ で 0 を含む],
  ))
}

// ---- 8. Promotion: from a note's script to a function and its targets ---------
#let anim-promote(s) = {
  stage(26, 10.4, {
    import cetz.draw: *
    // The note.
    rect((0.2, 5.3), (8.2, 10.0), radius: 7pt, fill: c-panel, stroke: none)
    content((0.6, 9.4), anchor: "west", mono("notes/02-did/code/", size: 10.5pt))
    doc-icon((2.0, 7.4), w: 1.5, h: 1.9, lines: 4)
    content((3.2, 7.75), anchor: "west", mono("01_event.R", size: 10.5pt))
    content((3.2, 7.0), anchor: "west", lab("a trial-and-error script", size: 9.5pt, fill: c-muted))
    if s >= 4 { chip((0.6, 5.9), "kept as it is", fill: c-muted, anchor: "west", size: 10pt) }
    if s >= 2 {
      // The function.
      arrow((8.4, 7.9), (11.0, 7.9), col: c-accent, w: 2.4pt, head: 1.4)
      content((9.7, 7.3), lab("promote", size: 11pt, fill: c-accent, weight: "medium"))
      tnode((12.0, 7.9), "fct_event()", kind: "function", above: true, r: 0.55)
    }
    if s >= 3 {
      tnode((9.6, 3.0), "register")
      tedge((9.6, 3.0), (16.0, 4.6))
      tedge((9.6, 3.0), (16.0, 1.9))
      tedge((12.0, 7.9), (16.0, 4.6), ra: 0.65)
      tedge((12.0, 7.9), (16.0, 1.9), ra: 0.65)
      tnode((16.0, 4.6), "analysis_event", side: "right")
      content((16.75, 3.95), anchor: "west", mono("\"taft_wilson\", 1911", size: 9.5pt, fill: c-muted))
      tnode((16.0, 1.9), "analysis_placebo", side: "right")
      content((16.75, 1.25), anchor: "west", mono("\"mckinley_roosevelt\", 1901", size: 9.5pt, fill: c-muted))
    }
    if s >= 4 {
      tedge((16.0, 4.6), (20.6, 8.1))
      tnode((20.6, 8.1), "analysis_honestdid", above: true)
    }
  })
  stepcap(s, (
    [試行錯誤のコードは, ノートの `code/` にある],
    [昇格とは, 固まった分析を関数にしてパイプラインに移すことである],
    [同じ関数を2つの政権交代に使い, Figure II と Figure III を作る],
    [感度分析はイベントスタディを使い, ノートは凍結したまま残す],
  ))
}

// ---- 9. Do-files: the same estimation in two places ---------------------------
#let anim-dofile(s) = {
  let files = ("table 1.do", "table 2.do", "figure 1.do", "figure 2.do", "figure 3.do")
  let outs = ("Table I", "Table II", "Figure I", "Figure II", "Figure III")
  stage(26, 10.4, {
    import cetz.draw: *
    doc-icon((1.9, 5.4), w: 1.7, h: 2.1, tag: "dta")
    content((1.9, 3.95), mono("register_panel", size: 9.5pt))
    for (i, f) in files.enumerate() {
      let y = 9.4 - i * 2.0
      let twin = i >= 3
      let edited = s >= 2 and i == 3
      arrow((2.95, 5.4), (5.9, y), w: 1.5pt, head: 1.2)
      rect((6.1, y - 0.65), (11.9, y + 0.65), radius: 5pt, fill: if twin { c-tint2 } else { white }, stroke: if twin { 1.5pt + c-accent2 } else { 1.2pt + c-jet })
      content((9.0, y), mono(f, size: 11pt))
      arrow((12.1, y), (13.9, y), w: 1.5pt, head: 1.2)
      let stale = s >= 2 and i == 4
      doc-icon((14.7, y), w: 1.0, h: 1.25, lines: 2, fill: if edited { c-ok.lighten(70%) } else if stale { c-tint2 } else { white }, stroke: if stale { 1.4pt + c-accent2 } else { 1.1pt + c-jet })
      content((15.5, y), anchor: "west", lab(outs.at(i), size: 10.5pt))
      if edited { chip((18.4, y), "new base year", fill: c-ok, anchor: "west", size: 9.5pt) }
      if stale { chip((18.4, y), "old base year", fill: c-accent2, anchor: "west", size: 9.5pt) }
    }
    if s >= 2 { chip((6.1, 4.25), "edited", fill: c-accent2, anchor: "west", size: 9.5pt) }
    if s == 1 {
      line((18.2, 4.0), (18.5, 4.0), (18.5, 0.8), (18.2, 0.8), stroke: 1.4pt + c-accent2)
      content((18.9, 2.4), anchor: "west", box(width: 6.6cm, {
        set par(leading: 0.5em)
        lab("the same event study, estimated twice", size: 11pt, fill: c-accent2, weight: "medium")
      }))
    }
    if s >= 3 {
      rect((17.6, 5.9), (25.8, 10.0), radius: 6pt, fill: c-panel, stroke: none)
      content((18.0, 7.95), anchor: "west", box(width: 7.4cm, {
        set par(leading: 0.5em)
        lab("Who knows that figure 3.do has to change too? The README, and your memory. The AI remembers nothing.", size: 10.5pt)
      }))
    }
  })
  stepcap(s, (
    [図表ごとの do-file で同じイベントスタディを2回推定している],
    [研究の途中で片方だけを直すと, 2つの図が食い違う],
    [どの do-file が何に依存するかは, README と人間の記憶にしか残っていない],
  ))
}

// ---- 10. The finished pipeline: one change, every dependent exhibit -----------
#let anim-ax-pipeline(s) = {
  let rows = (
    ("analysis_salary_1911", 9.7),
    ("analysis_balance", 8.4),
    ("analysis_did", 7.1),
    ("analysis_mechanism", 5.8),
    ("analysis_placebo", 4.5),
    ("analysis_event", 3.2),
    ("analysis_honestdid", 1.3),
  )
  let hit = ("analysis_placebo", "analysis_event", "analysis_honestdid")
  let out = s == 3
  stage(26, 10.6, {
    import cetz.draw: *
    let col(on) = if on { c-outdated.darken(8%) } else { c-muted.lighten(25%) }
    doc-icon((1.0, 5.75), w: 1.15, h: 1.4, tag: "dta")
    arrow((1.75, 5.65), (3.0, 5.65), col: c-muted.lighten(25%), w: 1.6pt, head: 1.2)
    for (name, y) in rows {
      let stale = out and name in hit
      if name != "analysis_honestdid" { tedge((3.8, 5.65), (10.4, y), ra: 0.42, rb: 0.42, col: c-muted.lighten(25%)) }
      arrow((17.6, y), (21.9, 5.6 + (y - 5.6) * 0.16), col: col(stale), w: 1.5pt, head: 1.2)
    }
    tedge((10.4, 3.2), (10.4, 1.3), ra: 0.42, rb: 0.42, col: col(out))
    tedge((6.9, 1.9), (10.4, 4.5), ra: 0.55, rb: 0.42, col: col(out or s == 2))
    tedge((6.9, 1.9), (10.4, 3.2), ra: 0.55, rb: 0.42, col: col(out or s == 2))
    tnode((3.8, 5.65), "register", r: 0.42, size: 11pt)
    tnode((6.9, 1.9), "fct_event()", kind: "function", r: 0.45, size: 11pt, status: if s == 2 or s == 3 { "outdated" } else { "ok" }, ring: if s == 2 or s == 3 { c-accent2 } else { none })
    for (name, y) in rows {
      tnode((10.4, y), name, r: 0.42, size: 11pt, side: "right", status: if out and name in hit { "outdated" } else { "ok" })
    }
    doc-icon((23.2, 5.6), w: 1.9, h: 2.4, lines: 4, fill: if out { c-outdated } else { c-ok }, stroke: none, line-col: white.transparentize(50%))
    if not out {
      circle((23.2, 5.45), radius: 0.42, fill: white, stroke: none)
      check-mark(23.2, 5.45, col: c-ok, w: 2.2pt)
    }
    content((23.2, 4.1), mono("manuscript_pdf", size: 10pt))
    if s == 2 or s == 3 { chip((5.9, 1.95), "change the base year", fill: c-accent2, anchor: "east", size: 10pt) }
    if out {
      content((23.2, 2.6), box(width: 5.2cm, align(center, {
        set par(leading: 0.5em)
        lab("Figure II, Figure III and the sensitivity plot change together", size: 9.5pt, fill: c-muted)
      })))
    }
  })
  stepcap(s, (
    [`register` から各分析に分かれ, すべてが論文の PDF につながる],
    [AI に「イベントスタディの基準年を変えて」と頼む],
    [2つの推定と感度分析, 論文が古くなる. 記述統計と DID は緑のまま],
    [`{targets}` が変更の影響を判定し, `tar_make()` が必要な分を再計算する],
  ))
}

// ---- 11. The estimating equation, with its parts named ------------------------
#let fig-did-eq() = align(center, text(size: 1.2em)[
  $ log(w_(i t)) = beta dot.op underbrace("Black"_i times "Wilson"_t, "treatment") + underbrace(theta_i, "person FE") + underbrace(tau_t, "year FE") + epsilon_(i t) $
])
