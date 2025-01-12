#set page(margin: (left: 0.99cm, right: 0.5cm, y: 1.52cm))
#set par(leading: 0em)
#set text(font: "Atkinson Hyperlegible", size: 30pt)
#set text(font: "Alegreya", size: 30pt)
#{
  let card_width = 63.4mm
  let card_height = 88.9mm
  let card_radius = 3mm
  let cut_guide_length = 1.5mm
  let suit_scale = 9mm
  let card_padding_x = 2mm
  let card_padding_y = 2mm

  let card(
    top_left: [],
    top_right: [],
    bottom_left: [],
    bottom_right: [],
    center_content: [],
    fill: black,
  ) = {
    box(
      stroke: (
        y: (
          thickness: .5pt,
          dash: (cut_guide_length, card_width - cut_guide_length * 2),
        ),
        x: (
          thickness: .5pt,
          dash: (cut_guide_length, card_height - cut_guide_length * 2),
        ),
      ),
      box(
        width: card_width,
        height: card_height,
        radius: card_radius,
        inset: (
          x: card_padding_x,
          y: card_padding_y,
        ),
      )[

        #set text(fill: fill)

        #place(top + left, top_left)
        #place(top + right, top_right)
        #place(bottom + right, bottom_right)
        #place(bottom + left, bottom_left)
        #place(center + horizon, image(center_content))
      ],
    )
  }

  let ranks = (
    [0],
    [1],
    [2],
    [3],
    [4],
    [5],
    [6],
    [7],
    [8],
    [9],
    [X],
    [J],
    [Q],
    [K],
    [A],
  )
  let suits = (
    sym.suit.heart,
    sym.suit.diamond,
    sym.suit.spade,
    sym.suit.club,
  )
  let animals = (
    "animals/000-clownfish.svg",
    "animals/001-crow.svg",
    "animals/002-crane.svg",
  )

  grid(
    columns: 3,
    for (rank, suit, animal) in ranks.zip(suits * 9, animals * 20) {
      let elm = align(
        center,
        stack(rank, spacing: 3mm, scale(suit_scale, reflow: true, suit)),
      )
      card(
        fill: if suit in (sym.suit.diamond, sym.suit.heart) {
          red
        } else {
          black
        },
        top_right: elm,
        top_left: elm,
        bottom_right: rotate(180deg, elm),
        bottom_left: rotate(180deg, elm),
        center_content: animal,
      )
    },
  )
}
