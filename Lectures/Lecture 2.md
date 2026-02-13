# Von Neumann Model

## Overview

The **Von Neumann Model**, proposed by John von Neumann in 1946, is a fundamental architectural model for modern computers.

![[von-n.jpg | center |600 ]]

## Core Components

The Von Neumann Model consists of five main components:

| Component | Function |
|-----------|----------|
| **Memory Unit** | Stores both data and program instructions during execution |
| **Control Unit** | Manages instruction fetching from memory and execution coordination |
| **Processing Unit (ALU)** | Transforms data; includes logic circuits and temporary storage |
| **Input Device** | Receives data from external sources (keyboard, mouse, scanner, disk) |
| **Output Device** | Sends processed data to the external environment |

## The CPU

The **Central Processing Unit (CPU)** combines two key components:
- **Processing Unit** (Arithmetic/Logic Unit - ALU)
- **Control Unit**

---

# Computer Architecture Components

## Memory

**Memory** stores both data and program instructions during execution. It is characterized by two key properties:

### Key Properties

- **Address Space**: The total number of unique memory locations. If there are $2^n$ locations, an $n$-bit address is required to access them.
- **Addressability**: The number of bits stored in each memory location.

### Memory Operations

| Operation | Description |
|-----------|-------------|
| **LOAD** | Transfers data from memory to the CPU |
| **STORE** | Transfers data from the CPU to memory |

![[memory-diagram-1.png | center | 200]]

### Memory Interface

![[memory-diagram-2.png | center | 400]]

Access to memory is managed through two key registers:

- **MAR (Memory Address Register)**: Holds the address of the memory location to be accessed
- **MDR (Memory Data Register)**: Temporarily stores data being read from or written to memory

#### LOAD Procedure

To transfer data **from memory to the CPU**:

1. CPU writes the desired memory address into the **MAR**
2. A **"read" signal** is sent to memory
3. Data from that memory address is placed into the **MDR**, where the CPU can read it

#### STORE Procedure

To transfer data **from the CPU to memory**:

1. CPU writes the target memory address into the **MAR**
2. CPU writes the data to be stored into the **MDR**
3. A **"write" signal** is sent to memory, transferring data from the MDR to the specified address

## Processing Unit (ALU)

![[processing-unit-diagram-1.png | center | 400]]

The **Processing Unit**, also known as the **Arithmetic/Logic Unit (ALU)**, is responsible for transforming data within the computer.

### Components

The ALU consists of:

- **Functional Units**: Perform data transformations such as:
  - Arithmetic operations (add, subtract, multiply)
  - Logical operations (AND, OR, NOT)
- **Registers**: Provide temporary storage for data during processing

### Word Length

**Word Length** refers to the number of bits the ALU processes at one time. Common word lengths include:

- **64 bits** (e.g., Intel Core)
- **32 bits** (e.g., Intel Atom)
- **16 bits** (e.g., LC-3)

## Control Unit

![[control-unit-diagram-1.png | center | 400]]

The **Control Unit** orchestrates the entire computer to carry out program instructions. It manages the flow of data and the execution of operations.

Key registers within the Control Unit include:

-   **Instruction Register (IR)**: Holds the current instruction being executed.
-   **Program Counter (PC)**: Holds the memory address of the next instruction to be executed. It acts as a "pointer" to the next instruction's location in memory.

---

# Instructions and the Instruction Cycle

## What is an Instruction?

A **computer instruction** is a binary value that specifies a single operation to be carried out by the hardware. Instructions are composed of various bit fields that encode their components.

Key characteristic: An instruction is the **fundamental unit of work**—once execution begins, it will complete its specified task.

### Instruction Components

Each instruction consists of:

- **Opcode**: Specifies the operation to be performed (e.g., ADD, AND)
- **Operands**: Specifies the data to be used during the operation

---

## Types of Instructions

Computer instructions are categorized based on the operations they specify:

### Operate Instructions

Perform data transformations. They take data as input, process it, and produce a result.

**Examples**: `ADD`, `AND`, `NOT`, `MULTIPLY`, `SHIFT`

### Data Movement Instructions

Facilitate the transfer of data between different locations in the computer system.

**Examples**: 
- `LOAD` — move data from memory to CPU register
- `STORE` — move data from CPU register to memory

### Control Instructions

