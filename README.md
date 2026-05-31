# UART Communication Protocol in SystemVerilog

# Overview
This project implements a full-duplex UART (Universal Asynchronous Receiver Transmitter)
communication system in SystemVerilog.

**Features:**
- Baud Rate: 9600 bps
- System Clock: 100 MHz
- Frame Format:
  - 1 Start Bit
  - 8 Data Bits
  - No Parity
  - 1 Stop Bit
- Full Duplex Communication
- Receiver Oversampling: 8x Baud Rate

# Architecture

<img width="516" height="325" alt="image" src="https://github.com/user-attachments/assets/0cf1a8ec-b0d2-4fe2-bb16-d2d09942a5f4" />

# Module Description
**Baud Rate Generator**

<img width="822" height="212" alt="image" src="https://github.com/user-attachments/assets/d5157ced-401e-4c92-a221-a22193c25385" />

**Generates:**
- bclk    = 9600 Hz
- bclkx8  = 76800 Hz

# Uart Transmitter:
**FSM States:**
IDLE
 ↓
START
 ↓
DATA
 ↓
STOP
 ↓
IDLE
