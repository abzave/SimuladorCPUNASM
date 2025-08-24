# CPU Simulator in Assembly

This project simulates a CPU executing a multiplication program. The project was developed in Assembly. The goal of the project is to understand how a CPU executes instructions going through the fetch cycle.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Requirements](#requirements)
4. [How to Assemble and Run](#how-to-assemble-and-run)
5. [Usage](#usage)

## Project Overview

This simulator project makes use of low-level programming to go through the same process as a CPU does to execute instructions. The virtual CPU has the registers as a 16-bits x86 CPU, and a virtual memory of 256 bytes.

## Features

- **Decimal Multiplication Program**: The simulator contains preload a multiplication software for the virtual CPU to execute.
- **Display Registers State**: Displays the current state of the virtual CPU registers.
- **Display Memory State**: Displays the current state of the virtual memory.
- **Execute Instructions On-Demand**: Instructions are executed only when the user requests it.
- **Command Line Menus**: The user can interact with the application using menus in the command line.
- **Help Menu**: Displays a instructions of how to use the application and what is the fuction of each option.

## Requirements

- **x86 CPU Architecture**: A CPU compatible with Intel's x86 Architecture.
- **NASM Assembler**: This project is intended to be assembled using the NASM assembler.
- **16-bits x86 Architecture**: The virtual CPU follows the architecture of a 16-bit x86 Intel CPU.
- **256 Bytes Virtual Memory**: The virtual CPU has available a virtual 256 virtual RAM memory.
- **Virtual CPU Machine Code**: The virtual CPU has its own machine code.

## How to Assemble and Run

### Step 1: Clone the repository

``` bash
git clone https://github.com/abzave/SimuladorCPUNASM.git
cd SimuladorCPUNASM
```

### Step 2: Assemble the project

``` bash
nasm -f elf CPU.asm
ld CPU.o
```

### Step 3: Run the program

Once assemble, run the executable on the command line.

## Usage

1. Select `1` to start executing the multiplication program.
    1. Select `h` to display the help menu with the list of all commands.
    2. Select `r` to display the state of the registers.
        1. Select `1` to display all the registers.
        2. Select `2` to display the `Program Counter (PC)` register.
        3. Select `3` to displat the `Instruction Register (IR)`.
        4. Select `4` to display the `Flags` register.
        5. Select `5` to display the `AX` register.
        6. Select `6` to display the `BX` register.
        7. Select `7` to display the `CX` register.
        8. Select `8` to display the `Source Index (SI)` register.
        9. Select `9` to display the `Data Segment (DS)` register.
        10. Select `10` to display the `Code Segment (CS)` register.
        11. Select `11` to display the `Memory Address Register (MAR)`.
        12. Select `0` to go back to the main menu.
    4. Select `m` to display the state of the memory.
        1. Select `1` to display all the memory.
        2. Select `2` to go to a specific memory cell.
            1. Enter the cell number.
        4. Select `0` to go back to the main menu.
    6. Select `e` to run the next instruction.
    7. Select `s` to go back to the main menu.
2. Select `0` to exit.
