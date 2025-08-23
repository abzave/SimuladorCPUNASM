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
git clone https://github.com/abzave/Traductor-de-numeros-a-japones.git
cd Traductor-de-numeros-a-japones
```

### Step 2: Assemble the project

``` bash
nasm -f elf 18168174.ASM
ld 18168174.o
```

### Step 3: Run the program

Once assemble, run the executable on the command line.

## Usage

1. Use the `-j` flag along with the number to translate. The translated number will be displayed in the command line.
2. Use the `-h` flag to display the help menu.
