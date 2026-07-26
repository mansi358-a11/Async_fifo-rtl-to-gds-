# Clock Tree Synthesis (CTS)

## Overview

Clock Tree Synthesis (CTS) constructs the physical clock distribution network after placement. It inserts clock buffers and routes the clock signal to sequential elements while minimizing clock skew and maintaining timing.

---

## Clock Analysis

| Clock | Latency | Skew |
|--------|--------:|-----:|
| `rd_clk` | 0.25 ns | ~0.00 ns |
| `wr_clk` | 0.31–0.33 ns | 0.02 ns |

---

## Observations

- The clock network is no longer modeled as ideal.
- CTS introduced realistic clock insertion delays through clock buffers.
- The `rd_clk` network is nearly perfectly balanced.
- The `wr_clk` network exhibits only 20 ps of skew, indicating effective clock balancing.
- No Clock Reconvergence Pessimism Removal (CRPR) adjustment was required for the reported paths.

---

## Timing Impact

Compared to the placement stage, CTS maintained zero setup and hold violations while slightly improving the worst setup slack from **7.52 ns** to **8.00 ns**. This demonstrates that the synthesized clock tree distributes the clock efficiently without introducing significant timing imbalance.
