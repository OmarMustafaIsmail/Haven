# HDL 01 — Brand Assets

**Status:** `locked`

Logo usage rules and asset inventory. Construction rules are locked in [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md).

Reference: [assets/brand/brand-identity.png](../assets/brand/brand-identity.png)

---

## Logo Concept

The **Hidden Compass H** — a minimalist geometric uppercase H. The horizontal crossbar is a compass needle pointing North. The H is noticed first; the compass is discovered over time.

### Construction Grid

| Element | Measurement |
|---|---|
| Vertical bar width | 2X |
| Gap between bars | X |
| Compass bar height | X |
| Clear space (all sides) | X |
| Corner radius | Rounded on all geometric elements |

### Minimum Size

- Digital: 16px height
- Print: 12mm height

---

## Asset Inventory

**Figma source:** [Haven Brand Assets](https://www.figma.com/design/qJe22LWuxcsQ0bcLxg0eov/Haven-Brand-Assets)

Export guide: [`assets/brand/source/FIGMA_EXPORT.md`](../assets/brand/source/FIGMA_EXPORT.md)

Automated export: `python scripts/figma_export_logos.py` (requires `FIGMA_TOKEN`)

### Logo — SVG

| File | Description | Figma node |
|---|---|---|
| [`haven-icon-primary.svg`](../assets/brand/logo/haven-icon-primary.svg) | Primary teal H icon | `2:5` Logo/ H primary |
| [`haven-icon-light.svg`](../assets/brand/logo/haven-icon-light.svg) | Light variant | `2:6` Logo/ H light |
| [`haven-icon-dark.svg`](../assets/brand/logo/haven-icon-dark.svg) | Dark variant | `2:8` Logo/ H dark |
| [`haven-icon-only.svg`](../assets/brand/logo/haven-icon-only.svg) | Alias for primary icon | `2:5` |

### Logo — PNG

Exported from SVG at heights: 1024, 512, 256, 128, 64, 32, 16.

| Directory | Contents |
|---|---|
| [`assets/brand/logo/png/`](../assets/brand/logo/png/) | Full logo PNG exports |
| [`assets/brand/logo/png/icon-only/`](../assets/brand/logo/png/icon-only/) | Icon-only PNG exports |

### App Icon — PNG

| File | Size | Platform | Figma node |
|---|---|---|---|
| `icon-light-1024.png` | 1024×1024 | iOS App Store | `2:16` App logo |
| `icon-light-512.png` | 512×512 | iOS |
| `icon-light-180.png` | 180×180 | iOS Settings |
| `icon-dark-1024.png` | 1024×1024 | iOS App Store (dark) |
| `icon-dark-192.png` | 192×192 | Android |
| `icon-mono-1024.png` | 1024×1024 | Monochrome |
| `icon-mono-32.png` | 32×32 | Favicon |

Located in [`assets/brand/app-icon/`](../assets/brand/app-icon/).

---

## Usage Rules

### Do

- Maintain clear space equal to X (crossbar height) on all sides.
- Use provided SVG when possible (infinitely scalable).
- Use monochrome variants on photography or busy backgrounds.
- Use icon-only variant when space is constrained.

### Do Not

- Rotate the logo.
- Stretch or distort proportions.
- Change brand colors (e.g., orange).
- Add drop shadows, glows, or effects to the logo.
- Place the logo smaller than 16px (digital) or 12mm (print).
