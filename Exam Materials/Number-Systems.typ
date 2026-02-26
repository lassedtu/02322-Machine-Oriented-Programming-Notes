// ─────────────────────────────────────────────────────────────
//  Number Systems & Binary Arithmetic Reference
// ─────────────────────────────────────────────────────────────

#set page(paper: "a4", margin: (x: 2cm, y: 2cm))
#set text(font: "New Computer Modern", size: 10pt)
#set par(leading: 5pt)

// ── Teal/green palette (distinct from the blue LC-3 sheets) ──
#let accent       = rgb("#1a4a45")   // deep teal
#let accent2      = rgb("#2a7a72")   // medium teal
#let accent-light = rgb("#e6f4f2")   // pale teal tint
#let row-alt      = rgb("#f3fafa")
#let border       = rgb("#b0d4d0")
#let code-bg      = rgb("#eef6f5")
#let highlight    = rgb("#fff8e1")   // warm yellow for key facts
#let hi-border    = rgb("#f0c040")

// ── Helpers ──────────────────────────────────────────────────

#let hc(content) = table.cell(fill: accent, align: center + horizon)[
  #text(fill: white, weight: "bold", size: 9pt)[#content]
]
#let sc(n, label) = table.cell(colspan: n, fill: accent2)[
  #text(fill: white, weight: "bold", size: 8.5pt)[▸ #upper(label)]
]
#let mono(c)  = text(font: "Courier New", size: 8.5pt)[#c]
#let monoS(c) = text(font: "Courier New", size: 7.8pt)[#c]

#let note(content) = block(
  fill: accent-light,
  stroke: (paint: border, thickness: 0.5pt),
  inset: 8pt, radius: 3pt, width: 100%,
)[#text(size: 8.5pt)[#content]]

#let key(content) = block(
  fill: highlight,
  stroke: (paint: hi-border, thickness: 0.5pt),
  inset: 8pt, radius: 3pt, width: 100%,
)[#text(size: 8.5pt)[#content]]

#let sectionbar(title) = block(
  fill: accent2, inset: (x: 10pt, y: 6pt),
  radius: 3pt, width: 100%,
)[#text(fill: white, weight: "bold", size: 10pt)[#title]]

#let bitbox(b, highlight: false) = box(
  fill: if highlight { rgb("#2a7a72") } else { rgb("#e6f4f2") },
  stroke: (paint: border, thickness: 0.8pt),
  inset: (x: 5pt, y: 3pt),
  radius: 2pt,
)[#text(
  font: "Courier New", size: 9pt,
  weight: if highlight { "bold" } else { "regular" },
  fill: if highlight { white } else { black },
)[#b]]

// ── Title ────────────────────────────────────────────────────

#align(center)[
  #block(fill: accent, inset: (x: 24pt, y: 14pt), radius: 4pt, width: 100%)[
    #text(fill: white, size: 18pt, weight: "bold")[Number Systems & Binary Arithmetic]
    #linebreak()
    #text(fill: rgb("#a0d4ce"), size: 9pt)[
      Binary · Hex · Decimal · Two's Complement · Addition · Subtraction · Overflow · Conversion
    ]
  ]
]

#v(12pt)

// ══════════════════════════════════════════════════════════════
//  1. POSITIONAL NOTATION OVERVIEW
// ══════════════════════════════════════════════════════════════

#sectionbar[1 — Positional Notation]
#v(5pt)