Determine the sequence in which other instructions are executed, altering the normal flow of a program.

**Examples**: `JUMP`, `BRANCH`, `CALL`, `RETURN`

---

## The Instruction Cycle

The execution of every instruction follows a fundamental sequence of steps known as the **instruction cycle**. This cycle is continuously orchestrated by the **Control Unit**.

![[instruction-cycle.webp | center | 400]]

### Stages of the Instruction Cycle

| **Stage** | **Description** | **Details** |
|-----------|-----------------|------------|
| **Fetch** | Read the next instruction from memory | Address obtained from the Program Counter (PC) |
| **Decode** | Interpret the instruction | Determine which operation to perform |
| **Execute** | Perform the specified operation | Move or transform data as specified |
| **Update PC** | Prepare for next instruction | Increment PC (or modify it for control instructions) |

> **Note**: Each stage may require one or more clock cycles to complete.

---

## Detailed Instruction Processing

### Fetch Stage

The **Fetch** stage retrieves the next instruction from memory:

1. The **Program Counter (PC)** contains the address of the instruction to fetch
2. The **Control Unit** writes the PC value into the **MAR** to access that memory location
3. The PC is incremented to point to the next consecutive memory location
4. The instruction is retrieved via the **MDR** and copied into the **Instruction Register (IR)**

### Decode Stage

The **Decode** stage interprets the instruction:

1. Once the instruction is in the **IR**, the Control Unit examines the **opcode**
2. A decoder sets appropriate control signals based on the opcode
3. The opcode also determines how remaining instruction bits are interpreted

**Example**: In the `ADD` instruction with opcode `0001`, bits `[8:6]` specify the first operand register

### Execute Stage

The **Execute** stage breaks down into substeps that process and complete the instruction:

| **Substep** | **Action** |
|---|---|
| Evaluate Address | Determine which address to load from or store to (if needed) |
| Fetch Operands | Retrieve data values from registers and/or memory |
| Execute | Perform the necessary operations (add, AND, etc.) |
| Store Result | Write the result to a register or to memory |

> **Note**: Not every substep applies to every instruction. For example, memory-independent instructions skip the "Evaluate Address" step.

---

# LC-3: A Concrete Example

The **LC-3** is a simplified but realistic processor architecture designed to illustrate fundamental computer organization principles. It adheres to the Von Neumann model.

![[LC-3-diagram.png | center | 400]]

## Key Characteristics

| Characteristic | Specification |
|---|---|
| **Memory** | $2^{16}$ locations with 16 bits per location |
| **ALU Operations** | ADD, AND, NOT |
| **Word Length** | 16 bits |
| **Instruction Length** | 16 bits |

---

## LC-3 Instruction Set Architecture (ISA)

The **Instruction Set Architecture** specifies everything about the computer that is visible to the programmer.

![[lc3-inst-set.png | center | 600]]

### ISA Definition Components

#### Memory Organization
- **$2^{16}$ memory locations** each storing **16 bits**
- Supports 16-bit address space

#### Registers
- **8 general-purpose registers** (R0 through R7)
- Each register is **16 bits** wide
- Used as source and destination for instruction operands

#### Instructions
- **15 opcodes** specified by **4-bit codes** (up to 16 possible operations)
- **Single data type**: 16-bit 2's complement integers
- **Multiple addressing modes**: Various encodings specify operand locations

#### Condition Codes
- **Three 1-bit registers** (N, Z, P) set whenever a value is written to a register
- Used for conditional branching:

| **Code** | **Meaning** |
|---|---|
| **N** | Negative (result is negative) |
| **Z** | Zero (result is zero) |
| **P** | Positive (result is positive) |

---

## LC-3 Instruction Format

All LC-3 instructions are 16 bits long with a standardized format:

- **Opcode** (bits 15–12): A 4-bit identifier specifying which operation to perform
- **Operand specifiers**: Remaining bits specify registers and addressing modes

Since each register requires 3 bits to specify (for 8 registers), operands are encoded efficiently within the remaining 12 bits.

### Notation and Abbreviations

The following notation is used in LC-3 instruction descriptions:

| **Abbreviation** | **Meaning** |
|---|---|
| **SR** | Source register |
| **DR** | Destination register |
| **BaseR** | Base register |
| **imm**N | Immediate value, N bits long |
| **offset**N, **PCoffset**N | Offset to be added to BaseR or PC, N bits |
| **trapvector8** | Index into TRAP table, 8 bits |

