#set page(
  // paper: "us-letter",
  margin: (left: 0.99cm, right: 0cm, top: 1.52cm, bottom: 0cm),
)
#set par(leading: 0em)
// #set text(font: "Atkinson Hyperlegible", size: 30pt)








// from https://github.com/typst/typst/issues/682#issuecomment-2252123367
#let z-stack(..contents) = (
  context {
    let max-width = calc.max(
      ..contents.pos().map(content => {
        measure(content).width
      }),
    )

    box(
      grid(
        align: center + horizon,
        columns: contents.pos().len() * (max-width,),
        column-gutter: -max-width,
        rows: 1,
        ..contents
      ),
    )
  }
)




// #set text(font: "CommitMono", size: 30pt)
#set text(font: "Alegreya", size: 30pt)

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

        #place(top + left, top_left)
        #place(top + right, top_right)
        #place(bottom + right, bottom_right)
        #place(bottom + left, bottom_left)
        #place(center + horizon, center_content)
      ],
    )
  }

  let rank_suit_points_corner(rank, suit, points, color) = {
    let points_symbol = if suit in ("sym.suit.club", "sym.suit.heart") {
      sym.circle.filled
    } else {
      sym.diamond.filled
    }
    align(
      left,
      stack(
        spacing: suit_points_spacing,
        align(
          center,
          stack(
            rank,
            spacing: rank_suit_spacing,
            scale(
              suit_scale,
              reflow: true,
              text(fill: eval(color), eval(suit)),
            ),
          ),
        ),
        pad(
          x: 1mm,
          stack(..(text(size: text_tiny, $#points_symbol$),) * points),
        ),
      ),
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
  let names = ("Fool", "Magician", "Priestess")
  let sequence_numbers = ("00", "01", "02")

  let all_cards = (ranks * 20).zip(
    (sym.suit.club,) * 20,
    ("red", "blue") * 20,
    (5, 6, 7) * 200,
    animals * 20,
    sequence_numbers * 20,
    names * 20,
  )
  let cards_per_page = 9



  let page_of_cards(cards) = {
    grid(
      for (rank, suit, color, points, image_file, number, name) in cards {
        let elm = rank_suit_points_corner(rank, suit, points, color)
        let name_initial = name.at(0)
        let name_rest = name.slice(1)
        let sequence_start = number.slice(0, -1)
        let sequence_last = number.at(-1)

        card(
          top_right: text(size: text_big, sequence_start) + text(
            size: text_big,
            fill: eval(color),
            sequence_last,
          ),
          top_left: elm,
          bottom_right: rotate(180deg, origin: left + top, reflow: true, elm),
          bottom_left: pad(
            bottom: 3.5mm,
            box(
              smallcaps(text(size: text_big2, name_initial) + text(
                size: text_small,
                fill: eval(color),
                name_rest,
              )),
            ),
          ),
          center_content: z-stack(
            circle(
              // fill: eval(color).transparentize(75%),
              stroke: eval(color) + 2mm,
              radius: card_width / 2 - 5mm,
            ),
            image(image_file),
          ),
        )
      },
    )
  }


  let all_cards = toml("everdeck.toml").cards
  for cards in all_cards.chunks(cards_per_page) {
    page_of_cards(cards)
  }
}
