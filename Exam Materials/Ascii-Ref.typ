// ─────────────────────────────────────────────────────────────
//  ASCII Conversion Reference
// ─────────────────────────────────────────────────────────────

#set page(paper: "a4", margin: (x: 1.6cm, y: 1.8cm))
#set text(font: "New Computer Modern", size: 10pt)
#set par(leading: 4pt)

// ── Burgundy/wine palette ─────────────────────────────────────
#let accent       = rgb("#4a1528")   // deep burgundy
#let accent2      = rgb("#7a2540")   // medium burgundy
#let accent-light = rgb("#f5e8ec")   // pale rose tint
#let row-alt      = rgb("#fdf5f7")
#let border       = rgb("#d4a0b0")
#let code-bg      = rgb("#f9f0f3")
#let highlight    = rgb("#fff8e1")
#let hi-border    = rgb("#f0c040")
#let ctrl-fill    = rgb("#f0e8f5")   // purple tint for control chars
#let print-fill   = rgb("#f0f5e8")   // green tint for printable

// ── Helpers ──────────────────────────────────────────────────
#let hc(content) = table.cell(fill: accent, align: center + horizon)[
  #text(fill: white, weight: "bold", size: 8pt)[#content]
]
#let mono(c)  = text(font: "Courier New", size: 8pt)[#c]
#let monoS(c) = text(font: "Courier New", size: 7pt)[#c]

#let note(content) = block(
  fill: accent-light, stroke: (paint: border, thickness: 0.5pt),
  inset: 8pt, radius: 3pt, width: 100%,
)[#text(size: 8.5pt)[#content]]

#let key(content) = block(
  fill: highlight, stroke: (paint: hi-border, thickness: 0.5pt),
  inset: 8pt, radius: 3pt, width: 100%,
)[#text(size: 8.5pt)[#content]]

#let sectionbar(title) = block(
  fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%,
)[#text(fill: white, weight: "bold", size: 10pt)[#title]]

// ── Title ─────────────────────────────────────────────────────
#align(center)[
  #block(fill: accent, inset: (x: 24pt, y: 14pt), radius: 4pt, width: 100%)[
    #text(fill: white, size: 18pt, weight: "bold")[ASCII Conversion Reference]
    #linebreak()
    #text(fill: rgb("#e0a0b8"), size: 9pt)[
      Decimal · Hexadecimal · Binary · Character · Control codes · Key relationships
    ]
  ]
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  CONTROL CHARACTERS  (0x00 – 0x1F)
// ══════════════════════════════════════════════════════════════

#sectionbar[Control Characters (0x00 – 0x1F)  — non-printing]
#v(5pt)

