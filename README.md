# UART Communication Protocol in SystemVerilog

![Uart](https://img.shields.io/badge/UART-uart-blue)
![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-orange)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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

IDLE --> START --> DATA --> STOP --> IDLE

**Features:**
- LSB first transmission
- Start bit generation
- Stop bit generation
- Busy/Ready status signal

# UART Receiver

**Features:**
- Double-flop synchronization
- Start bit detection
- 8x oversampling
- Majority voting
- Stop-bit validation

**FSM States:**

IDLE --> START --> DATA --> STOP --> IDLE

# Simulation Result:

<img width="1358" height="346" alt="image" src="https://github.com/user-attachments/assets/dc84a2e4-c20d-4fd6-86fb-8d4dd608b021" />

**Key Observations:**
- Data `0xAA` and `0x55` transmitted successfully
- Receiver correctly samples and reconstructs the data
- `tx_status` and `rx_status` signals work as expected
- Proper start bit, data bits (LSB first), and stop bit behavior
- No framing errors — clean data recovery

# Conclusion

Successfully designed and verified a Full-Duplex UART Transceiver in SystemVerilog, featuring a baud rate generator, transmitter, and receiver with 8× oversampling. The design correctly implements the 8N1 UART protocol at 9600 baud and was validated through comprehensive simulation and testbench verification, demonstrating reliable serial communication suitable for FPGA and ASIC-based digital systems.
