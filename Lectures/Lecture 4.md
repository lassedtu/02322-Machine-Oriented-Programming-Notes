# Debugging

## What is Debugging?

A **bug** is a computer error. **Debugging** is the process of finding and removing errors from a program.

### How Do You Know There's a Bug?

**1. Testing with Known Inputs**
- Run the program with data where you already know the correct answer
- Compare the program's output with the expected result
- If they don't match, there's a bug
- **Important:** Test with a variety of inputs (large numbers, small numbers, negative numbers, zero, etc.) because program behavior changes with different data

**2. Observable Incorrect Behavior**
- Program runs forever and never halts
- Desired output is never displayed
- Program crashes or behaves unexpectedly
- Results are obviously wrong

## Basic Debugging Strategy

### Step 1: Trace the Program

**Tracing** means recording the sequence of events as the program executes, checking each result against your expectations.

**Process:**
1. Execute instructions (manually or using a debugger)
2. Record the state: PC, register values, memory values
3. Compare actual results with expected results
4. When you find an unexpected result, you've narrowed down where the bug is

**Important:** Once you fix a bug, test again—there might be multiple bugs!

### Step 2: Use a Debugger

A **debugger** is a tool that lets you control program execution and inspect the state of your computer.

**Debugger capabilities:**
1. **Write values** into registers and memory locations
2. **Execute** a sequence of instructions
3. **Stop execution** at desired points (before the program ends)
4. **Examine** values in memory and registers at any time

The LC-3 simulator used in this class provides a debugging environment with all these capabilities.

## Debugging Techniques

### Examining and Changing Values

Your program's data lives in two places:

**Registers (R0–R7)**
- Fast access
- Display all values in the simulator
- Can change any register's value during debugging

**Memory**
- Can look at any memory location
- Can verify data is where you expect
- Can change data to test different scenarios

**Advanced technique:** You can even change instructions in memory during a debugging session!

### Two Ways to Control Execution

#### Single-Stepping
Execute **one instruction at a time** and examine the state after each instruction.

**Advantages:**
- See exactly what happens at each step
- Catch subtle bugs

**Disadvantages:**
- Slow for long sequences
- Can get lost in details

#### Breakpoints
Specify an instruction address where execution should **stop automatically**.

**Advantages:**
- Fast—run many instructions at once
- Good for narrowing down problem location
- Can stop at strategic places (end of each module/task)

**Best approach:** Combine both!
1. Set breakpoints between logical sections of your code
2. Run program; it stops at breakpoint
3. Single-step through the problematic section
4. Examine values carefully

**Pro tip:** Set breakpoints at the end of each major task or loop iteration.

---

## Debugging Examples

The best way to learn debugging is to do it. Here are four real examples showing common bugs and how to find them.

### Example 1: Loop Executes Wrong Number of Times

**Problem:** Multiply two positive integers (R4 × R5) and store result in R2.

**Test case:** R4 = 10, R5 = 3  
**Expected result:** R2 = 30  
**Actual result:** R2 = 40

**Buggy Code:**
```assembly
.ORIG x3000
        AND R2, R2, #0    ; R2 = 0 (sum)
        
LOOP    ADD R2, R2, R4    ; R2 = R2 + R4
        ADD R5, R5, #-1   ; R5 = R5 - 1
        BRzp LOOP         ; Loop if R5 >= 0
        
        HALT
.END
```

**Analysis:**

Looking at the code, R4 is added to R2, then R5 is decremented. Loop should execute while R5 > 0.

Expected: R2 = 0 + 10 + 10 + 10 = 30 (adds 10 three times)  
Actual: R2 = 40 (adds 10 four times)

**Execution trace** (with breakpoint at the BR instruction):

| PC | R2 | R4 | R5 | Status |
|----|----|----|----|----|
| x3003 | 10 | 10 | 2 | Loop executing |
| x3003 | 20 | 10 | 1 | Loop executing |
| x3003 | 30 | 10 | 0 | Loop executing??? |
| x3003 | 40 | 10 | -1 | Loop finally exits |

**Why 4 iterations instead of 3?** With `BRzp` (Branch if Zero or Positive), the loop continues when R5 = 0. It should execute only when R5 > 0.

**The Bug:** `BRzp` should be `BRp` (Branch if Positive).

