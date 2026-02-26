// ─────────────────────────────────────────────────────────────
//  LC-3 Assembly Language Reference
// ─────────────────────────────────────────────────────────────

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2cm),
)

#set text(font: "New Computer Modern", size: 10pt)
#set par(leading: 5pt)

#let accent       = rgb("#1a3a5c")
#let accent2      = rgb("#2c5f8a")
#let accent-light = rgb("#e8f0f7")
#let row-alt      = rgb("#f5f7fa")
#let border       = rgb("#c0ccd8")
#let green-dark   = rgb("#1a4a2e")
#let green-light  = rgb("#e8f5ec")
#let code-bg      = rgb("#f0f4f8")

// ── Helpers ───────────────────────────────────────────────────

#let header-cell(content) = table.cell(
  fill: accent,
  align: center + horizon,
)[#text(fill: white, weight: "bold", size: 9pt)[#content]]

#let section-row(label) = table.cell(
  colspan: 10,   // wide enough for any table
  fill: accent2,
)[#text(fill: white, weight: "bold", size: 8.5pt)[▸ #upper(label)]]

#let sec(label) = table.cell(
  colspan: 4,
  fill: accent2,
)[#text(fill: white, weight: "bold", size: 8.5pt)[▸ #upper(label)]]

#let code(c) = text(font: "Courier New", size: 8.5pt)[#c]
#let codeS(c) = text(font: "Courier New", size: 7.8pt)[#c]

// inline comment style
#let comm(c) = text(fill: rgb("#5a7a5a"), font: "Courier New", size: 8pt)[; #c]

// A shaded code block
#let codeblock(content) = block(
  fill: code-bg,
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 10pt, y: 8pt),
  radius: 3pt,
  width: 100%,
)[#text(font: "Courier New", size: 8.2pt)[#content]]

// ── Title ─────────────────────────────────────────────────────

#align(center)[
  #block(
    fill: accent,
    inset: (x: 24pt, y: 14pt),
    radius: 4pt,
    width: 100%,
  )[
    #text(fill: white, size: 18pt, weight: "bold")[LC-3 Assembly Language Reference]
    #linebreak()
    #text(fill: rgb("#aac4e0"), size: 9pt)[
      Directives · Addressing · Condition Codes · Idioms · Subroutines · I/O · Stack
    ]
  ]
]

#v(12pt)

// ══════════════════════════════════════════════════════════════
//  1. PROGRAM STRUCTURE
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[1 — Program Structure]
]
#v(5pt)

Every LC-3 assembly file follows this skeleton:

#codeblock[
  #comm[set origin address — must be first statement]\
  .ORIG x3000\
  \
  #comm[your instructions here]\
  AND R0, R0, \#0    #comm[clear R0]\
  ADD R0, R0, \#5    #comm[R0 = 5]\
  HALT              #comm[alias for TRAP x25]\
  \
  #comm[data / string literals go after code]\
MSG .STRINGZ "Hello"\
NUM .FILL    \#-7\
BUF .BLKW   10    #comm[reserve 10 words]\
  \
  .END              #comm[marks end of source file (not execution!)]\
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  2. ASSEMBLER DIRECTIVES
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[2 — Assembler Directives (Pseudo-ops)]
]
#v(5pt)

