> With $n$ bits you can represent $2^n$ values.

Bits can represent anything. Possible values we can represent with bits include:

- **Numbers**: Integers, fractions, real numbers, complex numbers
- **Text**: Characters, strings
- **Images**: Pixels, colors, shapes
- **Sound**
- **Video**
- **Logical values**: True, false
- **Instructions**
- ...

# Datatypes

In a computer system, we need a representation of data and operations that can be performed on the data by machine instructions or the computer language.

This combination of representation + operations is known as a **data type**.

| Type              | Representation        | Operations             |
| ----------------- | --------------------- | ---------------------- |
| Unsigned integers | Binary                | Add, multiply, etc.    |
| Signed integers   | 2's complement binary | Add, multiply, etc.    |
| Real numbers      | IEEE floating-point   | Add, multiply, etc.    |
| Text characters   | ASCII                 | Input, output, compare |

## Unsigned Integers

Encode a decimal integer using base-two binary numbers.

Use $n$ bits to represent values from $0$ to $2^n-1$.

|$2^2$|$2^1$|$2^0$|Value|
|---|---|---|---|
|0|0|0|0|
|0|0|1|1|
|0|1|0|2|
|0|1|1|3|
|1|0|0|4|
|1|0|1|5|
|1|1|0|6|
|1|1|1|7|

### Unsigned Binary Arithmetic

Base-2 addition works just like base-10:

- Add from right to left, propagating carry

![[base_2_addition.png |center | 600]]

## Signed Integers

Signed integers can represent both positive and negative values.

This can be done in different ways:

- Signed-magnitude
- 1's complement
- 2's complement

### Signed-Magnitude

The leftmost bit represents the sign of the number:

- `0` = positive
- `1` = negative

The remaining bits represent the magnitude of the number using the binary notation used for unsigned integers.

**Examples of 5-bit signed-magnitude integers:**

- `00101` = $+5$ (sign = `0`, magnitude = `0101`)
- `10101` = $-5$ (sign = `1`, magnitude = `0101`)
- `01101` = $+13$ (sign = `0`, magnitude = `1101`)

### 1's Complement

To get a negative number, start with a positive number (with zero as the leftmost bit) and flip all the bits: from `0` to `1`, and from `1` to `0`.

**Examples of 5-bit 1's complement integers:**

![[1_complement_examples.png | center | 600]]

### Disadvantages of Signed-Magnitude and 1's Complement

In both representations, there are two different representations of zero:

- **Signed-magnitude**: `00000` = 0 and `10000` = 0
- **1's complement**: `00000` = 0 and `11111` = 0

Operations are not simple:

- Think about how to add $+2$ and $-3$.
- Actions are different for two positive integers, two negative integers, and one positive and one negative.

A simpler scheme: **2's complement**

## 2's Complement

To simplify circuits, we want all operations on integers to use binary arithmetic, regardless of whether the integers are positive or negative.

When we add $+X$ to $-X$, we want to get zero. Therefore, we use "normal" unsigned binary to represent $+X$, and we assign to $-X$ the pattern of bits that will make $X + (-X) = 0$.

![[2_complement_examples.png | center | 600]]

> When we do this, we get a carry-out bit of `1`, which is ignored. We only have 5 bits, so the carry-out bit is ignored and we still have 5 bits.

### 2's Complement Integers

With $n$ bits, we can represent values from $-2^{n-1}$ to $2^{n-1}-1$.

> All positive numbers still start with `0`, all negative numbers start with `1`.

|4-bit 2's<br>complement|Value|4-bit 2's<br>complement|Value|
|---|---|---|---|
|0000|0|||
|0001|1|1111|-1|
|0010|2|1110|-2|
|0011|3|1101|-3|
|0100|4|1100|-4|
|0101|5|1011|-5|
|0110|6|1010|-6|
|0111|7|1001|-7|
|||1000|-8|

### Converting $X$ to $-X$

