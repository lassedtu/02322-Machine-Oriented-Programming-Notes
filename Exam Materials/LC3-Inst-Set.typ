#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2cm),
)

#set text(font: "New Computer Modern", size: 10pt)

#let accent = rgb("#1a3a5c")
#let accent-light = rgb("#e8f0f7")
#let row-alt = rgb("#f5f7fa")
#let border = rgb("#c0ccd8")

// Title block
#align(center)[
  #block(
    fill: accent,
    inset: (x: 24pt, y: 14pt),
    radius: 4pt,
    width: 100%,
  )[
    #text(fill: white, size: 18pt, weight: "bold")[LC-3 Instruction Set Reference]
    #linebreak()
    #text(fill: rgb("#aac4e0"), size: 9pt)[Little Computer 3 — 16-bit, 4-bit opcode, 8 general-purpose registers (R0–R7)]
  ]
]

#v(14pt)

// Legend
#block(
  fill: accent-light,
  stroke: (paint: border, thickness: 0.5pt),
  inset: 9pt,
  radius: 3pt,
  width: 100%,
)[
  #text(weight: "bold", size: 8.5pt)[Notation: ]
  #text(size: 8.5pt)[
    *DR* = Destination Register · *SR/SR1/SR2* = Source Register · *BaseR* = Base Register ·
    *Imm5* = 5-bit sign-extended immediate · *PCoffset9/11* = PC-relative offset ·
    *offset6* = 6-bit sign-extended offset · *trapvect8* = 8-bit trap vector ·
    *CC* = condition codes {n, z, p}
  ]
]

#v(10pt)

