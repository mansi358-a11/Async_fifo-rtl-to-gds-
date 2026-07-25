# Placement Analysis

## Overview

The synthesized netlist was legalized using OpenROAD's Detailed Placement (DPL) stage. Cell locations were adjusted onto legal placement rows while minimizing wire length and maintaining timing.

---

## Timing Comparison

| Metric | After Synthesis | After Placement |
|---------|----------------:|----------------:|
| Read Path Arrival | 2.05 ns | 2.36 ns |
| Read Path Slack | 7.83 ns | 7.52 ns |
| Write Path Arrival | 2.00 ns | 2.16 ns |
| Write Path Slack | 7.91 ns | 7.75 ns |

The slight increase in arrival time is expected because placement introduces realistic interconnect delays based on the physical locations of standard cells.

---

## Placement Observations

- Cells were successfully legalized.
- No setup timing violations were introduced.
- No maximum slew violations.
- No maximum fanout violations.
- No maximum capacitance violations.

The design maintains comfortable timing margins after placement and is ready for Clock Tree Synthesis.
