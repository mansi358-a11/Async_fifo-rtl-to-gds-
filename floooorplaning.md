# Floorplanning

## Die and Core Dimensions

The generated floorplan consists of the following geometry:

| Parameter | Value |
|-----------|-------|
| Die Width | 156.305 µm |
| Die Height | 167.025 µm |
| Core Width | 144.90 µm |
| Core Height | 144.16 µm |

---

## Die Area

The overall die dimensions are:

```
156.305 µm × 167.025 µm
```

Resulting in an approximate die area of:

```
26107 µm²
```

---

## Core Area

The core dimensions are:

```
144.90 µm × 144.16 µm
```

Resulting in an approximate core area of:

```
20891 µm²
```

The core is centered inside the die while leaving sufficient margin for IO cells, power routing, and physical design infrastructure.

---

## Estimated Core Utilization

From synthesis:

- Cell Area = **8440.6 µm²**

Estimated utilization:

```
8440.6 / 20891 ≈ 40%
```

This moderate utilization provides sufficient whitespace for placement optimization, clock tree synthesis, and routing.

---

## Observations

- Standard cells are placed only inside the core region.
- The surrounding die margin is reserved for physical implementation structures such as power rails, IO pins, and routing resources.
- The design has ample routing space, reducing the likelihood of congestion during later implementation stages.