#grid(columns: (1fr, 1fr), gutter: 8pt,

  table(
    columns: (auto, auto, auto, auto, auto),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 5pt, y: 3.5pt),
    fill: (col, row) => if row == 0 { accent } else if calc.odd(row) { white } else { ctrl-fill },
    hc[Dec], hc[Hex], hc[Binary], hc[Abbr], hc[Meaning],
    [0],  [#mono[00]], [#mono[0000 0000]], [#mono[NUL]], [Null],
    [1],  [#mono[01]], [#mono[0000 0001]], [#mono[SOH]], [Start of Heading],
    [2],  [#mono[02]], [#mono[0000 0010]], [#mono[STX]], [Start of Text],
    [3],  [#mono[03]], [#mono[0000 0011]], [#mono[ETX]], [End of Text],
    [4],  [#mono[04]], [#mono[0000 0100]], [#mono[EOT]], [End of Transmission],
    [5],  [#mono[05]], [#mono[0000 0101]], [#mono[ENQ]], [Enquiry],
    [6],  [#mono[06]], [#mono[0000 0110]], [#mono[ACK]], [Acknowledge],
    [7],  [#mono[07]], [#mono[0000 0111]], [#mono[BEL]], [Bell *(Ctrl+G)*],
    [8],  [#mono[08]], [#mono[0000 1000]], [#mono[BS]],  [Backspace *(Ctrl+H)*],
    [9],  [#mono[09]], [#mono[0000 1001]], [#mono[HT]],  [Horizontal Tab *(Ctrl+I)*],
    [10], [#mono[0A]], [#mono[0000 1010]], [#mono[LF]],  [Line Feed *(Ctrl+J)*],
    [11], [#mono[0B]], [#mono[0000 1011]], [#mono[VT]],  [Vertical Tab *(Ctrl+K)*],
    [12], [#mono[0C]], [#mono[0000 1100]], [#mono[FF]],  [Form Feed *(Ctrl+L)*],
    [13], [#mono[0D]], [#mono[0000 1101]], [#mono[CR]],  [Carriage Return *(Ctrl+M)*],
    [14], [#mono[0E]], [#mono[0000 1110]], [#mono[SO]],  [Shift Out],
    [15], [#mono[0F]], [#mono[0000 1111]], [#mono[SI]],  [Shift In],
  ),

  table(
    columns: (auto, auto, auto, auto, auto),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 5pt, y: 3.5pt),
    fill: (col, row) => if row == 0 { accent } else if calc.odd(row) { white } else { ctrl-fill },
    hc[Dec], hc[Hex], hc[Binary], hc[Abbr], hc[Meaning],
    [16], [#mono[10]], [#mono[0001 0000]], [#mono[DLE]], [Data Link Escape],
    [17], [#mono[11]], [#mono[0001 0001]], [#mono[DC1]], [Device Control 1 (XON)],
    [18], [#mono[12]], [#mono[0001 0010]], [#mono[DC2]], [Device Control 2],
    [19], [#mono[13]], [#mono[0001 0011]], [#mono[DC3]], [Device Control 3 (XOFF)],
    [20], [#mono[14]], [#mono[0001 0100]], [#mono[DC4]], [Device Control 4],
    [21], [#mono[15]], [#mono[0001 0101]], [#mono[NAK]], [Negative Acknowledge],
    [22], [#mono[16]], [#mono[0001 0110]], [#mono[SYN]], [Synchronous Idle],
    [23], [#mono[17]], [#mono[0001 0111]], [#mono[ETB]], [End of Transmission Block],
    [24], [#mono[18]], [#mono[0001 1000]], [#mono[CAN]], [Cancel],
    [25], [#mono[19]], [#mono[0001 1001]], [#mono[EM]],  [End of Medium],
    [26], [#mono[1A]], [#mono[0001 1010]], [#mono[SUB]], [Substitute],
    [27], [#mono[1B]], [#mono[0001 1011]], [#mono[ESC]], [Escape *(Ctrl+[)*],
    [28], [#mono[1C]], [#mono[0001 1100]], [#mono[FS]],  [File Separator],
    [29], [#mono[1D]], [#mono[0001 1101]], [#mono[GS]],  [Group Separator],
    [30], [#mono[1E]], [#mono[0001 1110]], [#mono[RS]],  [Record Separator],
    [31], [#mono[1F]], [#mono[0001 1111]], [#mono[US]],  [Unit Separator],
  ),
)

#v(8pt)

// ══════════════════════════════════════════════════════════════
//  PRINTABLE CHARACTERS  (0x20 – 0x7E)  +  DEL
// ══════════════════════════════════════════════════════════════

#sectionbar[Printable Characters (0x20 – 0x7F)]
#v(5pt)

#grid(columns: (1fr, 1fr, 1fr, 1fr), gutter: 6pt,

  // col 1: 0x20–0x3F
  table(
    columns: (auto, auto, auto, auto),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 5pt, y: 3pt),
    fill: (col, row) => if row == 0 { accent } else if calc.odd(row) { white } else { print-fill },
    hc[Dec], hc[Hex], hc[Bin], hc[Ch],
    [32], [#mono[20]], [#mono[010 0000]], [#mono[SPC]],
    [33], [#mono[21]], [#mono[010 0001]], [#mono[!]],
    [34], [#mono[22]], [#mono[010 0010]], [#mono["]],
    [35], [#mono[23]], [#mono[010 0011]], [#mono[\#]],
    [36], [#mono[24]], [#mono[010 0100]], [#text(font: "Courier New", size: 8pt)[\$]],
    [37], [#mono[25]], [#mono[010 0101]], [#mono[%]],
    [38], [#mono[26]], [#mono[010 0110]], [#text(font: "Courier New", size: 8pt)[&]],
    [39], [#mono[27]], [#mono[010 0111]], [#mono[']],
    [40], [#mono[28]], [#mono[010 1000]], [#mono[(]],
    [41], [#mono[29]], [#mono[010 1001]], [#mono[)]],
    [42], [#mono[2A]], [#mono[010 1010]], [#text(font: "Courier New", size: 8pt)[\*]],
    [43], [#mono[2B]], [#mono[010 1011]], [#mono[+]],
    [44], [#mono[2C]], [#mono[010 1100]], [#mono[,]],
    [45], [#mono[2D]], [#mono[010 1101]], [#mono[-]],
    [46], [#mono[2E]], [#mono[010 1110]], [#mono[.]],
    [47], [#mono[2F]], [#mono[010 1111]], [#mono[/]],
    [48], [#mono[30]], [#mono[011 0000]], [#mono[0]],
    [49], [#mono[31]], [#mono[011 0001]], [#mono[1]],
    [50], [#mono[32]], [#mono[011 0010]], [#mono[2]],
    [51], [#mono[33]], [#mono[011 0011]], [#mono[3]],
    [52], [#mono[34]], [#mono[011 0100]], [#mono[4]],
    [53], [#mono[35]], [#mono[011 0101]], [#mono[5]],
    [54], [#mono[36]], [#mono[011 0110]], [#mono[6]],
    [55], [#mono[37]], [#mono[011 0111]], [#mono[7]],
    [56], [#mono[38]], [#mono[011 1000]], [#mono[8]],
    [57], [#mono[39]], [#mono[011 1001]], [#mono[9]],
    [58], [#mono[3A]], [#mono[011 1010]], [#mono[:]],
    [59], [#mono[3B]], [#mono[011 1011]], [#mono[;]],
    [60], [#mono[3C]], [#mono[011 1100]], [#text(font: "Courier New", size: 8pt)[\<]],
    [61], [#mono[3D]], [#mono[011 1101]], [#mono[=]],
    [62], [#mono[3E]], [#mono[011 1110]], [#text(font: "Courier New", size: 8pt)[\>]],
    [63], [#mono[3F]], [#mono[011 1111]], [#mono[?]],
  ),

  // col 2: 0x40–0x5F
  table(
    columns: (auto, auto, auto, auto),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 5pt, y: 3pt),
    fill: (col, row) => if row == 0 { accent } else if calc.odd(row) { white } else { print-fill },
    hc[Dec], hc[Hex], hc[Bin], hc[Ch],
    [64], [#mono[40]], [#mono[100 0000]], [#text(font: "Courier New", size: 8pt)[\@]],
    [65], [#mono[41]], [#mono[100 0001]], [#mono[A]],
    [66], [#mono[42]], [#mono[100 0010]], [#mono[B]],
    [67], [#mono[43]], [#mono[100 0011]], [#mono[C]],
    [68], [#mono[44]], [#mono[100 0100]], [#mono[D]],
    [69], [#mono[45]], [#mono[100 0101]], [#mono[E]],
    [70], [#mono[46]], [#mono[100 0110]], [#mono[F]],
    [71], [#mono[47]], [#mono[100 0111]], [#mono[G]],
    [72], [#mono[48]], [#mono[100 1000]], [#mono[H]],
    [73], [#mono[49]], [#mono[100 1001]], [#mono[I]],
    [74], [#mono[4A]], [#mono[100 1010]], [#mono[J]],
    [75], [#mono[4B]], [#mono[100 1011]], [#mono[K]],
    [76], [#mono[4C]], [#mono[100 1100]], [#mono[L]],
    [77], [#mono[4D]], [#mono[100 1101]], [#mono[M]],
    [78], [#mono[4E]], [#mono[100 1110]], [#mono[N]],
    [79], [#mono[4F]], [#mono[100 1111]], [#mono[O]],
    [80], [#mono[50]], [#mono[101 0000]], [#mono[P]],
    [81], [#mono[51]], [#mono[101 0001]], [#mono[Q]],
    [82], [#mono[52]], [#mono[101 0010]], [#mono[R]],
    [83], [#mono[53]], [#mono[101 0011]], [#mono[S]],
    [84], [#mono[54]], [#mono[101 0100]], [#mono[T]],
    [85], [#mono[55]], [#mono[101 0101]], [#mono[U]],
    [86], [#mono[56]], [#mono[101 0110]], [#mono[V]],
    [87], [#mono[57]], [#mono[101 0111]], [#mono[W]],
    [88], [#mono[58]], [#mono[101 1000]], [#mono[X]],
    [89], [#mono[59]], [#mono[101 1001]], [#mono[Y]],
    [90], [#mono[5A]], [#mono[101 1010]], [#mono[Z]],
    [91], [#mono[5B]], [#mono[101 1011]], [#text(font: "Courier New", size: 8pt)[\[]],
    [92], [#mono[5C]], [#mono[101 1100]], [#mono[\\]],
    [93], [#mono[5D]], [#mono[101 1101]], [#mono[\]]],
    [94], [#mono[5E]], [#mono[101 1110]], [#mono[\^]],
    [95], [#mono[5F]], [#mono[101 1111]], [#text(font: "Courier New", size: 8pt)[\_]],
  ),

  // col 3: 0x60–0x7F
  table(
    columns: (auto, auto, auto, auto),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 5pt, y: 3pt),
    fill: (col, row) => if row == 0 { accent } else if calc.odd(row) { white } else { print-fill },
    hc[Dec], hc[Hex], hc[Bin], hc[Ch],
    [96],  [#mono[60]], [#mono[110 0000]], [#raw("`")],
    [97],  [#mono[61]], [#mono[110 0001]], [#mono[a]],
    [98],  [#mono[62]], [#mono[110 0010]], [#mono[b]],
    [99],  [#mono[63]], [#mono[110 0011]], [#mono[c]],
    [100], [#mono[64]], [#mono[110 0100]], [#mono[d]],
    [101], [#mono[65]], [#mono[110 0101]], [#mono[e]],
    [102], [#mono[66]], [#mono[110 0110]], [#mono[f]],
    [103], [#mono[67]], [#mono[110 0111]], [#mono[g]],
    [104], [#mono[68]], [#mono[110 1000]], [#mono[h]],
    [105], [#mono[69]], [#mono[110 1001]], [#mono[i]],
    [106], [#mono[6A]], [#mono[110 1010]], [#mono[j]],
    [107], [#mono[6B]], [#mono[110 1011]], [#mono[k]],
    [108], [#mono[6C]], [#mono[110 1100]], [#mono[l]],
    [109], [#mono[6D]], [#mono[110 1101]], [#mono[m]],
    [110], [#mono[6E]], [#mono[110 1110]], [#mono[n]],
    [111], [#mono[6F]], [#mono[110 1111]], [#mono[o]],
    [112], [#mono[70]], [#mono[111 0000]], [#mono[p]],
    [113], [#mono[71]], [#mono[111 0001]], [#mono[q]],
    [114], [#mono[72]], [#mono[111 0010]], [#mono[r]],
    [115], [#mono[73]], [#mono[111 0011]], [#mono[s]],
    [116], [#mono[74]], [#mono[111 0100]], [#mono[t]],
    [117], [#mono[75]], [#mono[111 0101]], [#mono[u]],
    [118], [#mono[76]], [#mono[111 0110]], [#mono[v]],
    [119], [#mono[77]], [#mono[111 0111]], [#mono[w]],
    [120], [#mono[78]], [#mono[111 1000]], [#mono[x]],
    [121], [#mono[79]], [#mono[111 1001]], [#mono[y]],
    [122], [#mono[7A]], [#mono[111 1010]], [#mono[z]],
    [123], [#mono[7B]], [#mono[111 1011]], [#text(font: "Courier New", size: 8pt)[\{]],
    [124], [#mono[7C]], [#mono[111 1100]], [#text(font: "Courier New", size: 8pt)[|]],
    [125], [#mono[7D]], [#mono[111 1101]], [#text(font: "Courier New", size: 8pt)[\}]],
    [126], [#mono[7E]], [#mono[111 1110]], [#mono[\~]],
    [127], [#mono[7F]], [#mono[111 1111]], [#mono[DEL]],
  ),

  // col 4: key facts
  stack(spacing: 8pt,

    block(fill: highlight, stroke:(paint:hi-border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Key Relationships]
      #v(5pt)
      #text(size:8pt)[
        *Digits 0–9:*\
        Hex #mono[0x30]–#mono[0x39]\
        To digit: #mono[char AND 0x0F]\
        To ASCII: #mono[digit OR 0x30]
      ]
      #v(5pt)
      #text(size:8pt)[
        *A–Z: #mono[0x41]–#mono[0x5A]*\
        *a–z: #mono[0x61]–#mono[0x7A]*\
        Differ by *bit 5* only:\
        #mono[0x20] = #mono[0010 0000]
      ]
      #v(5pt)
      #text(size:8pt)[
        Upper→lower:\
        #mono[char OR 0x20]\
        Lower→upper:\
        #mono[char AND 0xDF]\
        Toggle case:\
        #mono[char XOR 0x20]
      ]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Control Char Trick]
      #v(4pt)
      #text(size:8pt)[
        Ctrl+key = key code\
        *AND 0x1F*\
        e.g. Ctrl+G:\
        #mono['G'=0x47]\
        #mono[0x47 AND 0x1F]\
        #mono[= 0x07 = BEL]
      ]
    ],

    block(fill: accent-light, stroke:(paint:border,thickness:.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Range Summary]
      #v(4pt)
      #table(columns:(auto, auto),
        stroke:(paint:border,thickness:.5pt),
        inset:(x:5pt, y:3pt),
        fill:(col,row)=>if row==0{accent} else if calc.odd(row){white} else {row-alt},
        hc[Hex], hc[Contents],
        [#mono[00–1F]], [Control chars],
        [#mono[20–2F]], [Punctuation],
        [#mono[30–39]], [0 – 9],
        [#mono[3A–40]], [Punctuation],
        [#mono[41–5A]], [A – Z],
        [#mono[5B–60]], [Punctuation],
        [#mono[61–7A]], [a – z],
        [#mono[7B–7E]], [Punctuation],
        [#mono[7F]],    [DEL],
      )
    ],
  ),
)

#v(8pt)
#align(center)[
  #text(size: 7.5pt, fill: rgb("#888888"))[
    ASCII (American Standard Code for Information Interchange) · 7-bit code · 128 characters (0–127) · High bit always 0 in standard ASCII
  ]
]