1. Flip all the bits (same as 1's complement)
2. Add $+1$ to the result

![[2_complement_flip.png | center | 600]]

> **Shortcut**
> 
> To take the two's complement of a number:
> 
> 1. Copy bits from right to left until (and including) the first `1`
> 2. Flip remaining bits to the left
> 
> ![[2_complement_shortcut.png | center | 600]]

### Converting Binary (2's Complement) to Decimal

1. If the leading bit is `1`, take two's complement to get a positive number
2. Add powers of 2 that have `1` in the corresponding bit positions
3. If the original number was negative, add a minus sign

**Examples:**

> **Example 1:**
> 
> $X = 01101000_{bin}$
> 
> $= 2^6 + 2^5 + 2^3 = 64 + 32 + 8$
> 
> $= 104_{dec}$

> **Example 2:**
> 
> $X = 00100111_{bin}$
> 
> $= 2^5 + 2^2 + 2^1 + 2^0 = 32 + 4 + 2 + 1$
> 
> $= 39_{dec}$

> **Example 3:**
> 
> $X = 11100110_{bin}$
> 
> $-X = 00011010_{bin}$
> 
> $= 2^4 + 2^3 + 2^1 = 16 + 8 + 2$
> 
> $= 26_{dec}$
> 
> $X = -26_{dec}$

### Converting Decimal to Binary (2's Complement)

#### First Method: Division

1. Find magnitude of decimal number (always positive)
2. Divide by two, remainder is the least significant bit
3. Keep dividing by two until answer is zero, writing remainders from right to left
4. Append a zero as the most significant bit; if the original number was negative, flip bits and add $+1$

**Example:**

> $X = 104_{dec}$
> 
> $104 / 2 = 52$, remainder $= 0$ (bit 0)
> 
> $52 / 2 = 26$, remainder $= 0$ (bit 1)
> 
> $26 / 2 = 13$, remainder $= 0$ (bit 2)
> 
> $13 / 2 = 6$, remainder $= 1$ (bit 3)
> 
> $6 / 2 = 3$, remainder $= 0$ (bit 4)
> 
> $3 / 2 = 1$, remainder $= 1$ (bit 5)
> 
> $1 / 2 = 0$, remainder $= 1$ (bit 6)
> 
> $X = 01101000_{bin}$

#### Second Method: Subtract Powers of Two

1. Find magnitude of decimal number
2. Subtract largest power of two less than or equal to the number
3. Put a `1` in the corresponding bit position
4. Keep subtracting until result is zero
5. Append a zero as the most significant bit; if the original was negative, flip bits and add $+1$

**Example:**

> $X = 104_{dec}$
> 
> $104 - 64 = 40$ (bit 6)
> 
> $40 - 32 = 8$ (bit 5)
> 
> $8 - 8 = 0$ (bit 3)
> 
> $X = 01101000_{bin}$

## Operation: Addition

As discussed, 2's complement addition is just binary addition:

- Assume operands have the same number of bits
- Ignore carry-out

![[2_c_addition.png | center | 600]]

## Operation: Subtraction

You can, of course, do subtraction in base-2, but it's easier to negate the second operand and add.

Again, assume same number of bits, and ignore carry-out.

![[2_c_subtraction.png | center | 600]]

## Operation: Sign Extension

To add or subtract, we need both numbers to have the same number of bits. What if one number is smaller?

Padding on the left with zero does **not** work:

![[s_ext_wrong.png | center | 600]]

Instead, replicate the most significant bit (the sign bit):

![[s_ext_right.png | center | 600]]

## Overflow

If the numbers are too big, then we cannot represent the sum using the same number of bits.

For 2's complement, this can only happen if both numbers are positive or both numbers are negative.

![[2_c_overflow.png | center | 600]]

> **How to test for overflow:**
> 
> 1. Signs of both operands are the same, AND
> 2. Sign of sum is different

## Logical Operations: AND, OR, NOT

If we treat each bit as TRUE (`1`) or FALSE (`0`), then we can define logical operations, also known as **Boolean operations**, on a bit.

### Truth Tables for Basic Logical Operations

**AND Operation:**

|A|B|A AND B|
|---|---|---|
|0|0|0|
|0|1|0|
|1|0|0|
|1|1|1|

**OR Operation:**

|A|B|A OR B|
|---|---|---|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|1|

**NOT Operation:**

|A|NOT A|
|---|---|
|0|1|
|1|0|

View an $n$-bit number as a collection of $n$ logical values (bit vector). The operation is applied to each bit independently.

### Examples of Logical Operations

**AND:**

Useful for **clearing bits**:

- AND with `0` = `0`
- AND with `1` = no change

**Example:**

```
  10110101
& 00001111  (mask to keep only last 4 bits)
----------
  00000101
```

**OR:**

Useful for **setting bits**:

- OR with `0` = no change
- OR with `1` = `1`

**Example:**

```
  10110101
| 11110000  (mask to set first 4 bits)
----------
  11110101
```

**NOT:**

Unary operation (one argument):

- Flips every bit

**Example:**

```
NOT 10110101 = 01001010
```

## Logical Operation: Exclusive-OR (XOR)

Another useful logical operation is XOR. True if one of the bits is `1`, but **not both**.

**XOR Truth Table:**

|A|B|A XOR B|
|---|---|---|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|0|

**XOR:**

Useful for **selectively flipping bits**:

- XOR with `0` = no change
- XOR with `1` = flip

**Example:**

```
  10110101
^ 00001111  (mask to flip last 4 bits)
----------
  10111010
```

## DeMorgan's Laws

There's an interesting relationship between AND and OR operations.

DeMorgan's Laws state:

1. $\overline{A \cdot B} = \overline{A} + \overline{B}$
    - NOT (A AND B) = (NOT A) OR (NOT B)
2. $\overline{A + B} = \overline{A} \cdot \overline{B}$
    - NOT (A OR B) = (NOT A) AND (NOT B)

This means that any OR operation can be written as a combination of AND and NOT, and vice versa.

**Example:**

```
A = 1010
B = 1100

NOT (A AND B):
  1010
& 1100
------
  1000  -> NOT -> 0111

(NOT A) OR (NOT B):
NOT A = 0101
NOT B = 0011
  0101
| 0011
------
  0111  (same result!)
```

## Representing Text: ASCII Code

To represent other types of data, such as text, we devise various coding schemes.

**ASCII** is a 7-bit code representing basic letters, digits, punctuation, and control characters.

A portion of the ASCII table is shown below:

| Binary     | Hex | Character |
| ---------- | --- | --------- |
| `011 0000` | 30  | 0         |
| `011 0001` | 31  | 1         |
| `010 0000` | 20  | space     |
| `010 0001` | 21  | !         |
| `010 0011` | 23  | #         |
| `100 0101` | 45  | E         |
| `110 0101` | 65  | e         |
| `000 1010` | 0A  | linefeed  |

> The ASCII table includes 128 characters (0-127). Extended ASCII uses 8 bits to represent 256 characters.

## Hexadecimal Notation: Binary Shorthand

To avoid writing long (error-prone) binary values, we group four bits together to make a base-16 digit. Use A to F to represent values 10 to 15.

![[bin_hex_dec.png | center | 600]]

**Example:**

> Hex number `3D6E` is easier to communicate than binary `0011 1101 0110 1110`
> 
> To convert: group binary into sets of 4 bits, then convert each group to hex.

### Converting from binary to hex
Starting from the right, group every four bits together into a hex digit. Sign-extend as needed.

![[bin_to_hex_ex.png | center | 600 ]]

> This is not a new machine representation or data type, just a convenient way to write the number

