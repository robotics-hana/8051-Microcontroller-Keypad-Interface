# 8051 Microcontroller Keypad Interface with 7-Segment Display Control Using 8255 PPI

## Overview

This project contains assembly code (`lab2.asm`) for interfacing a keypad with an 8051 microcontroller, using the 8255 PPI (Programmable Peripheral Interface). The code handles reading inputs from the keypad, decoding the values using lookup tables, and displaying the corresponding values on a 7-segment display. Additionally, it includes functionality to handle specific keypresses, shift registers, and debounce key inputs.

### Author: 
Hana Emma Hadidi

### Key Features:
- Keypad scanning and value decoding
- Shift register management for multi-digit input
- Displaying keypresses on a 7-segment display
- Debounce handling to reduce erroneous inputs
- Lookup tables for translating keypresses to display values

---

## Files Included:
- `Interface.asm`: The main assembly code for the project.

---

## Hardware Requirements:
- 8051 Microcontroller
- 8255 PPI (Programmable Peripheral Interface)
- Keypad (4x4 matrix)
- 7-segment display
- Latches and transistors for driving the 7-segment display
- Resistors and capacitors for debounce and timing
- Power supply for the microcontroller and peripherals

---

## Assembly Code Breakdown

### Bit Address Equates:
This section defines the specific bit addresses for the control pins of the 8255 PPI:
- `RDpin` (Read Pin)
- `WRpin` (Write Pin)
- `A0pin`, `A1pin` (Address Pins for the 8255 Control Register)

### Lookup Tables:
- The lookup tables `KCODE0`, `KCODE1`, `KCODE2`, and `KCODE3` store the hexadecimal representations for the 7-segment display corresponding to the keypad keys.

### Keypad Loop:
The program continuously scans the keypad matrix by sending signals to the columns and reading rows. When a valid keypress is detected, the value is processed and stored in registers for display.

### Subroutines:
- **Keypad Handling**: 
  - `get_input_position`: Detects the row of the keypad where a key is pressed.
  - `get_column`: Detects the column of the keypress and fetches the correct value from the lookup table.
  - `shift_registers_accross`: Shifts previously stored values in the registers to prevent overwriting when new input is received.

- **Display Handling**:
  - `display_value`: Sends the stored values in registers to the 7-segment display, cycling through the segments to display the input across multiple digits.
  
- **Delay Handling**:
  - `delay`: Implements a basic delay for debounce, ensuring that the program correctly reads keypresses without false triggers.

---

## How to Use

1. **Assemble the Code**: 
   - Use an assembler compatible with the 8051 microcontroller to assemble `lab2.asm` into machine code.

2. **Program the Microcontroller**:
   - Flash the assembled machine code onto your 8051 microcontroller.

3. **Connect the Hardware**:
   - Wire the keypad to the input pins of the 8255 PPI.
   - Connect the 7-segment display and ensure proper power supply and signal handling.

4. **Run the Program**:
   - Upon pressing keys on the keypad, the values should display on the 7-segment display.

---

## Functionality

- **Keypad Scanning**: The program continuously scans the keypad to detect any keypress. Once detected, it identifies the specific key and stores the value in a register.
  
- **Shift Registers**: After each keypress, the values in the registers shift to prevent overwriting.

- **7-Segment Display**: The program uses Port A of the 8255 PPI to control the segments of the display, and Port B to manage which digit is active.

- **Keypress Check**: The program checks for the 'F' keypress (corresponding to a specific hexadecimal code) and clears all registers when 'F' is pressed.

---

## Notes

- The program is designed to handle 4x4 keypads, but it can be adjusted to work with other configurations.
- Ensure the 7-segment display and associated latches are correctly wired to avoid display glitches.
- The lookup tables can be modified if a different display encoding is required for the 7-segment output.