#table(
  columns: (auto, auto, auto, 1fr, 1fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  hc[Base], hc[Name], hc[Digits], hc[Example], hc[Value],

  [2],  [Binary],      [0–1],   [#mono[1101]],        [1×2³ + 1×2² + 0×2¹ + 1×2⁰ = *13*],
  [8],  [Octal],       [0–7],   [#mono[015]],         [1×8¹ + 5×8⁰ = *13*],
  [10], [Decimal],     [0–9],   [#mono[13]],          [1×10¹ + 3×10⁰ = *13*],
  [16], [Hexadecimal], [0–9,A–F],[#mono[0xD] / #mono[x000D]], [13×16⁰ = *13*],
)

#v(5pt)
#note[*Hex digit↔nibble:* Each hex digit maps to exactly 4 bits. #h(8pt)
  #mono[0]=0000 · #mono[1]=0001 · #mono[2]=0010 · #mono[3]=0011 · #mono[4]=0100 · #mono[5]=0101 · #mono[6]=0110 · #mono[7]=0111 \
  #mono[8]=1000 · #mono[9]=1001 · #mono[A]=1010 · #mono[B]=1011 · #mono[C]=1100 · #mono[D]=1101 · #mono[E]=1110 · #mono[F]=1111
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  2. POWERS OF 2  (quick-lookup)
// ══════════════════════════════════════════════════════════════

#sectionbar[2 — Powers of 2 (Quick Lookup)]
#v(5pt)

#table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 6pt, y: 5pt),
  fill: (_, row) => if row == 0 { accent } else { white },

  hc[2ⁿ],
  hc[n=0], hc[1], hc[2], hc[3], hc[4], hc[5], hc[6], hc[7],
  hc[8], hc[9], hc[10], hc[11], hc[12], hc[13], hc[14], hc[15],

  [*value*],
  [1],[2],[4],[8],[16],[32],[64],[128],
  [256],[512],[1K],[2K],[4K],[8K],[16K],[32K],
)

#v(5pt)
#note[*Useful:* 2¹⁶ = 65 536 (LC-3 address space) · 2⁸ = 256 · 2¹² = 4 096 · 2¹⁵ = 32 768 (most-negative 16-bit signed)]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  3. BASE CONVERSION METHODS
// ══════════════════════════════════════════════════════════════

#sectionbar[3 — Base Conversion Methods]
#v(5pt)

#grid(columns: (1fr, 1fr), gutter: 10pt,

  // LEFT
  stack(spacing: 8pt,

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Decimal → Binary (repeated division by 2)]
      #v(3pt)
      #text(size:8.5pt)[Divide by 2, record remainders bottom-up:]
      #v(3pt)
      #table(
        columns:(auto,auto,auto),
        stroke:(paint:border,thickness:.5pt),
        inset:(x:6pt,y:4pt),
        fill:(c,row)=>if row==0 {accent} else if calc.odd(row){white} else {row-alt},
        hc[÷ 2], hc[Quotient], hc[Remainder (bit)],
        [25],[12],[*1* (LSB)],
        [12],[6],[*0*],
        [6],[3],[*0*],
        [3],[1],[*1*],
        [1],[0],[*1* (MSB)],
      )
      #v(3pt)
      #text(size:8.5pt)[Read remainders *upward*: 25₁₀ = #mono[11001]₂]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Decimal → Hex (repeated division by 16)]
      #v(3pt)
      #text(size:8.5pt)[Same idea, divide by 16:]
      #v(3pt)
      #table(
        columns:(auto,auto,auto),
        stroke:(paint:border,thickness:.5pt),
        inset:(x:6pt,y:4pt),
        fill:(c,row)=>if row==0 {accent} else if calc.odd(row){white} else {row-alt},
        hc[÷ 16], hc[Quotient], hc[Remainder (hex digit)],
        [255],[15],[*F* (LSD)],
        [15],[0],[*F* (MSD)],
      )
      #v(3pt)
      #text(size:8.5pt)[Read upward: 255₁₀ = #mono[xFF]]
    ],
  ),

  // RIGHT
  stack(spacing: 8pt,

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Binary → Decimal (sum of place values)]
      #v(3pt)
      #text(size:8.5pt)[Write out bit positions, sum the 1s:]
      #v(3pt)
      #table(
        columns:(auto,auto,auto,auto,auto,auto,auto,auto),
        stroke:(paint:border,thickness:.5pt),
        inset:(x:5pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else {white},
        hc[bit 7],hc[6],hc[5],hc[4],hc[3],hc[2],hc[1],hc[0 (LSB)],
        [0],[1],[1],[0],[1],[0],[0],[1],
        [—],[64],[32],[—],[8],[—],[—],[1],
      )
      #v(3pt)
      #text(size:8.5pt)[64 + 32 + 8 + 1 = *105*]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Binary ↔ Hex (group into nibbles)]
      #v(3pt)
      #text(size:8.5pt)[Split binary into groups of 4 from the right, convert each:]
      #v(5pt)
      #align(center)[
        #mono[1010  1111  0011] \
        #h(6pt)#mono[A] #h(18pt) #mono[F] #h(18pt) #mono[3] \
        #text(size:8pt)[→ #mono[0xAF3]]
      ]
      #v(3pt)
      #text(size:8.5pt)[Pad with leading zeros if the leftmost group has < 4 bits.]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Hex → Decimal]
      #v(3pt)
      #text(size:8.5pt)[Expand each digit by its power of 16:]
      #v(3pt)
      #text(size:8.5pt, font:"Courier New")[0x2B = 2×16¹ + 11×16⁰ = 32 + 11 = *43*]
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  4. UNSIGNED VS SIGNED RANGES
// ══════════════════════════════════════════════════════════════

