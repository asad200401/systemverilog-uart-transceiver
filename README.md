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
`IDLE → START → DATA → STOP → IDLE`

**Features:**
- LSB first transmission
- Start bit generation
- Stop bit generation
- Busy/Ready status signal (`tx_status`)

# UART Receiver

**FSM States:**  
`IDLE → START → DATA → STOP → IDLE`

**Features:**
- Start bit detection
- 8× oversampling
- Stop-bit validation
- Frame valid status (`rx_status`)

# Simulation Result:

<img width="1334" height="280" alt="image" src="https://github.com/user-attachments/assets/6c38c6b1-2d07-4e79-8024-52b4b0cdb0df" />

**Key Observations:**
- Data `0xA5` and `0x3C` transmitted and received successfully
- `tx_data` shows correct start bit, data bits (LSB first), and stop bit
- `data_out` correctly recovers the received bytes
- `tx_status` goes low during transmission and returns high when ready
- `rx_status` pulses high on valid frame reception
- Clean full-duplex operation with no framing errors

# Conclusion

Successfully designed and verified a Full-Duplex UART Transceiver in SystemVerilog, featuring a baud rate generator, transmitter, and receiver with 8× oversampling. The design correctly implements the 8N1 UART protocol at 9600 baud and was validated through comprehensive simulation and testbench verification, demonstrating reliable serial communication suitable for FPGA and ASIC-based digital systems.

# Author

**Asad Iqbal**

⭐ If this helped you, please star the repository!