// Table helper
#let header-cell(content) = table.cell(
  fill: accent,
  align: center + horizon,
)[#text(fill: white, weight: "bold", size: 9pt)[#content]]

#let cat-cell(content) = table.cell(
  fill: rgb("#2c5f8a"),
  align: left + horizon,
  colspan: 6,
)[#text(fill: white, weight: "bold", size: 8.5pt)[#upper(content)]]

#let instr(name, op, fmt, ops, desc) = (
  table.cell(align: center)[#text(weight: "bold", font: "Courier New", size: 9.5pt)[#name]],
  table.cell(align: center)[#text(font: "Courier New", size: 9pt)[#op]],
  table.cell(align: center)[#box[#text(font: "Courier New", size: 7.2pt)[#fmt]]],
  table.cell(align: left)[#text(size: 8.5pt)[#ops]],
  table.cell(align: left)[#text(size: 8.5pt)[#desc]],
)

#table(
  columns: (auto, auto, 1.6fr, 1.1fr, 2.4fr),
  stroke: (paint: border, thickness: 0.5pt),
  inset: (x: 8pt, y: 6pt),
  fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },

  // Header
  header-cell[Mnemonic],
  header-cell[Opcode],
  header-cell[Format (bits 15–0)],
  header-cell[Operands],
  header-cell[Description],

  // ── Arithmetic & Logic ──────────────────────────────────────────────
  table.cell(colspan: 5, fill: rgb("#2c5f8a"))[
    #text(fill: white, weight: "bold", size: 8.5pt)[▸ ARITHMETIC & LOGIC]
  ],

  ..instr(
    "ADD",
    "0001",
    "0001|DR|SR1|0|00|SR2",
    "DR, SR1, SR2",
    "DR ← SR1 + SR2. Sets condition codes.",
  ),
  ..instr(
    "ADD",
    "0001",
    "0001|DR|SR1|1|Imm5",
    "DR, SR1, #imm5",
    "DR ← SR1 + SEXT(imm5). Sets condition codes.",
  ),
  ..instr(
    "AND",
    "0101",
    "0101|DR|SR1|0|00|SR2",
    "DR, SR1, SR2",
    "DR ← SR1 AND SR2. Sets condition codes.",
  ),
  ..instr(
    "AND",
    "0101",
    "0101|DR|SR1|1|Imm5",
    "DR, SR1, #imm5",
    "DR ← SR1 AND SEXT(imm5). Sets condition codes.",
  ),
  ..instr(
    "NOT",
    "1001",
    "1001|DR|SR|111111",
    "DR, SR",
    "DR ← bitwise NOT of SR. Sets condition codes.",
  ),

  // ── Memory ──────────────────────────────────────────────────────────
  table.cell(colspan: 5, fill: rgb("#2c5f8a"))[
    #text(fill: white, weight: "bold", size: 8.5pt)[▸ MEMORY ACCESS]
  ],

  ..instr(
    "LD",
    "0010",
    "0010|DR|PCoffset9",
    "DR, LABEL",
    "DR ← Mem[PC + SEXT(offset9)]. PC-relative load. Sets CC.",
  ),
  ..instr(
    "LDI",
    "1010",
    "1010|DR|PCoffset9",
    "DR, LABEL",
    "DR ← Mem[Mem[PC + SEXT(offset9)]]. Indirect load. Sets CC.",
  ),
  ..instr(
    "LDR",
    "0110",
    "0110|DR|BaseR|offset6",
    "DR, BaseR, #offset6",
    "DR ← Mem[BaseR + SEXT(offset6)]. Base+offset load. Sets CC.",
  ),
  ..instr(
    "LEA",
    "1110",
    "1110|DR|PCoffset9",
    "DR, LABEL",
    "DR ← PC + SEXT(offset9). Load effective address. Sets CC.",
  ),
  ..instr(
    "ST",
    "0011",
    "0011|SR|PCoffset9",
    "SR, LABEL",
    "Mem[PC + SEXT(offset9)] ← SR. PC-relative store.",
  ),
  ..instr(
    "STI",
    "1011",
    "1011|SR|PCoffset9",
    "SR, LABEL",
    "Mem[Mem[PC + SEXT(offset9)]] ← SR. Indirect store.",
  ),
  ..instr(
    "STR",
    "0111",
    "0111|SR|BaseR|offset6",
    "SR, BaseR, #offset6",
    "Mem[BaseR + SEXT(offset6)] ← SR. Base+offset store.",
  ),

  // ── Control Flow ────────────────────────────────────────────────────
  table.cell(colspan: 5, fill: rgb("#2c5f8a"))[
    #text(fill: white, weight: "bold", size: 8.5pt)[▸ CONTROL FLOW]
  ],

  ..instr(
    "BR",
    "0000",
    "0000|n|z|p|PCoffset9",
    "[n][z][p], LABEL",
    "If any specified CC is set: PC ← PC + SEXT(offset9). BRnzp = unconditional branch.",
  ),
  ..instr(
    "JMP",
    "1100",
    "1100|000|BaseR|000000",
    "BaseR",
    "PC ← BaseR. Unconditional jump to address in register.",
  ),
  ..instr(
    "RET",
    "1100",
    "1100|000|111|000000",
    "(none)",
    "PC ← R7. Return from subroutine (JMP R7 alias).",
  ),
  ..instr(
    "JSR",
    "0100",
    "0100|1|PCoffset11",
    "LABEL",
    "R7 ← PC; PC ← PC + SEXT(offset11). Jump to subroutine (PC-relative).",
  ),
  ..instr(
    "JSRR",
    "0100",
    "0100|0|00|BaseR|000000",
    "BaseR",
    "R7 ← PC; PC ← BaseR. Jump to subroutine (register).",
  ),

  // ── Trap / System ───────────────────────────────────────────────────
  table.cell(colspan: 5, fill: rgb("#2c5f8a"))[
    #text(fill: white, weight: "bold", size: 8.5pt)[▸ TRAP / SYSTEM]
  ],

  ..instr(
    "TRAP",
    "1111",
    "1111|0000|trapvect8",
    "trapvect8",
    "R7 ← PC; PC ← Mem[ZEXT(trapvect8)]. OS service call via trap vector table.",
  ),
  ..instr(
    "RTI",
    "1000",
    "1000|000000000000",
    "(none)",
    "Return from interrupt. Restores PC and PSR from supervisor stack. (Privileged)",
  ),
  ..instr(
    "reserved",
    "1101",
    "1101|————————————",
    "—",
    "Opcode 1101 is reserved (unused in base LC-3).",
  ),
)

#v(12pt)

// TRAP vector quick-ref
#block(
  fill: accent-light,
  stroke: (paint: border, thickness: 0.5pt),
  inset: 9pt,
  radius: 3pt,
  width: 100%,
)[
  #text(weight: "bold", size: 9pt)[Common TRAP Vectors (OS service routines)]
  #v(4pt)
  #table(
    columns: (auto, auto, 1fr),
    stroke: (paint: border, thickness: 0.5pt),
    inset: (x: 8pt, y: 5pt),
    fill: (_, row) => if row == 0 { accent } else if calc.odd(row) { white } else { row-alt },
    table.cell(fill: accent)[#text(fill: white, weight: "bold", size: 8.5pt)[Vector]],
    table.cell(fill: accent)[#text(fill: white, weight: "bold", size: 8.5pt)[Alias]],
    table.cell(fill: accent)[#text(fill: white, weight: "bold", size: 8.5pt)[Function]],
    [#text(font: "Courier New", size: 9pt)[x20]], [GETC],  [#text(size: 8.5pt)[Read one char from keyboard into R0 (no echo).]], 
    [#text(font: "Courier New", size: 9pt)[x21]], [OUT],   [#text(size: 8.5pt)[Write char in R0 to console.]],
    [#text(font: "Courier New", size: 9pt)[x22]], [PUTS],  [#text(size: 8.5pt)[Write null-terminated string starting at Mem[R0] to console.]],
    [#text(font: "Courier New", size: 9pt)[x23]], [IN],    [#text(size: 8.5pt)[Print prompt, read one char from keyboard into R0 (with echo).]],
    [#text(font: "Courier New", size: 9pt)[x24]], [PUTSP], [#text(size: 8.5pt)[Write packed string (two chars per word) starting at Mem[R0].]],
    [#text(font: "Courier New", size: 9pt)[x25]], [HALT],  [#text(size: 8.5pt)[Halt execution and print message to console.]],
  )
]

#v(6pt)
#align(center)[
  #text(size: 7.5pt, fill: rgb("#888888"))[
    LC-3 ISA · Patt & Patel, _Introduction to Computing Systems_ ·
    16-bit word · 16-bit address space (2¹⁶ locations) · Two's complement arithmetic
  ]
]