### Addressing Modes

Addressing modes specify how operands are located within an instruction.

#### Register Addressing
- The first operand is always specified by a register
- If `IR[5] = 0`, the second operand is also a register

#### Immediate Addressing
- If `IR[5] = 1`, the second operand is specified directly in the instruction
- `IR[4:0]` contains a **5-bit 2's complement integer**
- This value is **sign-extended to 16 bits** for use in the operation

---

# LC-3 Microarchitecture

The **microarchitecture** is the physical hardware implementation of the instruction set. It translates abstract instructions into actual computational behavior.

## Overview

The LC-3 microarchitecture comprises:

- **Functional units** (ALU, gates, multiplexers)
- **Storage elements** (registers, memory)
- **Control logic** (signal generation)
- **Data paths** (connections between components)

## Key Design Principle: Component Reuse

A critical aspect of processor design is **reusing hardware components**. Many different instructions utilize the same functional units, memory interfaces, and data pathways.

### Benefits
- **Reduced hardware cost**: Fewer unique circuits needed
- **Simplified design**: Fewer distinct control signals to manage
- **Efficient silicon use**: Components utilized across multiple instructions

### Example
The **ALU** is shared among ADD, AND, and NOT instructions. Each instruction routes its operands through the same physical ALU, but with different control signals determining the operation (add, AND, or NOT).

---

# LC-3 Instruction Examples with Bit Layouts

This section provides detailed examples of LC-3 instructions with complete bit layouts, showing exactly how operands are encoded.

## Operate Instructions

Operate instructions perform data transformations on register values and set condition codes.

### ADD — Add Integers

**Purpose**: Add two integers and write the result to a register. Sets condition codes (N, Z, P).

#### Register Mode (IR[5] = 0)

Add the contents of two registers and store the result in a destination register.

| **Field**  | `ADD` | `DR` | `SR1` | `0` | `00` | `SR2` |
|---|---|---|---|---|---|---|
| **Value**  | `0001` | `110` | `010` | `0` | `00` | `110` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5 | 4–3 | 2–0 |

**Instruction**: `0001110010000110`

**Explanation**:
- **Opcode**: `0001` (ADD operation)
- **DR**: `110` (R6) — destination register
- **SR1**: `010` (R2) — first source register
- **SR2**: `110` (R6) — second source register
- **Operation**: R6 ← R2 + R6

#### Immediate Mode (IR[5] = 1)

Add the contents of a register to a 5-bit signed immediate value.

| **Field**  | `ADD` | `DR` | `SR1` | `1` | `Imm5` |
|---|---|---|---|---|---|
| **Value**  | `0001` | `101` | `011` | `1` | `00111` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5 | 4–0 |

**Instruction**: `0001101011100111`

**Explanation**:
- **Opcode**: `0001` (ADD operation)
- **DR**: `101` (R5) — destination register
- **SR1**: `011` (R3) — source register
- **Imm5**: `00111` (7 in decimal) — immediate value, sign-extended to 16 bits
- **Operation**: R5 ← R3 + 7

---

### AND — Bitwise AND

**Purpose**: Perform bitwise AND of two values and write the result to a register. Sets condition codes (N, Z, P).

#### Register Mode (IR[5] = 0)

Perform bitwise AND of two registers and store in destination.

| **Field**  | `AND` | `DR` | `SR1` | `0` | `00` | `SR2` |
|---|---|---|---|---|---|---|
| **Value**  | `0101` | `010` | `100` | `0` | `00` | `111` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5 | 4–3 | 2–0 |

**Instruction**: `0101010100000111`

**Explanation**:
- **Opcode**: `0101` (AND operation)
- **DR**: `010` (R2) — destination register
- **SR1**: `100` (R4) — first source register
- **SR2**: `111` (R7) — second source register
- **Operation**: R2 ← R4 AND R7

#### Immediate Mode (IR[5] = 1)

Perform bitwise AND of a register with a 5-bit immediate value.

| **Field**  | `AND` | `DR` | `SR1` | `1` | `Imm5` |
|---|---|---|---|---|---|
| **Value**  | `0101` | `001` | `010` | `1` | `11111` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5 | 4–0 |

**Instruction**: `0101001010111111`

