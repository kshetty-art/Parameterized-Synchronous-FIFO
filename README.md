# 🚀 Parameterized Synchronous FIFO Verification using SystemVerilog

## 📖 Overview

This project implements a **Parameterized Synchronous FIFO** in **SystemVerilog** along with a **self-checking verification environment**.

The FIFO supports configurable **DATA_WIDTH** and **DEPTH**, and includes:

- Full Flag
- Empty Flag
- Almost Full Flag
- Almost Empty Flag
- Count Register

The verification environment verifies the FIFO using **directed testcases**, **random stress testing**, and a **reference-model scoreboard**.

---

# ✨ Features

## RTL Design

- ✅ Parameterized FIFO
- ✅ Configurable DATA_WIDTH
- ✅ Configurable DEPTH
- ✅ Circular Buffer
- ✅ Read Pointer
- ✅ Write Pointer
- ✅ Full / Empty Flags
- ✅ Almost Full / Almost Empty Flags
- ✅ Count Register

## Verification Environment

- ✅ Self-checking Testbench
- ✅ Modular Driver
- ✅ Reference-model Scoreboard
- ✅ Directed Testcases
- ✅ Random Stress Test
- ✅ Automatic PASS / FAIL Reporting

---

# 🏗 RTL Block Diagram

```text
                        PARAMETERIZED SYNCHRONOUS FIFO
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  Inputs                                                     Outputs         │
│                                                                             │
│ clk --------------------------------------------------------------►         │
│ rst_n ------------------------------------------------------------►         │
│ wr_en ------------------------------------------------------------►         │
│ rd_en ------------------------------------------------------------►         │
│ din[DATA_WIDTH-1:0] ----------------------┐                                 │
│                                           │                                 │
│                                           ▼                                 │
│                                 ┌─────────────────────┐                     │
│                                 │    Memory Array     │──────► dout         │
│                                 │ DEPTH × DATA_WIDTH  │                     │
│                                 └─────────────────────┘                     │
│                                      ▲          ▲                           │
│                                      │          │                           │
│                           Write Addr │          │ Read Addr                 │
│                                      │          │                           │
│                          ┌───────────┘          └───────────┐               │
│                          ▼                                  ▼               │
│                 ┌────────────────┐               ┌────────────────┐         │
│                 │ Write Pointer  │               │ Read Pointer   │         │
│                 └────────────────┘               └────────────────┘         │
│                          ▲                                  ▲               │
│                          └──────────────┬───────────────────┘               │
│                                         ▼                                   │
│                              ┌────────────────────┐                         │
│                              │   Control Logic    │                         │
│                              │ Read/Write Control │                         │
│                              │ Pointer Update     │                         │
│                              │ Memory Access Ctrl │                         │
│                              └────────────────────┘                         │
│                                         │                                   │
│                                         ▼                                   │
│                              ┌────────────────────┐                         │
│                              │ Status Flag Logic  │                         │
│                              │ Count Register     │                         │
│                              │ Full               │────► full              │
│                              │ Empty              │────► empty             │
│                              │ Almost Full        │────► almost_full       │
│                              │ Almost Empty       │────► almost_empty      │
│                              │ Count              │────► count             │
│                              └────────────────────┘                         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

Parameters
----------
DATA_WIDTH : Configurable
DEPTH      : Configurable
ADDR_WIDTH : ceil(log2(DEPTH))
```

---

# 🧪 Verification Architecture

```text
                               fifo_tb
                                  │
        ┌─────────────────────────┴─────────────────────────┐
        │                                                   │
        ▼                                                   ▼
┌─────────────────────┐                         ┌──────────────────────┐
│   fifo_utils.svh    │                         │   fifo_tests.svh     │
├─────────────────────┤                         ├──────────────────────┤
│ Banner              │                         │ Reset                │
│ PASS / FAIL         │                         │ Single Write / Read  │
│ Test Counter        │                         │ Fill FIFO            │
│ Summary Report      │                         │ Empty FIFO           │
└─────────────────────┘                         │ Overflow             │
                                                │ Underflow            │
                                                │ Simultaneous RW      │
                                                │ Random Stress Test   │
                                                └──────────┬───────────┘
                                                           │
                          ┌────────────────────────────────┴──────────────────────────┐
                          ▼                                                           ▼
              ┌──────────────────────┐                              ┌──────────────────────┐
              │  fifo_driver.svh     │                              │ fifo_scoreboard.svh  │
              ├──────────────────────┤                              ├──────────────────────┤
              │ driver_write()       │                              │ Expected Queue       │
              │ driver_read()        │                              │ Data Compare         │
              │ driver_rw()          │                              │ Count Check          │
              │ fifo_write()         │                              │ Flag Check           │
              │ fifo_read()          │                              │ PASS / FAIL          │
              │ fifo_rw()            │                              └──────────────────────┘
              └──────────┬───────────┘
                         │
                         ▼
               ┌─────────────────────────────┐
               │ Parameterized FIFO DUT      │
               ├─────────────────────────────┤
               │ Memory Array                │
               │ Write Pointer               │
               │ Read Pointer                │
               │ Status Flags                │
               │ Count Register              │
               └─────────────────────────────┘
```

---

# 📋 Verification Testcases

| Testcase | Description | Result |
|----------|-------------|--------|
| Reset | Verify reset operation | ✅ PASS |
| Single Write / Read | Basic FIFO functionality | ✅ PASS |
| Fill FIFO | Verify Full flag | ✅ PASS |
| Empty FIFO | Verify Empty flag | ✅ PASS |
| Overflow | Prevent writes when full | ✅ PASS |
| Underflow | Prevent reads when empty | ✅ PASS |
| Simultaneous Read / Write | Verify concurrent operations | ✅ PASS |
| Random Stress Test | 1000 random transactions | ✅ PASS |

---

# 📊 Simulation Result

```text
=======================================================
      PARAMETERIZED SYNCHRONOUS FIFO VERIFICATION
=======================================================

TOTAL TESTS : 8
PASSED      : 8
FAILED      : 0

************* ALL TESTS PASSED *************
```

---

# 📂 Project Structure

```text
parameterized-fifo-verification
│
├── rtl
│   └── fifo.sv
│
├── tb
│   ├── fifo_tb.sv
│   ├── fifo_driver.svh
│   ├── fifo_scoreboard.svh
│   ├── fifo_tests.svh
│   └── fifo_utils.svh
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# 🛠 Tools Used

- **Language:** SystemVerilog
- **Simulator:** AMD Vivado XSim 2025.2
- **EDA Tool:** AMD Vivado 2025.2
- **Version Control:** Git & GitHub

---

# 🎯 Results

- ✔ Parameterized FIFO RTL Design
- ✔ Self-checking Verification Environment
- ✔ Reference-model Scoreboard
- ✔ Directed Verification
- ✔ Random Stress Testing
- ✔ **8 / 8 Testcases Passed**

---

# 🚀 Future Improvements

- SystemVerilog Interface
- Assertions (SVA)
- Functional Coverage
- Monitor
- Generator
- Mailbox Communication
- UVM-based Verification

---

# 👨‍💻 Author

**Krishna K S**

Electronics & Communication Engineering

**SystemVerilog | RTL Design | Digital Verification**

---

# 📜 License

This project is licensed under the **MIT License**.