**Fixed Code:**
```assembly
        AND R2, R2, #0    ; R2 = 0 (sum)
        
LOOP    ADD R2, R2, R4    ; R2 = R2 + R4
        ADD R5, R5, #-1   ; R5 = R5 - 1
        BRp LOOP          ; Loop if R5 > 0 (FIXED!)
        
        HALT
```

### Example 2: Wrong Opcode (LD vs LEA)

**Problem:** Add ten numbers stored at address x3100, result in R1.

**Test case:** Memory at x3100–x3109 contains: 0x0010, 0x0020, 0x0005, 0x0008, 0x0003, 0x0002, 0x0001, 0x0004, 0x0006, 0x0009  
**Expected sum:** 0x0048  
**Actual result:** 0x0024

**Buggy Code:**
```assembly
.ORIG x3001
        AND R1, R1, #0    ; R1 = 0 (sum)
        LD R2, ADDRESS    ; WRONG! Loads data FROM x3100
        AND R4, R4, #0    ; R4 = 0
        ADD R4, R4, #10   ; R4 = 10 (counter)
        
LOOP    LDR R3, R2, #0    ; Load value at address in R2
        ADD R1, R1, R3    ; Add to sum
        ADD R2, R2, #1    ; R2 = next address
        ADD R4, R4, #-1   ; Decrement counter
        BRp LOOP          ; Loop if counter > 0
        
        HALT
        
ADDRESS .FILL x3100
.END
```

**Analysis:**

Execution trace:

| PC | R2 | R3 | R1 | Status |
|----|----|----|----|--------|
| x3002 | ??? | ??? | 0 | LD loads from x3100 |
| x3003 | x3107 | ??? | 0 | **ERROR**: R2 = 0x3107, not 0x3100! |

**The Bug:** `LD` loads the **data** at memory location 0x3100 (which is 0x3107).  
We need `LEA` which loads the **address** itself (0x3100).

After LD: R2 contains 0x3107 (the value stored at x3100)  
After LEA: R2 contains 0x3100 (the address itself)

**The loop then processes addresses starting at x3107 instead of x3100**, getting wrong data and computing wrong sum!

**Fixed Code:**
```assembly
.ORIG x3001
        AND R1, R1, #0    ; R1 = 0 (sum)
        LEA R2, ADDRESS   ; FIXED! Loads ADDRESS x3100
        AND R4, R4, #0    ; R4 = 0
        ADD R4, R4, #10   ; R4 = 10 (counter)
        
LOOP    LDR R3, R2, #0    ; Load value at address in R2
        ADD R1, R1, R3    ; Add to sum
        ADD R2, R2, #1    ; R2 = next address
        ADD R4, R4, #-1   ; Decrement counter
        BRp LOOP          ; Loop if counter > 0
        
        HALT
        
ADDRESS .FILL x3100
.END
```

**Lesson:** Know the difference between instructions that use addresses vs. data!

### Example 3: Testing the Wrong Condition Code

**Problem:** Search for the value 5 in a sequence of ten numbers starting at x3100. If found, set R0 = 1; otherwise R0 = 0.

**Test case:** Array contains [12, 5, 8, ...] (includes at least one 5)  
**Expected:** R0 = 1  
**Actual:** R0 = 0

**Buggy Code:**
```assembly
.ORIG x3000
        LD R1, VALUE      ; R1 = -5 (for testing)
        AND R0, R0, #0    ; R0 = 0 initially
        ADD R0, R0, #1    ; R0 = 1 (assume found)
        LEA R4, ARRAY     ; R4 = x3100
        AND R3, R3, #0    
        ADD R3, R3, #10   ; R3 = 10 (counter)
        
        LDR R2, R4, #0    ; R2 = M[x3100]
        
LOOP    ADD R2, R2, R1    ; Test if R2 == 5 (by adding -5)
        BRz FOUND         ; If R2 == 5, branch
        
        ADD R4, R4, #1    ; Move to next address
        ADD R3, R3, #-1   ; R3--
        LDR R2, R4, #0    ; Load next value
        
        BRp LOOP          ; Loop if counter > 0
        
        AND R0, R0, #0    ; R0 = 0 (not found)
        HALT
        
FOUND   HALT              ; R0 still = 1
        
VALUE   .FILL -5
ARRAY   .FILL x3100
.END
```

**Execution Trace (breakpoint at bottom of loop):**

| PC | R2 | R3 | R1 | Condition Bits | Status |
|----|----|----|----|----|--------|
| x300D | 7 | 9 | -5 | N | Loop continues |
| x300D | 32 | 8 | -5 | P | Loop continues |
| x300D | 0 | 7 | -5 | **Z** | Loop stops??? |