**Explanation**:
- **Opcode**: `0101` (AND operation)
- **DR**: `001` (R1) — destination register
- **SR1**: `010` (R2) — source register
- **Imm5**: `11111` (−1 in 5-bit 2's complement) — immediate value
- **Operation**: R1 ← R2 AND (−1) = R2

---

### NOT — Bitwise NOT

**Purpose**: Perform bitwise NOT on a register and write the result to a destination register. Sets condition codes (N, Z, P).

| **Field**  | `NOT` | `DR` | `SR` | `1` | `11111` |
|---|---|---|---|---|---|
| **Value**  | `1001` | `011` | `101` | `1` | `11111` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5 | 4–0 |

**Instruction**: `1001011101111111`

**Explanation**:
- **Opcode**: `1001` (NOT operation)
- **DR**: `011` (R3) — destination register
- **SR**: `101` (R5) — source register
- **Bits [5:0]**: Always set to `111111` (reserved bits)
- **Operation**: R3 ← NOT(R5)

---

### LEA — Load Effective Address

**Purpose**: Add an offset to the PC and load the effective address into a register. Does NOT set condition codes.

| **Field**  | `LEA` | `DR` | `PCoffset9` |
|---|---|---|---|
| **Value**  | `1110` | `010` | `101010101` |
| **Bits**   | 15–12 | 11–9 | 8–0 |

**Instruction**: `1110010101010101`

**Explanation**:
- **Opcode**: `1110` (LEA operation)
- **DR**: `010` (R2) — destination register
- **PCoffset9**: `101010101` (341 unsigned, −171 signed) — 9-bit signed offset
- **Operation**: R2 ← PC + sign_extend(PCoffset9)
- **Use case**: Loading addresses of data or code locations

---

## Data Movement Instructions

Instructions that transfer data between memory and CPU registers.

### LD — Load (PC Relative)

**Purpose**: Load a word from memory into a register. Sets condition codes (N, Z, P).

| **Field**  | `LD` | `DR` | `PCoffset9` |
|---|---|---|---|
| **Value**  | `0010` | `011` | `000001010` |
| **Bits**   | 15–12 | 11–9 | 8–0 |

**Instruction**: `0010011000001010`

**Explanation**:
- **Opcode**: `0010` (LD operation)
- **DR**: `011` (R3) — destination register
- **PCoffset9**: `000001010` (10 in decimal) — 9-bit signed offset
- **Operation**: R3 ← M[PC + sign_extend(PCoffset9)]
- **Address calculation**: Load from offset relative to current PC

---

### LDI — Load Indirect

**Purpose**: Load a word from memory using an indirect address. Sets condition codes (N, Z, P).

| **Field**  | `LDI` | `DR` | `PCoffset9` |
|---|---|---|---|
| **Value**  | `1010` | `100` | `000010000` |
| **Bits**   | 15–12 | 11–9 | 8–0 |

**Instruction**: `1010100000010000`

**Explanation**:
- **Opcode**: `1010` (LDI operation)
- **DR**: `100` (R4) — destination register
- **PCoffset9**: `000010000` (16 in decimal) — 9-bit signed offset
- **Operation**: R4 ← M[M[PC + sign_extend(PCoffset9)]]
- **Two-step process**: 
  1. Calculate address: addr1 = PC + 16
  2. Load the address from that location: addr2 = M[addr1]
  3. Load data from addr2: R4 = M[addr2]

---

### LDR — Load Register

**Purpose**: Load a word from memory into a register using base address + offset. Sets condition codes (N, Z, P).

| **Field**  | `LDR` | `DR` | `BaseR` | `offset6` |
|---|---|---|---|---|
| **Value**  | `0110` | `001` | `010` | `000101` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5–0 |

**Instruction**: `0110001010000101`

**Explanation**:
- **Opcode**: `0110` (LDR operation)
- **DR**: `001` (R1) — destination register
- **BaseR**: `010` (R2) — base register containing starting address
- **offset6**: `000101` (5 in decimal) — 6-bit signed offset
- **Operation**: R1 ← M[R2 + sign_extend(offset6)]
- **Address calculation**: Base address in register plus small offset

---

### ST — Store (PC Relative)

**Purpose**: Store a word from a register into memory. Does NOT set condition codes.

| **Field**  | `ST` | `SR` | `PCoffset9` |
|---|---|---|---|
| **Value**  | `0011` | `010` | `000000100` |
| **Bits**   | 15–12 | 11–9 | 8–0 |

**Instruction**: `0011010000000100`

**Explanation**:
- **Opcode**: `0011` (ST operation)
- **SR**: `010` (R2) — source register containing value to store
- **PCoffset9**: `000000100` (4 in decimal) — 9-bit signed offset
- **Operation**: M[PC + sign_extend(PCoffset9)] ← R2
- **Address calculation**: Store at address offset relative to current PC

---

### STI — Store Indirect

**Purpose**: Store a word to memory using an indirect address. Does NOT set condition codes.

| **Field**  | `STI` | `SR` | `PCoffset9` |
|---|---|---|---|
| **Value**  | `1011` | `101` | `000000110` |
| **Bits**   | 15–12 | 11–9 | 8–0 |

**Instruction**: `1011101000000110`

**Explanation**:
- **Opcode**: `1011` (STI operation)
- **SR**: `101` (R5) — source register containing value to store
- **PCoffset9**: `000000110` (6 in decimal) — 9-bit signed offset
- **Operation**: M[M[PC + sign_extend(PCoffset9)]] ← R5
- **Two-step process**: 
  1. Calculate address: addr1 = PC + 6
  2. Load the destination address: addr2 = M[addr1]
  3. Store value: M[addr2] = R5

---

### STR — Store Register

**Purpose**: Store a word from a register into memory using base address + offset. Does NOT set condition codes.

| **Field**  | `STR` | `SR` | `BaseR` | `offset6` |
|---|---|---|---|---|
| **Value**  | `0111` | `011` | `100` | `000010` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5–0 |

**Instruction**: `0111011100000010`

**Explanation**:
- **Opcode**: `0111` (STR operation)
- **SR**: `011` (R3) — source register containing value to store
- **BaseR**: `100` (R4) — base register containing starting address
- **offset6**: `000010` (2 in decimal) — 6-bit signed offset
- **Operation**: M[R4 + sign_extend(offset6)] ← R3
- **Address calculation**: Base address in register plus small offset

---

## Control Instructions

Instructions that alter the normal flow of program execution, enabling branching and subroutine calls.

### BR — Conditional Branch

**Purpose**: Branch to a nearby location if condition codes match specified flags. Does NOT set condition codes.

| **Field**  | `BR` | `n` | `z` | `p` | `PCoffset9` |
|---|---|---|---|---|---|
| **Value**  | `0000` | `0` | `1` | `1` | `000010000` |
| **Bits**   | 15–12 | 11 | 10 | 9 | 8–0 |

**Instruction**: `0000011000010000`

**Explanation**:
- **Opcode**: `0000` (BR operation)
- **n flag** (bit 11): `0` — Branch on negative (NOT included)
- **z flag** (bit 10): `1` — Branch on zero (INCLUDED)
- **p flag** (bit 9): `1` — Branch on positive (INCLUDED)
- **PCoffset9**: `000010000` (16 in decimal) — 9-bit signed offset
- **Operation**: If (n and N) or (z and Z) or (p and P), then PC ← PC + sign_extend(PCoffset9)
- **Example**: This instruction branches if result is zero OR positive

**Common Variants**:
- **BRz**: Zero only (n=0, z=1, p=0)
- **BRp**: Positive only (n=0, z=0, p=1)
- **BRn**: Negative only (n=1, z=0, p=0)
- **BRnzp**: Always branch (n=1, z=1, p=1)

---

### JMP — Jump

**Purpose**: Unconditionally jump to an address stored in a register. Does NOT set condition codes.

| **Field**  | `JMP` | Reserved | `BaseR` | Reserved |
|---|---|---|---|---|---|
| **Value**  | `1100` | `000` | `010` | `000000` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5–0 |

**Instruction**: `1100000010000000`

**Explanation**:
- **Opcode**: `1100` (JMP operation)
- **BaseR**: `010` (R2) — register containing target address
- **Operation**: PC ← R2
- **Use case**: Returns from procedures when return address is in a register

---

### JSR — Jump to Subroutine

**Purpose**: Jump to a nearby subroutine and save return address. Does NOT set condition codes.

| **Field**  | `JSR` | Reserved | `PCoffset11` |
|---|---|---|---|
| **Value**  | `0100` | `1` | `00000001010` |
| **Bits**   | 15–12 | 11 | 10–0 |

**Instruction**: `0100100000001010`

**Explanation**:
- **Opcode**: `0100` (JSR operation)
- **Bit 11**: `1` — Indicates PC-relative addressing (not register-based)
- **PCoffset11**: `00000001010` (10 in decimal) — 11-bit signed offset
- **Operation**: 
  1. R7 ← PC (save return address)
  2. PC ← PC + sign_extend(PCoffset11)
- **Return mechanism**: Use RET to jump back to saved address
- **Use case**: Call to subroutine at a nearby location

---

### JSRR — Jump to Subroutine using Register

**Purpose**: Jump to a subroutine at an address in a register and save return address. Does NOT set condition codes.

| **Field**  | `JSRR` | Reserved | `BaseR` | Reserved |
|---|---|---|---|---|---|
| **Value**  | `0100` | `0` | `011` | `000000` |
| **Bits**   | 15–12 | 11 | 8–6 | 5–0 |

**Instruction**: `0100000011000000`

**Explanation**:
- **Opcode**: `0100` (JSRR operation)
- **Bit 11**: `0` — Indicates register-based addressing (not PC-relative)
- **BaseR**: `011` (R3) — register containing target address
- **Operation**: 
  1. R7 ← PC (save return address)
  2. PC ← R3
- **Return mechanism**: Use RET to jump back to saved address
- **Use case**: Call to subroutine at address in a register

---

### RET — Return from Subroutine

**Purpose**: Return from a subroutine by jumping to address in R7. Does NOT set condition codes.

| **Field**  | `RET` | Reserved | Reserved | Reserved |
|---|---|---|---|---|---|
| **Value**  | `1100` | `000` | `111` | `000000` |
| **Bits**   | 15–12 | 11–9 | 8–6 | 5–0 |

**Instruction**: `1100000111000000`

**Explanation**:
- **Opcode**: `1100` (same as JMP)
- **BaseR**: `111` (R7) — always uses R7 (return address register)
- **Operation**: PC ← R7
- **Typical flow**: 
  1. JSR/JSRR saves return address to R7
  2. Subroutine executes
  3. RET restores PC from R7, returning to caller

---

### RTI — Return from Interrupt

**Purpose**: Return from an interrupt handler and restore the processor state. Does NOT set condition codes.

| **Field**  | `RTI` | Reserved |
|---|---|---|
| **Value**  | `1000` | `000000000000` |
| **Bits**   | 15–12 | 11–0 |

**Instruction**: `1000000000000000`

**Explanation**:
- **Opcode**: `1000` (RTI operation)
- **Reserved bits**: All other bits are unused
- **Operation**: 
  1. PC ← M[R6] (restore program counter from stack)
  2. PSW ← M[R6+1] (restore processor status word)
  3. R6 ← R6+2 (adjust stack pointer)
- **Use case**: Return from interrupt/exception handlers (privileged instruction)
- **Effect**: Restores previous privilege level and priority

---

### TRAP — Trap / System Call

**Purpose**: Call a system routine identified by an 8-bit trap vector. Does NOT set condition codes.

| **Field**  | `TRAP` | Reserved | `trapvector8` |
|---|---|---|---|
| **Value**  | `1111` | `0000` | `00100101` |
| **Bits**   | 15–12 | 11–8 | 7–0 |

**Instruction**: `1111000000100101`

**Explanation**:
- **Opcode**: `1111` (TRAP operation)
- **trapvector8**: `00100101` (37 in decimal) — 8-bit index into TRAP vector table
- **Operation**: 
  1. R7 ← PC (save return address)
  2. PC ← M[trapvector8] (jump to system routine)
- **Return mechanism**: System routine executes RET to return to caller

**Common TRAP Vectors** (typical LC-3 implementation):

| Vector | Hex | Function |
|---|---|---|
| 0 | `0x20` | GETC — read character from keyboard |
| 1 | `0x21` | OUT — write character to console |
| 2 | `0x22` | PUTS — write string to console |
| 3 | `0x23` | IN — read character and echo |
| 4 | `0x24` | PUTSP — write packed string |
| 5 | `0x25` | HALT — stop program execution |

**Note**: TRAP switches to privileged mode for system routine execution