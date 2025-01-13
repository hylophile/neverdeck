#set page(
  // paper: "us-letter",
  margin: (left: 0.99cm, right: 0cm, top: 1.52cm, bottom: 0cm),
)
#set par(leading: 0em)
// #set text(font: "Atkinson Hyperlegible", size: 30pt)














#set text(font: "CommitMono", size: 30pt)
#{
  let card_width = 63.4mm
  let card_height = 88.9mm
  let card_radius = 3mm
  let cut_guide_length = 1.5mm
  let suit_scale = 7.5mm
  let card_padding_x = 2mm
  let card_padding_y = 2mm
  let rank_suit_spacing = 2mm
  let suit_points_spacing = 1mm
  let text_big = 55pt
  let text_big2 = 45pt
  let text_small = 22pt
  let text_tiny = 9.5pt

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
  let sequence_little = (
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
  )

  let sequence_big = ((([0],) * 10,) + (([8],) * 10)).flatten()
  let all_cards = (ranks * 20).zip(
    (sym.suit.club,) * 20,
    animals * 20,
    sequence_big * 20,
    sequence_little * 20,
  )
  let cards_per_page = 9

  let page_of_cards(cards) = {
    grid(
      for (rank, suit, animal, s_big, s_little) in cards {
        let elm = align(
          left,
          stack(
            spacing: suit_points_spacing,
            align(
              center,
              stack(
                rank,
                spacing: rank_suit_spacing,
                scale(suit_scale, reflow: true, suit),
              ),
            ),
            pad(
              x: 1mm,
              stack(
                text(size: text_tiny, $sym.circle.filled$),
                text(size: text_tiny, $sym.circle.filled$),
                text(size: text_tiny, $sym.circle.filled$),
                text(size: text_tiny, $sym.circle.filled$),
              ),
            ),
          ),
        )
        card(
          fill: if suit in (sym.suit.diamond, sym.suit.heart) {
            red
          } else {
            black
          },
          top_right: text(size: text_big)[#s_big#s_little],
          top_left: elm,
          bottom_right: rotate(180deg, origin: left + top, reflow: true, elm),
          bottom_left: pad(
            bottom: 3.5mm,
            box(
              smallcaps(text(size: text_big2)[F] + text(size: text_small)[ool]),
            ),
          ),
          center_content: animal,
        )
      },
    )
  }

  for cards in all_cards.chunks(cards_per_page) {
    page_of_cards(cards)
  }
}