**Why does it stop?** The **Z bit** (Zero flag) is set, but not by the ADD for testing! It's set by the `LDR` instruction that loaded 0 into R2.

**The Bug:** The condition codes are set by the **last instruction executed**. The `LDR` at line 21 overwrites the condition codes set by the `ADD` at line 17!

Execution order:
1. ADD R2, R2, R1 (sets condition codes)
2. BRz (tests condition codes)
3. ADD R4, R4, #1 (changes condition codes)
4. ADD R3, R3, #-1 (changes condition codes)
5. LDR R2, R4, #0 (CHANGES condition codes again!)
6. BRp tests the condition set by LDR, not by the test ADD!

**Fixed Code:**
```assembly
.ORIG x3000
        LD R1, VALUE      ; R1 = -5 (for testing)
        AND R0, R0, #0    ; R0 = 0 initially
        ADD R0, R0, #1    ; R0 = 1 (assume found)
        LEA R4, ARRAY     ; R4 = x3100
        AND R3, R3, #0    
        ADD R3, R3, #10   ; R3 = 10 (counter)
        
LOOP    LDR R2, R4, #0    ; Load value FIRST
        
        ADD R2, R2, R1    ; Test if R2 == 5 (by adding -5)
        BRz FOUND         ; If R2 == 5, branch
        
        ADD R4, R4, #1    ; Move to next address
        ADD R3, R3, #-1   ; R3--
        BRp LOOP          ; Loop if counter > 0 (FIXED!)
        
        AND R0, R0, #0    ; R0 = 0 (not found)
        HALT
        
FOUND   HALT              ; R0 still = 1
        
VALUE   .FILL -5
ARRAY   .FILL x3100
.END
```

**Lesson:** Condition codes are set by the **immediately preceding instruction**. Understand what sets the flags!

### Example 4: Not Testing All Input Values

**Problem:** Load a 16-bit data word. From left to right, find the first bit that is 1. Put the bit position (0–15, leftmost = 15) in R1. If no 1 bits, set R1 = -1.

**Test cases:** Usually works fine, but **sometimes fails to terminate** (infinite loop).

**Buggy Code:**
```assembly
.ORIG x3000
        LDI R2, DATAADDR  ; Load data value from far address
        AND R1, R1, #0
        ADD R1, R1, #15   ; R1 = 15 (leftmost bit position)
        
        ADD R2, R2, #0    ; Check sign bit
        BRn FOUND         ; If negative (bit 15 = 1), found it
        
LOOP    ADD R1, R1, #-1   ; Decrement bit position
        ADD R2, R2, R2    ; Shift left (old bit 15 goes to sign bit)
        BRn FOUND         ; If shifted a 1 into sign bit, found
        
        BRp LOOP          ; Loop if bit position still positive
        
        AND R1, R1, #0
        ADD R1, R1, #-1   ; R1 = -1 (no 1's found)
        HALT
        
FOUND   HALT
        
DATAADDR .FILL x3400
.END
```

**Testing:**

Most values work. But with some data, the program **never halts**.

| Test Value | Result |
|-----------|--------|
| 0x8000 (1000...) | Works—found bit 15 |
| 0x0001 (0000...1) | Works—finds bit 0 after 15 iterations |
| 0x0000 (0000...0) | **INFINITE LOOP** |

**What happens with zero?**
1. R2 = 0x0000
2. ADD R2, R2, #0 — Sets condition codes: Z (zero)
3. BRn — Doesn't branch (not negative)
4. Enter loop...
5. ADD R2, R2, R2 — R2 = 0 + 0 = 0 (still zero!)
6. BRn — Doesn't branch (shifting zero still gives zero)
7. BRp — Takes it (because... wait, R1 is positive, not R2!)
8. **Loop continues forever** because R2 is always zero, no 1 bit ever appears

**The Bug:** The code doesn't handle the case where the input value is zero. A zero value has no 1 bits, so the loop never finds one.

