# Assembler Program README

## Overview

This is an assembler. It takes assembly from `asm.txt` and puts binary in `bin.txt`.

## Usage

1. **Provide assembly**: Place your assembly code inside `asm.txt`.
2. **Run the assembler**: Execute the program with the command `python asm2bin.py` from the implementation/asm2bin directory.
3. **Copy the binary output**: Open `bin.txt` and copy its contents into the `memory.txt` file.

## Features

- **Label Support**: The assembler allows the use of labels for easier code readability and maintenance. Labels should be appended with a colon (`:`) and placed on the same line as the target instruction. When referencing a label, use its name without the colon.
- **Handling Special Addresses**: The assembler translates special address names to their respective numerical addresses automatically. Feel free to change the values as needed.