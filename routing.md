# Routing

## Objective

Routing is the final physical implementation stage that establishes all electrical interconnections between the placed standard cells. It consists of two phases:

- **Global Routing** – Determines an approximate routing path for every net.
- **Detailed Routing** – Generates the final manufacturable metal wires and vias while satisfying all design rule constraints (DRC).

---

# Global Routing

## Routing Configuration

| Parameter | Value |
|-----------|-------|
| Signal Routing Layers | Metal1 – Metal5 |
| Clock Routing Layers | Metal3 – Metal5 |

The clock network is routed using higher metal layers to reduce resistance, delay, and clock skew.

---

## Routing Resources

| Layer | Preferred Direction |
|--------|---------------------|
| Metal1 | Horizontal |
| Metal2 | Vertical |
| Metal3 | Horizontal |
| Metal4 | Vertical |
| Metal5 | Horizontal |

---

## Global Routing Statistics

| Metric | Value |
|--------|------:|
| Routed Nets | 801 |
| Estimated Wire Length | 29,159 µm |
| Estimated Vias | 3,335 |
| Routing Congestion | 15.61% |
| Routing Overflow | 0 |
| Antenna Violations | 0 |

---

## Congestion Report

| Layer | Usage |
|--------|------:|
| Metal1 | 22.35% |
| Metal2 | 23.67% |
| Metal3 | 2.21% |
| Metal4 | 3.12% |
| Metal5 | 0.00% |

---

## Observations

- Successfully routed all 801 nets.
- Routing congestion remained very low.
- Zero routing overflow was observed.
- No antenna violations were detected.
- The design is fully routable.

---

# Detailed Routing

## Objective

Detailed Routing converts the global routing guides into actual metal geometries by assigning exact routing tracks, vias, wire widths, and spacing while satisfying all manufacturing design rules.

---

## Optimization Progress

| Iteration | Routing Violations |
|-----------|------------------:|
| Initial | 349 |
| 1 | 105 |
| 2 | 200 |
| 3 | 9 |
| Final | **0** |

The detailed router iteratively resolves spacing and short-circuit violations until a DRC-clean solution is achieved.

---

## Final Routing Statistics

| Metric | Value |
|--------|------:|
| Final Wire Length | 18,581 µm |
| Final Number of Vias | 4,941 |
| Final Routing Violations | **0** |

---

## Metal Layer Distribution

| Layer | Wire Length |
|--------|------------:|
| Metal1 | 8,909 µm |
| Metal2 | 8,617 µm |
| Metal3 | 778 µm |
| Metal4 | 276 µm |
| Metal5 | 0 µm |

Most of the routing is performed on Metal1 and Metal2, which is expected for a relatively small standard-cell based design.

---

# Post-Route Static Timing Analysis (STA)

After routing, Static Timing Analysis (STA) was performed using the extracted routing parasitics.

## Timing Summary

| Metric | Value |
|--------|------:|
| Total Negative Slack (TNS) | 0.00 ns |
| Worst Negative Slack (WNS) | 0.00 ns |
| Worst Setup Slack | 8.13 ns |
| Worst Hold Slack | 0.34 ns |

---

## Timing Evolution Throughout Physical Design

| Stage | Setup Slack | Hold Slack |
|--------|------------:|-----------:|
| Synthesis | 7.83 ns | 0.35 ns |
| Placement | 7.52 ns | 0.35 ns |
| Clock Tree Synthesis | 8.00 ns | 0.35 ns |
| Post-Route | **8.13 ns** | **0.34 ns** |

The routed design achieved complete timing closure without any setup or hold violations.

---

# Key Achievements

- Successfully routed all 801 signal nets.
- Achieved zero routing overflow.
- No antenna violations.
- Zero routing DRC violations after optimization.
- Successfully met all setup and hold timing requirements.
- Completed routing with low congestion and efficient metal utilization.

---

# Conclusion

The routing stage successfully transformed the placed netlist into a manufacturable physical layout by generating legal metal interconnections and vias. Global routing produced congestion-free routing guides, while detailed routing eliminated all spacing and short-circuit violations through iterative optimization.

The final routed design satisfies all timing constraints with zero setup and hold violations, demonstrating successful timing closure and physical implementation of the asynchronous FIFO design.

---