**Fixed Code:**
```assembly
.ORIG x3000
        LDI R2, DATAADDR  ; Load data value from far address
        AND R1, R1, #0
        ADD R1, R1, #15   ; R1 = 15 (leftmost bit position)
        
        ADD R2, R2, #0    ; Check for zero
        BRz ZERO_CASE     ; FIXED! Handle zero specially
        
        BRn FOUND         ; If negative (bit 15 = 1), found it
        
LOOP    ADD R1, R1, #-1   ; Decrement bit position
        ADD R2, R2, R2    ; Shift left
        BRn FOUND         ; If shifted a 1 into sign bit, found
        
        BRp LOOP          ; Loop if bit position still positive
        
ZERO_CASE
        AND R1, R1, #0
        ADD R1, R1, #-1   ; R1 = -1 (no 1's found)
        HALT
        
FOUND   HALT
        
DATAADDR .FILL x3400
.END
```

**Lesson:** Test with corner cases! Zero, negative numbers, empty collections, single elements, and other special values often reveal bugs.

---

## Key Lessons from Debugging

1. **Use breakpoints** to observe behavior, especially register values that affect control flow
2. **Single-step** to understand why registers have unexpected values (wrong opcode? wrong operand?)
3. **Test with varied inputs**
   - Large and small numbers
   - Negative numbers and zero
   - Empty collections
   - Boundary conditions
4. **Don't trust comments**
   - Comments show what the programmer *intended*
   - Only the instructions show what actually happens
5. **Remember condition codes**
   - Set by the immediately preceding instruction
   - An unexpected instruction can change them
6. **Check off-by-one errors**
   - Loops often execute one time too many or too few
   - Carefully verify loop termination conditions
7. **Fix one bug at a time**
   - Multiple bugs can mask each other
   - After fixing, test the entire program again

## Overview

A **data structure** is an organized way to store and manage data. Understanding data structures is fundamental to writing efficient programs.

### Basic Data Types vs. Data Structures

**Basic Data Types** (from Chapter 2) represent single values:
- **Integer**: typically one word (16 bits in LC-3)
- **Floating-point number**: typically one or two words
- **Character**: typically one word (stores ASCII code)

These are directly supported by machine instructions and occupy minimal memory.

**Data Structures** are more complex, combining basic types into organized collections:
- Examples: organization charts, music playlists, course schedules, inventories
- Allow us to represent real-world relationships and collections
- Essential for solving realistic programming problems

## Common Data Structures

### Arrays

An **array** is a sequence of values, stored in consecutive memory locations.

**Characteristics:**
- Fixed size (determined when created)
- All elements are the same type
- Accessed by index (position)
- Direct access to any element in O(1) time

**Example:** A character string from earlier chapters

```
Array of 5 integers:
Memory:  x3000: 42
         x3001: 17
         x3002: -5
         x3003: 88
         x3004: 31
```

**LC-3 Implementation:**
```assembly
; Declare an array of 5 integers at x3000
.ORIG x3000
.FILL 42
.FILL 17
.FILL -5
.FILL 88
.FILL 31
```

### Stack

A **stack** is a Last-In, First-Out (LIFO) data structure. Think of a stack of plates—you add to the top and remove from the top.

**Operations:**
- **PUSH**: Add an element to the top
- **POP**: Remove the element from the top
- Last element added is first element removed

**Use cases:** Function call management, undo/redo, expression evaluation

**Simple Example:**
```
Push 5, Push 10, Pop → returns 10 (not 5!)
Remaining stack: [5]
```

### Queue

A **queue** is a First-In, First-Out (FIFO) data structure. Like a line at a store—first person in line is first person served.

**Operations:**
- **ENQUEUE**: Add to the back
- **DEQUEUE**: Remove from the front
- First element added is first element removed

**Use cases:** Task scheduling, printer queues, event scheduling

**Simple Example:**
```
Enqueue "A", Enqueue "B", Enqueue "C"
Dequeue → returns "A" (not "C"!)
Queue now: ["B", "C"]
```

### Strings

A **string** is a sequence of characters. In LC-3 and most low-level languages, strings are handled as arrays of characters with a special terminator.

**Key Features:**
- Variable length (determined at runtime)
- Each character has an ASCII code
- **Null character** (ASCII 0x00) marks the end of the string
- Typically stored one character per word in LC-3 (even though ASCII only needs 7 bits)

**Example:** The string "Time flies." at memory location x4000

```
Memory:
x4000: 'T' (0x54)
x4001: 'i' (0x69)
x4002: 'm' (0x6D)
x4003: 'e' (0x65)
x4004: ' ' (0x20)
x4005: 'f' (0x66)
x4006: 'l' (0x6C)
x4007: 'i' (0x69)
x4008: 'e' (0x65)
x4009: 's' (0x73)
x400A: '.' (0x2E)
x400B: 0x00 (null terminator)
```

