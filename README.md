# Design and Comparative Analysis of Security Modules for Serial Communication using Verilog HDL

##  Project Overview
This project focuses on the **design, implementation, and comparative evaluation of individual hardware security modules** for UART-based serial communication using Verilog HDL. Instead of proposing a single monolithic secure protocol, this work explores multiple lightweight security techniques independently and evaluates their hardware efficiency.

Each security mechanism is designed as a **standalone RTL module**, synthesized individually, and analyzed in terms of **area, power, and timing**, to understand the trade-offs between different approaches for securing serial communication in embedded systems.

---

##  Objectives
- Design UART and security modules individually at RTL level.
- Implement independent hardware security mechanisms.
- Perform synthesis-based comparative analysis.
- Evaluate suitability of each module for resource-constrained systems.

---

##  Modules Implemented

### 1. UART Core
- `uart_tx` – UART Transmitter  
- `uart_rx` – UART Receiver  
- `baud_gen` – Baud rate generator  

Used as the baseline communication system.

---

### 2. Keyed CRC Module (Integrity)
- Standalone CRC with secret key.
- Detects accidental errors and malicious tampering.
- Evaluated independently for hardware overhead.

---

### 3. Sequence Counter Module (Replay Protection)
- Adds freshness using sequence numbers.
- Detects replayed packets.
- Implemented and tested separately from CRC and AES.

---

### 4. AES Module (Confidentiality)
- AES-128 encryption core.
- Implements SubBytes, ShiftRows, MixColumns, AddRoundKey.
- Provides strong confidentiality with higher hardware cost.

---

### 5. Key Generation Module (LFSR)
- LFSR-based pseudo-random key generator.
- FSM controlled operation.
- Generates 128-bit cryptographic keys.

---

## Methodology
Each module was:
1. Designed independently in Verilog HDL.
2. Verified using testbenches in ModelSim.
3. Synthesized individually using Synopsys Design Compiler.
4. Evaluated using:
   - Area report  
   - Power report  
   - Timing report  

This approach enables **fair and direct comparison** between different security techniques.

---

##  Comparative Analysis
A comparative study was performed across all modules based on:

| Module            | Area | Power | Timing | Security Feature |
|-------------------|------|-------|--------|------------------|
| UART              | Low  | Low   | Fast   | No security      |
| Keyed CRC         |  Low |  Low | Fast | Integrity |
| Sequence Counter  | Very Low  | Very Low  | Fast   | Replay protection |
| AES-128           | High | Moderate | Slower | Confidentiality |
| Key Generator     | Low  | Low   | Fast   | Key management |

This comparison highlights the **trade-off between security strength and hardware cost**.

---

## 🛠 Tools & Technologies
- Language: Verilog HDL  
- Simulation: ModelSim  
- Synthesis: Synopsys Design Compiler  
- FPGA Tool: Intel Quartus Prime  

---

##  Project Structure
├── uart/
│ ├── uart_tx.v
│ ├── uart_rx.v
│ └── baud_gen.v
├── crc/
│ └── crc_keyed.v
├── replay/
│ ├── replay_counter_tx.v
│ └── replay_counter_rx.v
├── aes/
│ └── aes_core.v
├── keygen/
│ └── lfsr_key_gen.v
├── testbench/
│ ├── tb_uart.v
│ ├── tb_crc.v
│ ├── tb_replay.v
│ ├── tb_aes.v
│ └── tb_keygen.v
└── reports/
├── uart_reports/
├── crc_reports/
├── replay_reports/
├── aes_reports/
└── keygen_reports/