#table(
  columns: (auto, auto, 1fr, 1.6fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Directive],
  header-cell[Syntax],
  header-cell[Effect],
  header-cell[Example],

  [#code[.ORIG]], [#code[.ORIG addr]],
  [Sets the load address for the program. *Must be first.*],
  [#code[.ORIG x3000]],

  [#code[.END]], [#code[.END]],
  [Marks end of assembly source. Required at bottom of file.],
  [#code[.END]],

  [#code[.FILL]], [#code[.FILL n]],
  [Allocates one word initialised to the value _n_ (decimal or hex).],
  [#code[N .FILL \#-1] \ #code[X .FILL x00FF]],

  [#code[.BLKW]], [#code[.BLKW n]],
  [Allocates _n_ consecutive zero-initialised words.],
  [#code[BUF .BLKW 50]],

  [#code[.STRINGZ]], [#code[.STRINGZ "text"]],
  [Stores ASCII string + null terminator (one char per word).],
  [#code[MSG .STRINGZ "OK"]],
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  3. ADDRESSING MODES
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[3 — Addressing Modes]
]
#v(5pt)

#table(
  columns: (auto, auto, 1fr, 1.4fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Mode],
  header-cell[Instructions],
  header-cell[Address computed as],
  header-cell[Example],

  [PC-relative], [#code[LD, ST, LDI, STI, LEA, BR, JSR]],
  [PC + SEXT(offset) — offset encoded in instruction bits],
  [#code[LD R1, DATA] \ #comm[EA = PC + offset9]],

  [Base + offset], [#code[LDR, STR]],
  [BaseR + SEXT(offset6) — flexible, register-based],
  [#code[LDR R1, R2, \#4] \ #comm[EA = R2 + 4]],

  [Indirect], [#code[LDI, STI]],
  [Mem[PC + offset9] gives the real address (two memory reads)],
  [#code[LDI R1, PTR] \ #comm[EA = Mem[PC+off]]],

  [Immediate], [#code[ADD, AND]],
  [Value is embedded directly in the instruction (5-bit, sign-extended)],
  [#code[ADD R0, R0, \#-1]],

  [Register], [#code[ADD, AND, NOT, JMP, JSRR]],
  [Value or address taken directly from a register],
  [#code[ADD R0, R1, R2] \ #code[JMP R6]],
)

#v(4pt)
#block(fill: accent-light, stroke: (paint: border, thickness: 0.5pt), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 8.5pt)[
    *PC during fetch:* The PC has already been incremented to point at the *next* instruction before the offset is applied. A label's offset is calculated by the assembler as `label_address − (instruction_address + 1)`.
  ]
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  4. CONDITION CODES
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[4 — Condition Codes (CC)]
]
#v(5pt)

#table(
  columns: (auto, 1fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Code], header-cell[Set when result is…],

  [#text(weight:"bold")[N]], [Negative — bit 15 = 1 (two's complement)],
  [#text(weight:"bold")[Z]], [Zero — all 16 bits = 0],
  [#text(weight:"bold")[P]], [Positive — bit 15 = 0 and value ≠ 0],
  table.cell(colspan: 2, fill: accent-light)[
    #text(size: 8.5pt)[*Exactly one* of N, Z, P is set after every instruction that writes to a register: ADD, AND, NOT, LD, LDI, LDR, LEA.]
  ],
)

#v(5pt)

*Branch mnemonics* — combine n/z/p to form the condition:

#table(
  columns: (auto, auto, 1fr, auto, auto, 1fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 7pt, y: 5pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Mnemonic], header-cell[Bits], header-cell[Branches if…],
  header-cell[Mnemonic], header-cell[Bits], header-cell[Branches if…],

  [#code[BRn]],   [n=1 z=0 p=0], [result < 0],
  [#code[BRzp]],  [n=0 z=1 p=1], [result ≥ 0],
  [#code[BRz]],   [n=0 z=1 p=0], [result = 0],
  [#code[BRnp]],  [n=1 z=0 p=1], [result ≠ 0],
  [#code[BRp]],   [n=0 z=0 p=1], [result > 0],
  [#code[BRnz]],  [n=1 z=1 p=0], [result ≤ 0],
  [#code[BRnzp]], [n=1 z=1 p=1], [always (unconditional)],
  [#code[BR]],    [n=1 z=1 p=1], [always (same as BRnzp)],
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  5. COMMON IDIOMS
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[5 — Common Assembly Idioms]
]
#v(5pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,

  // LEFT COLUMN
  stack(
    spacing: 8pt,

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Clear a register (set to 0)]
      #codeblock[AND R0, R0, \#0    #comm[R0 = 0]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Copy a register]
      #codeblock[AND R1, R1, \#0\
ADD R1, R1, R0    #comm[R1 = R0]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Negate a register (two's complement)]
      #codeblock[NOT R1, R0\
ADD R1, R1, \#1    #comm[R1 = -R0]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Subtract (R0 − R1 → R2)]
      #codeblock[NOT R1, R1\
ADD R1, R1, \#1    #comm[negate R1]\
ADD R2, R0, R1    #comm[R2 = R0 - R1]\
#comm[restore R1 if needed: NOT/ADD again]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Multiply by 2 (left shift by 1)]
      #codeblock[ADD R0, R0, R0    #comm[R0 = R0 × 2]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Load a large constant (> 5 bits)]
      #codeblock[LD  R0, CONST     #comm[load from .FILL]\
...\
CONST .FILL \#200  #comm[data section]]
    ],
  ),

  // RIGHT COLUMN
  stack(
    spacing: 8pt,

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[if (R0 == 0) goto LABEL]
      #codeblock[AND R0, R0, \#0    #comm[sets Z if R0=0]\
#comm[or: ADD R0, R0, \#0]\
BRz LABEL]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Compare R0 and R1 (if R0 < R1)]
      #codeblock[NOT R2, R1\
ADD R2, R2, \#1    #comm[R2 = -R1]\
ADD R2, R0, R2    #comm[R2 = R0-R1]\
BRn LABEL         #comm[branch if R0 < R1]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Counted loop (R1 = count)]
      #codeblock[LOOP ADD R1, R1, \#-1\
      BRp LOOP    #comm[repeat while R1 > 0]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Bitwise OR (no native OR instruction)]
      #codeblock[NOT R0, R0\
NOT R1, R1\
AND R2, R0, R1\
NOT R2, R2        #comm[R2 = A OR B (De Morgan)]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Array access  — Mem[base + i]]
      #codeblock[LEA R3, ARRAY     #comm[R3 = base addr]\
ADD R3, R3, R1    #comm[R3 += index i]\
LDR R0, R3, \#0   #comm[R0 = Mem[R3]]]
    ],

    block(fill: accent-light, stroke: (paint:border, thickness:0.5pt), inset:8pt, radius:3pt, width:100%)[
      #text(weight:"bold", size:8.5pt)[Unconditional jump to register]
      #codeblock[JMP R6            #comm[PC = R6]\
RET               #comm[PC = R7 (return)]]
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  6. SUBROUTINES & CALLING CONVENTION
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[6 — Subroutines & Calling Convention]
]
#v(5pt)

#table(
  columns: (auto, 1fr, 1.5fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Register], header-cell[Role (C convention)], header-cell[Notes],

  [#code[R0–R3]], [Scratch / argument passing],  [Caller-saved. May be clobbered by callee.],
  [#code[R4]],    [Global data base pointer],     [Points to global variable area.],
  [#code[R5]],    [Frame pointer (FP)],           [Points to callee's stack frame.],
  [#code[R6]],    [Stack pointer (SP)],           [Points to top of stack. Grows downward.],
  [#code[R7]],    [Return address (Link register)],[Auto-saved by JSR/JSRR/TRAP. *Save before nested calls.*],
)

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,

  stack(
    spacing: 4pt,
    [#text(weight:"bold", size:8.5pt)[Calling a subroutine]],
    codeblock[
#comm[save R7 if this is not a leaf]\
ST  R7, SAVE_R7\
\
JSR  MY_SUB    #comm[R7 ← PC; jump]\
#comm[execution resumes here after RET]\
\
LD  R7, SAVE_R7  #comm[restore R7]\
    ],
  ),

  stack(
    spacing: 4pt,
    [#text(weight:"bold", size:8.5pt)[Subroutine body]],
    codeblock[
MY_SUB\
  #comm[save any registers used]\
  ST  R0, SAVE0\
  \
  #comm[ ... do work ...]\
  \
  #comm[restore and return]\
  LD  R0, SAVE0\
  RET            #comm[PC = R7]
    ],
  ),
)

#v(4pt)
#block(fill: accent-light, stroke: (paint: border, thickness: 0.5pt), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 8.5pt)[
    *Stack push/pop (no native instructions):*
    #linebreak()
    Push R0: #h(4pt) #code[ADD R6, R6, \#-1] #h(6pt) then #h(6pt) #code[STR R0, R6, \#0]\
    #h(20pt)\
    Pop → R0: #h(4pt) #code[LDR R0, R6, \#0] #h(6pt) then #h(6pt) #code[ADD R6, R6, \#1]
  ]
]

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  7. TRAP / I/O ROUTINES
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[7 — TRAP Routines (I/O)]
]
#v(5pt)

#table(
  columns: (auto, auto, auto, 1fr, 1.5fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Alias], header-cell[Vector], header-cell[Usage], header-cell[Before call], header-cell[After call],

  [#code[GETC]],  [#code[x20]], [#code[TRAP x20]], [nothing],                                 [R0 = ASCII char (no echo)],
  [#code[OUT]],   [#code[x21]], [#code[TRAP x21]], [R0 = char to print],                      [char written to console],
  [#code[PUTS]],  [#code[x22]], [#code[TRAP x22]], [R0 = addr of null-terminated string],     [string printed to console],
  [#code[IN]],    [#code[x23]], [#code[TRAP x23]], [nothing],                                 [R0 = ASCII char (echoed, with prompt)],
  [#code[PUTSP]], [#code[x24]], [#code[TRAP x24]], [R0 = addr of packed string (2 char/word)],[string printed],
  [#code[HALT]],  [#code[x25]], [#code[TRAP x25]], [nothing],                                 [execution halts],
)

#v(6pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,

  stack(
    spacing: 4pt,
    [#text(weight:"bold", size:8.5pt)[Print a string]],
    codeblock[
LEA R0, MSG\
PUTS             #comm[TRAP x22 alias]\
HALT\
\
MSG .STRINGZ "Hello, World!"
    ],
  ),

  stack(
    spacing: 4pt,
    [#text(weight:"bold", size:8.5pt)[Read a char and echo it]],
    codeblock[
GETC             #comm[R0 = keystroke]\
OUT              #comm[echo back to screen]\
HALT
    ],
  ),
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  8. NUMBER FORMATS & LITERALS
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[8 — Number Formats & Literals]
]
#v(5pt)

#table(
  columns: (auto, auto, 1fr, 1fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  header-cell[Format], header-cell[Prefix], header-cell[Example], header-cell[Notes],

  [Decimal],     [#code[\#] or none], [#code[\#10]  #code[\#-7]],  [Sign-extended. Range for imm5: −16 to +15.],
  [Hexadecimal], [#code[x]],         [#code[x1FFF] #code[xFFFF]], [Always 16-bit. Use for addresses, masks.],
  [ASCII char],  [quotes in .STRINGZ],[#code["A"]],             [Stored as 16-bit word (upper byte = 0).],
)

#v(10pt)

// ══════════════════════════════════════════════════════════════
//  9. FULL EXAMPLE — sum an array
// ══════════════════════════════════════════════════════════════

#block(fill: accent2, inset: (x: 10pt, y: 6pt), radius: 3pt, width: 100%)[
  #text(fill: white, weight: "bold", size: 10pt)[9 — Annotated Example: Sum an Array]
]
#v(5pt)

#codeblock[
        .ORIG  x3000\
\
        #comm[── setup ──────────────────────────────────────────────]\
        AND    R0, R0, #0      #comm[R0 = accumulator = 0]\
        AND    R1, R1, #0      #comm[R1 = loop index  = 0]\
        LD     R2, LENGTH      #comm[R2 = array length (N)]\
        LEA    R3, ARRAY       #comm[R3 = pointer to ARRAY[0]]\
\
        #comm[── loop ───────────────────────────────────────────────]\
LOOP    LDR    R4, R3, #0      #comm[R4 = ARRAY[i]]\
        ADD    R0, R0, R4      #comm[accumulator += ARRAY[i]]\
        ADD    R3, R3, #1      #comm[advance pointer]\
        ADD    R2, R2, \#-1     #comm[decrement counter]\
        BRp    LOOP            #comm[if counter > 0, repeat]\
\
        #comm[── store result ─────────────────────────────────────────]\
        ST     R0, RESULT      #comm[save sum]\
        HALT\
\
        #comm[── data ────────────────────────────────────────────────]\
LENGTH  .FILL  \#5\
RESULT  .BLKW  1\
ARRAY   .FILL  \#10\
        .FILL  \#20\
        .FILL  \#30\
        .FILL  \#40\
        .FILL  \#50\
\
        .END
]

#v(8pt)
#align(center)[
  #text(size: 7.5pt, fill: rgb("#888888"))[
    LC-3 Assembly Reference · Patt & Patel, _Introduction to Computing Systems_ ·
    All values two's complement · 16-bit word · Address space x0000–xFFFF
  ]
]