### Using .STRINGZ Directive

The `.STRINGZ` directive in LC-3 assembly language makes it easy to create strings. It automatically allocates memory, initializes characters, and adds the null terminator.

```assembly
HELLO .STRINGZ "Hello, World!\n"
```

This reserves memory for 14 characters (13 letters + space + punctuation + newline) plus 1 null terminator, for a total of 15 words of memory.

---

## Subroutines

### What is a Subroutine?

A **subroutine** is a reusable block of code that performs a specific task. It's called by other code, does its job, and then returns control to the caller.

Other names for subroutines in different languages:
- **Functions** (C)
- **Methods** (C++, Java)
- **Procedures** (Pascal)

### Why Use Subroutines?

**1. Reusability**
- Write code once, use it many times
- Errors fixed in one place, not multiple
- Reduces code duplication

**2. Abstraction**
- Hide complexity behind a simple interface
- Replace long code sequences with meaningful names
- Example: Instead of 20 instructions for "square root", just call `SQRT`
- Makes programs easier to read and understand

**3. Modularity**
- Divide large programs into smaller pieces
- Different programmers can work on different subroutines
- Easier to test and maintain

### Calling a Subroutine: The Problem

With `BR` and `JMP`, we can transfer control to another part of memory, but **how do we get back?**

Once we change the PC, we've lost track of where we came from!

**Solution:** The `JSR` (Jump to Subroutine) instruction saves the return address before jumping.

### JSR: Jump to Subroutine

The **JSR** instruction does two things:
1. Saves the current PC (incremented) into register **R7**
2. Jumps to the subroutine address

**Two addressing modes:**

#### JSR (PC-Relative Mode)
```assembly
JSR SUBTRACT  ; Jump to SUBTRACT if within range (±1024 words)
```
- Uses 11 bits for offset (PC-relative)
- Useful for subroutines close to current location
- Assembler automatically calculates offset

#### JSRR (Base+Offset Mode)
```assembly
JSRR R2  ; Jump to address in R2
```
- Allows subroutine location anywhere in memory
- Base register (R2–R6, or R7) contains the address
- Bit 11 distinguishes JSRR from JSR

**Example:**
```assembly
JSR SQRT      ; Save PC in R7, jump to SQRT
              ; Later, SQRT code executes...
```

### Returning from a Subroutine

R7 contains the saved return address (the instruction after `JSR`). To return:

```assembly
JMP R7        ; Jump back to the saved address
```

**Convenience:** The assembler provides a short mnemonic:

```assembly
RET           ; Equivalent to: JMP R7
```

> **Note:** `RET` is not a separate instruction—it's a special case of `JMP` recognized by the assembler.

#### Critical Rule: Protect R7!
**Must not modify R7** during subroutine execution, or the return address is lost forever. Any code that calls a subroutine must preserve R7.

### Saving and Restoring Registers

When a subroutine uses a register, it overwrites the previous value. If the caller needs that value, it must be saved somehow.

#### Where to Save?

**1. Copy to another register**
- Only works if you have spare registers
- LC-3 has only 7 usable registers (R0–R6), so this is limited

**2. Store to memory**
- Reserve memory location with `.BLKW` (Block of Words)
- Reliable and flexible
- **Preferred method**

#### Callee-Save Strategy

A subroutine must follow the **callee-save** convention:
- The subroutine (callee) is responsible for saving any registers it uses
- Must restore registers to original values before returning
- Ensures the caller's data is not corrupted
- Exception: Caller must save R7 if needed (since JSR modifies it)

### Subroutine Interface

A **subroutine interface** documents how data flows in and out. Both caller and callee must follow this precisely.

Interface must specify:
- **Input parameters**: What data does the subroutine need?
- **Output values**: What does it return?
- **Registers used**: Which registers are modified?
- **Memory usage**: Does it use memory besides its own code?

#### Passing Data in LC-3

LC-3 provides only two places to store data:
- **Registers (R0–R6)**: Fast, limited space (only 7 registers)
- **Memory**: Unlimited space, slower access

**General approach:**
- Small data: Use registers
- Large data or arrays: Pass a **pointer** (pointer = memory address of the data)

### Example: Sum Array Subroutine

Here's a complete example of a well-designed subroutine:

