# Synthesis Report

![Flow](https://img.shields.io/badge/OpenLane-Synthesis-blue)
![Technology](https://img.shields.io/badge/PDK-SKY130-green)
![Timing](https://img.shields.io/badge/Timing-Passed-brightgreen)
![Language](https://img.shields.io/badge/RTL-Verilog-orange)

## Overview

The asynchronous FIFO RTL was synthesized using **Yosys** as part of the **OpenLane RTL-to-GDSII flow** targeting the **SkyWater SKY130 HD standard cell library**.

The design consists of:
- Parameterized asynchronous FIFO
- Gray code read/write pointers
- Two-stage synchronizers for CDC
- Register-based dual-port memory
- Full and Empty detection logic

---

# Synthesis Statistics

| Metric | Value |
|---------|------:|
| Standard Cells | 747 |
| Wires | 746 |
| Public Wires | 195 |
| Flip-Flops | 176 |
| Multiplexers | 193 |
| Buffers | 164 |
| Total Area | **8440.5952 µm²** |

---

# Memory Inference

The FIFO depth is **16** with a data width of **8 bits**, requiring:

```text
16 × 8 = 128 storage bits
```

No dedicated SRAM macro was inferred during synthesis.

Instead, the memory was implemented using standard-cell flip-flops and multiplexers, which is expected for small memories in the SKY130 OpenLane flow.

---

# Flip-Flop Utilization

The synthesized design contains **176 flip-flops**.

These are used for:

- 128-bit FIFO storage
- Binary read pointer
- Binary write pointer
- Gray-code pointers
- Two-stage synchronizers
- Full/Empty status registers

---

# Timing Summary

| Metric | Result |
|---------|---------|
| Total Negative Slack (TNS) | **0.00 ns** |
| Worst Negative Slack (WNS) | **0.00 ns** |
| Worst Setup Slack | **+7.83 ns** |
| Worst Hold Slack | **+0.35 ns** |

### Timing Analysis

The design successfully meets timing requirements at a **100 MHz** clock frequency.

- ✅ No setup timing violations
- ✅ No hold timing violations
- ✅ Positive setup slack of **7.83 ns**
- ✅ Positive hold slack of **0.35 ns**

---

# Critical Timing Path

The longest timing path consists of combinational logic between two sequential elements.

```
Launch Flip-Flop
        │
        ▼
     Buffers
        │
        ▼
   Multiplexers
        │
        ▼
 Combinational Logic
        │
        ▼
 Capture Flip-Flop
```

Observed timing:

| Parameter | Value |
|-----------|------:|
| Data Arrival Time | 2.05 ns |
| Required Time | 9.88 ns |
| Setup Slack | **+7.83 ns** |

---

# Clock Domain Constraints

The FIFO operates using two asynchronous clock domains:

- `wr_clk`
- `rd_clk`

Static Timing Analysis was constrained using an SDC file that defines both clocks and declares them asynchronous.

```tcl
create_clock -name wr_clk -period 10 [get_ports wr_clk]
create_clock -name rd_clk -period 10 [get_ports rd_clk]

set_clock_groups -asynchronous -group {wr_clk} -group {rd_clk}
```

This ensures that STA analyzes only valid synchronous timing paths while excluding CDC synchronizer paths.

---

# Design Rule Checks

The synthesized netlist passes all major synthesis checks.

| Check | Status |
|-------|--------|
| Setup Timing | ✅ Pass |
| Hold Timing | ✅ Pass |
| Max Slew | ✅ Pass |
| Max Fanout | ✅ Pass |
| Max Capacitance | ✅ Pass |

Warnings regarding missing input/output delays are expected because the FIFO is synthesized as a standalone IP block without external interface constraints.

---

# Key Observations

- Register-based memory implementation was used instead of SRAM macros.
- Gray-code pointers provide reliable clock-domain crossing.
- Two-stage synchronizers reduce the probability of metastability.
- Timing closure was achieved without manual optimization.
- The synthesized design is ready for physical design stages.

---

# Conclusion

The asynchronous FIFO RTL was successfully synthesized into a gate-level implementation consisting of **747 standard cells** occupying **8440.5952 µm²**.

The synthesized design satisfies all setup and hold timing requirements with **zero timing violations**, making it suitable for the subsequent stages of the ASIC design flow, including:

- Floorplanning
- Power Planning
- Placement
- Clock Tree Synthesis (CTS)
- Routing
- Signoff