#sectionbar[4 — Unsigned vs. Signed Ranges]
#v(5pt)

#table(
  columns: (auto, auto, auto, auto, auto),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  hc[Bits (n)], hc[Unsigned range], hc[Unsigned max], hc[Signed range (2's comp)], hc[Signed max / min],

  [4],  [0 → 15],         [2⁴−1 = 15],      [−8 → +7],                [−2³ to 2³−1],
  [8],  [0 → 255],        [2⁸−1 = 255],     [−128 → +127],            [−2⁷ to 2⁷−1],
  [16], [0 → 65 535],     [2¹⁶−1 = 65 535], [−32 768 → +32 767],      [−2¹⁵ to 2¹⁵−1],
  [n],  [0 → 2ⁿ−1],       [2ⁿ−1],           [−2ⁿ⁻¹ → 2ⁿ⁻¹−1],        [MSB is sign bit],
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  5. TWO'S COMPLEMENT
// ══════════════════════════════════════════════════════════════

#sectionbar[5 — Two's Complement]
#v(5pt)

#grid(columns: (1fr, 1fr), gutter: 10pt,

  stack(spacing: 8pt,

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[How to negate a number]
      #v(3pt)
      #text(size:8.5pt)[*Method 1 — Invert & add 1:*]
      #v(3pt)
      #table(columns:(auto,1fr), stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[Step], hc[Example: negate +5 (4-bit)],
        [Start],      [#mono[0101]  (+5)],
        [Invert all], [#mono[1010]  (flip every bit)],
        [Add 1],      [#mono[1011]  (−5 ✓)],
      )
      #v(5pt)
      #text(size:8.5pt)[*Method 2 — Copy from right up to and including first 1, then invert the rest:*]
      #v(3pt)
      #text(font:"Courier New", size:8.5pt)[
        #mono[0110 0 *1* 0 0] → copy rightmost 1 and zeros: #mono[...1 0 0]\
        invert the rest: #mono[1 0 0 1] #h(4pt) → #mono[1001 1100]
      ]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Reading a negative two's complement value]
      #v(3pt)
      #text(size:8.5pt)[If MSB = 1, the number is negative. Two ways to read it:]
      #v(3pt)
      #text(size:8.5pt)[*Option A — Negate it, read as positive, add minus sign:*\
        #mono[1011] → invert: #mono[0100] → +1 = #mono[0101] = 5 → value is *−5*]
      #v(4pt)
      #text(size:8.5pt)[*Option B — Weighted MSB:* treat MSB as −2ⁿ⁻¹, sum the rest normally:\
        #mono[1011] = −1×2³ + 0×2² + 1×2¹ + 1×2⁰ = −8+0+2+1 = *−5*]
    ],
  ),

  stack(spacing: 8pt,

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Sign extension (SEXT)]
      #v(3pt)
      #text(size:8.5pt)[To extend an n-bit value to more bits, *copy the MSB* into all new positions:]
      #v(3pt)
      #table(columns:(auto,auto,auto), stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[4-bit], hc[8-bit SEXT], hc[Value],
        [#mono[0101]], [#mono[0000 0101]], [+5 (MSB=0 → pad with 0s)],
        [#mono[1011]], [#mono[1111 1011]], [−5 (MSB=1 → pad with 1s)],
      )
      #v(3pt)
      #text(size:8.5pt)[Sign extension *preserves the value*. Zero extension (#mono[ZEXT]) pads with 0s regardless (for unsigned values).]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Special cases]
      #v(3pt)
      #table(columns:(auto,auto,auto), stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[Pattern], hc[n-bit value], hc[Note],
        [#mono[0000…0]], [0],           [Only zero],
        [#mono[0111…1]], [+2ⁿ⁻¹ − 1],  [Most positive],
        [#mono[1000…0]], [−2ⁿ⁻¹],       [Most negative — *has no positive counterpart!*],
        [#mono[1111…1]], [−1],           [All ones = −1],
      )
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  6. BINARY ADDITION
// ══════════════════════════════════════════════════════════════

#sectionbar[6 — Binary Addition]
#v(5pt)

#grid(columns: (auto, 1fr), gutter: 12pt,

  // carry table
  block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt)[
    #text(weight:"bold", size:8.5pt)[Single-bit addition table]
    #v(4pt)
    #table(
      columns:(auto,auto,auto,auto),
      stroke:(paint:border,thickness:.5pt),
      inset:(x:7pt,y:5pt),
      fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
      hc[A], hc[B], hc[Cᵢₙ], hc[Sum · Cₒᵤₜ],
      [0],[0],[0],[0 · 0],
      [0],[1],[0],[1 · 0],
      [1],[0],[0],[1 · 0],
      [1],[1],[0],[0 · 1],
      [0],[0],[1],[1 · 0],
      [0],[1],[1],[0 · 1],
      [1],[0],[1],[0 · 1],
      [1],[1],[1],[1 · 1],
    )
  ],

  stack(spacing: 8pt,
    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Column addition example (8-bit):  53 + 78]
      #v(4pt)
      #table(
        columns:(auto,auto,auto,auto,auto,auto,auto,auto,auto),
        stroke:(paint:border,thickness:.5pt),
        inset:(x:5pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if row==1{rgb("#d4ece9")} else if calc.odd(row){white} else {row-alt},
        hc[bit], hc[7],hc[6],hc[5],hc[4],hc[3],hc[2],hc[1],hc[0],
        [carry],  [0],[1],[1],[0],[0],[0],[1],[0],
        [53 =],   [0],[0],[1],[1],[0],[1],[0],[1],
        [78 =],   [0],[1],[0],[0],[1],[1],[1],[0],
        [sum],    [*0*],[*1*],[*1*],[*1*],[*1*],[*0*],[*1*],[*1*],
      )
      #v(3pt)
      #text(size:8.5pt)[Result: #mono[01111011] = 64+32+16+8+2+1 = *131* ✓]
    ],

    block(fill: highlight, stroke:(paint:hi-border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Rules to remember]
      #v(3pt)
      #text(size:8.5pt)[
        0 + 0 = *0*, carry 0 #h(12pt) 0 + 1 = *1*, carry 0 \
        1 + 1 = *0*, carry 1 #h(12pt) 1 + 1 + 1 = *1*, carry 1
      ]
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  7. BINARY SUBTRACTION
// ══════════════════════════════════════════════════════════════

#sectionbar[7 — Binary Subtraction]
#v(5pt)

#note[*Key insight:* A − B is computed as A + (−B). Negate B using two's complement, then add normally. No separate subtraction circuit needed.]

#v(6pt)

#grid(columns:(1fr,1fr), gutter:10pt,

  block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
    #text(weight:"bold", size:8.5pt)[Example: 12 − 5 (8-bit)]
    #v(4pt)
    #table(columns:(auto,1fr), stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
      fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
      hc[Step], hc[Value],
      [12 in binary],         [#mono[0000 1100]],
      [5 in binary],          [#mono[0000 0101]],
      [Invert 5],             [#mono[1111 1010]],
      [Add 1 (−5)],           [#mono[1111 1011]],
      [Add 12 + (−5)],        [#mono[0000 0111]  (carry out discarded)],
      [Result],               [#mono[0000 0111] = *7* ✓],
    )
  ],

  block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
    #text(weight:"bold", size:8.5pt)[Example: 5 − 12 (8-bit) — negative result]
    #v(4pt)
    #table(columns:(auto,1fr), stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
      fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
      hc[Step], hc[Value],
      [5 in binary],          [#mono[0000 0101]],
      [12 in binary],         [#mono[0000 1100]],
      [Invert 12],            [#mono[1111 0011]],
      [Add 1 (−12)],          [#mono[1111 0100]],
      [Add 5 + (−12)],        [#mono[1111 1001]  (no carry out)],
      [Result (MSB=1→neg)],   [negate: #mono[0000 0111] = *−7* ✓],
    )
  ],
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  8. OVERFLOW DETECTION
// ══════════════════════════════════════════════════════════════

#sectionbar[8 — Overflow Detection]
#v(5pt)

#table(
  columns: (auto, auto, 1fr, 1fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  hc[Operand signs], hc[Result sign], hc[Overflow?], hc[Example (4-bit)],

  [+ + +], [+], [No],  [3 + 4 = 7  #mono[0011+0100=0111] ✓],
  [+ + +], [−], [*YES*], [5 + 4 = −7?  #mono[0101+0100=1001] ✗],
  [− + −], [−], [No],  [−3 + (−4) = −7  ✓],
  [− + −], [+], [*YES*], [−5 + (−4) = +7?  #mono[1011+1100=0111] ✗],
  [+ + −], [either], [Never], [Mixed signs can never overflow],
)

#v(5pt)
#key[
  *Overflow rules (signed):* \
  • Adding two *positives* and getting a *negative* → overflow \
  • Adding two *negatives* and getting a *positive* → overflow \
  • *Hardware shortcut:* overflow = Cᵢₙ to MSB *XOR* Cₒᵤₜ from MSB \
  • *Unsigned overflow* (carry): simply check if carry-out from MSB = 1
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  9. BITWISE OPERATIONS
// ══════════════════════════════════════════════════════════════

#sectionbar[9 — Bitwise Operations & Tricks]
#v(5pt)

#grid(columns:(1fr,1fr), gutter:10pt,

  stack(spacing:8pt,

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Truth tables]
      #v(4pt)
      #table(columns:(auto,auto,auto,auto,auto,auto),
        stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[A], hc[B], hc[AND], hc[OR], hc[XOR], hc[NOT A],
        [0],[0],[0],[0],[0],[1],
        [0],[1],[0],[1],[1],[1],
        [1],[0],[0],[1],[1],[0],
        [1],[1],[1],[1],[0],[0],
      )
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Shifts]
      #v(4pt)
      #table(columns:(auto,1fr,1fr),
        stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[Shift], hc[Effect], hc[Example (8-bit)],
        [Left ≪ n],  [× 2ⁿ; fill LSBs with 0],        [#mono[0000 0011] ≪ 2 = #mono[0000 1100] (3→12)],
        [Logical ≫ n],[÷ 2ⁿ (unsigned); fill MSBs with 0],[#mono[0000 1100] ≫ 2 = #mono[0000 0011] (12→3)],
        [Arith. ≫ n], [÷ 2ⁿ (signed); fill MSBs with sign],[#mono[1111 0000] ≫ 2 = #mono[1111 1100] (−16→−4)],
      )
    ],
  ),

  stack(spacing:8pt,

    block(fill: highlight, stroke:(paint:hi-border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Common bit manipulation patterns]
      #v(4pt)
      #table(columns:(auto,1fr),
        stroke:(paint:border,thickness:.5pt), inset:(x:6pt,y:4pt),
        fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[Goal], hc[Operation],
        [Test bit k],     [#mono[x AND (1 << k)] ≠ 0],
        [Set bit k],      [#mono[x OR (1 << k)]],
        [Clear bit k],    [#mono[x AND NOT(1 << k)]],
        [Toggle bit k],   [#mono[x XOR (1 << k)]],
        [Clear all],      [#mono[x AND 0000…0 = 0]],
        [Check if power of 2], [#mono[x AND (x−1) == 0]],
        [Isolate LSB],    [#mono[x AND (−x)]],
        [Check odd/even], [#mono[x AND 1] (1=odd, 0=even)],
      )
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Masking example — extract bits 7–4]
      #v(3pt)
      #text(size:8.5pt)[
        Value: #mono[1010 1101] \
        Mask:  #mono[1111 0000]  (#mono[AND] with #mono[0xF0]) \
        Result:#mono[1010 0000]  → shift right 4 → #mono[0000 1010] = 10
      ]
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  10. CONVERSION QUICK-REFERENCE TABLE
// ══════════════════════════════════════════════════════════════

#sectionbar[10 — Decimal / Binary / Hex Quick Reference (0–31)]
#v(5pt)

#grid(columns:(1fr,1fr), gutter:10pt,

  table(
    columns:(auto,auto,auto),
    stroke:(paint:border,thickness:.5pt),
    inset:(x:7pt,y:4pt),
    fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
    hc[Dec], hc[Binary], hc[Hex],
    [0], [#mono[00000]], [#mono[0x00]],
    [1], [#mono[00001]], [#mono[0x01]],
    [2], [#mono[00010]], [#mono[0x02]],
    [3], [#mono[00011]], [#mono[0x03]],
    [4], [#mono[00100]], [#mono[0x04]],
    [5], [#mono[00101]], [#mono[0x05]],
    [6], [#mono[00110]], [#mono[0x06]],
    [7], [#mono[00111]], [#mono[0x07]],
    [8], [#mono[01000]], [#mono[0x08]],
    [9], [#mono[01001]], [#mono[0x09]],
    [10],[#mono[01010]], [#mono[0x0A]],
    [11],[#mono[01011]], [#mono[0x0B]],
    [12],[#mono[01100]], [#mono[0x0C]],
    [13],[#mono[01101]], [#mono[0x0D]],
    [14],[#mono[01110]], [#mono[0x0E]],
    [15],[#mono[01111]], [#mono[0x0F]],
  ),

  table(
    columns:(auto,auto,auto),
    stroke:(paint:border,thickness:.5pt),
    inset:(x:7pt,y:4pt),
    fill:(_,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
    hc[Dec], hc[Binary], hc[Hex],
    [16],[#mono[10000]], [#mono[0x10]],
    [17],[#mono[10001]], [#mono[0x11]],
    [18],[#mono[10010]], [#mono[0x12]],
    [19],[#mono[10011]], [#mono[0x13]],
    [20],[#mono[10100]], [#mono[0x14]],
    [21],[#mono[10101]], [#mono[0x15]],
    [22],[#mono[10110]], [#mono[0x16]],
    [23],[#mono[10111]], [#mono[0x17]],
    [24],[#mono[11000]], [#mono[0x18]],
    [25],[#mono[11001]], [#mono[0x19]],
    [26],[#mono[11010]], [#mono[0x1A]],
    [27],[#mono[11011]], [#mono[0x1B]],
    [28],[#mono[11100]], [#mono[0x1C]],
    [29],[#mono[11101]], [#mono[0x1D]],
    [30],[#mono[11110]], [#mono[0x1E]],
    [31],[#mono[11111]], [#mono[0x1F]],
  ),
)

#v(8pt)
#align(center)[
  #text(size: 7.5pt, fill: rgb("#888888"))[
    Number Systems Reference · Binary · Hexadecimal · Two's Complement · All arithmetic assumes fixed-width, two's complement unless stated
  ]
]