```assembly
; Subroutine: ArraySum
; Purpose: Compute the sum of an array of integers
;
; Interface:
; Input:  R0 = pointer (address) of first array element
;         R1 = number of elements in array
; Output: R2 = sum of all elements
;
; Changed registers: R0, R1, R2, R3

ArraySum
        ; Save registers that we'll modify
        ST R0, ASumR0    ; Save R0 to memory
        ST R1, ASumR1    ; Save R1 to memory
        ST R3, ASumR3    ; Save R3 to memory
        
        ; Initialize sum to zero
        AND R2, R2, #0   ; R2 = 0
        
        ; Check if array has elements
        ADD R1, R1, #0   ; Test R1 (size)
        BRnz ASDone      ; If size <= 0, skip loop
        
ASum    ; Loop: add each element
        LDR R3, R0, #0   ; Load element at address in R0
        ADD R2, R2, R3   ; Add to running sum
        ADD R0, R0, #1   ; Point to next element
        ADD R1, R1, #-1  ; Decrement counter
        BRp ASLoop       ; Loop while counter > 0
        
ASDone
        ; Restore saved registers
        LD R3, ASumR3    ; Restore R3
        LD R1, ASumR1    ; Restore R1
        LD R0, ASumR0    ; Restore R0
        
        RET              ; Return to caller
        
; Memory for saved registers
ASumR0  .BLKW 1
ASumR1  .BLKW 1
ASumR3  .BLKW 1
```

**How it works:**
1. Save any registers we'll modify
2. Initialize sum (R2) to zero
3. Check if array is empty; if so, return
4. Loop: Load each element, add it to sum, move to next element
5. Restore saved registers
6. Return to caller (R2 contains the result)

### String Processing

Strings are commonly processed in a standard pattern:

**Algorithm:**
1. Initialize pointer to start of string
2. Load character using pointer
3. Check for null terminator (end of string)—if found, exit
4. Do something with the character
5. Increment pointer to next character
6. Loop back to step 2

**Example: Print a String**

```assembly
; Subroutine: PrintString
; Purpose: Print string to console
; Input: R0 = pointer to start of string
; Output: None

PrintString
        ST R0, PSaveR0
        
PSLoop
        LDR R1, R0, #0   ; Load character
        BRz PSDone       ; If null char, done
        OUT              ; Print character (TRAP x21)
        ADD R0, R0, #1   ; Move to next character
        BR PSLoop
        
PSDone
        LD R0, PSaveR0
        RET
        
PSaveR0 .BLKW 1
```

### Character Operations

Common operations when processing strings:

| Operation | How to do it | Example |
|-----------|-------------|---------|
| Compare alphabetically | Subtract one from the other | Compare 'A' and 'Z' |
| Check if digit | Test if in range 0x30–0x39 | Is '5' a digit? |
| Check if uppercase | AND with 0x20, test bit 5 | Is 'A' uppercase? (bit 5 = 0) |
| Convert to uppercase | AND with 0xFFDF (clears bit 5) | 'a' → 'A' |
| Convert digit to number | Subtract 0x30 | '5' → 5 |

Example:
```assembly
LD R0, CHAR      ; 'a' = 0x61
AND R0, R0, 0xFFDF  ; Clear bit 5
; Now R0 = 0x41 = 'A'
```

### Library Subroutines

Related subroutines are often packaged together into a **library**—a collection of reusable code modules.

**Benefits:**
- Consistent interface across related functions
- Well-documented and tested
- Programmers use them without understanding implementation details
- Using the `EXTERNAL` mechanism (Chapter 7), libraries can be linked with other modules

**Example:** A string library might contain: `StringLength`, `StringCompare`, `StringCopy`, `StringFind`, etc.

---

## Putting It Together: A Complete String Example

```assembly
; Classic "Hello, World!" program in LC-3

.ORIG x3000

        LEA R1, HELLO    ; Get address of string
        
PrintLoop
        LDR R0, R1, #0   ; Load character via pointer
        BRz Done         ; If null terminator, we're done
        OUT              ; TRAP x21 - Print character
        ADD R1, R1, #1   ; Move pointer to next character
        BR PrintLoop
        
Done
        HALT             ; TRAP x25 - Stop execution
        
; String data
HELLO   .STRINGZ "Hello, World!\n"

.END
```

This program demonstrates:
- String storage with `.STRINGZ`
- String processing pattern (load, check for null, process, increment)
- TRAP instructions for I/O
