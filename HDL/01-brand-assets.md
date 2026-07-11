# HDL 01 — Brand Assets

**Status:** LOCKED

**Implementation:** [`lib/widgets/haven_logo.dart`](../lib/widgets/haven_logo.dart) · [`assets/brand/`](../assets/brand/)

**Decisions:** PD-005, PD-006, PD-017 in [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md)

---

## Purpose

Logo usage rules, construction specifications, and asset inventory. Ensures the Haven mark renders consistently across digital and print.

**Figma source:** [Haven Brand Assets](https://www.figma.com/design/qJe22LWuxcsQ0bcLxg0eov/Haven-Brand-Assets)

---

## Principles

- The **Hidden Compass H** — minimalist geometric uppercase H. Horizontal crossbar is a compass needle pointing North.
- The H is noticed first; the compass is discovered over time.
- Logo integrity over decoration — no effects, no off-brand colors.
- SVG preferred for scalability.

---

## Tokens

Brand colors for logo usage align with [HDL/07-color-system.md](07-color-system.md):

| Context | Token |
|---|---|
| Primary mark | `HavenColors.primary` |
| Light variant backgrounds | `HavenColors.surface` |
| Dark variant backgrounds | `HavenColors.primaryDark` |

---

## Construction

| Element | Measurement |
|---|---|
| Vertical bar width | 2X |
| Gap between bars | X |
| Compass bar height | X |
| Clear space (all sides) | X |
| Corner radius | Rounded on all geometric elements |

### Minimum size

- Digital: 16px height
- Print: 12mm height

---

## Asset inventory

Export guide: [`assets/brand/source/FIGMA_EXPORT.md`](../assets/brand/source/FIGMA_EXPORT.md)

Automated export: `python scripts/figma_export_logos.py` (requires `FIGMA_TOKEN`)

### Logo — SVG

| File | Description |
|---|---|
| `haven-icon-primary.svg` | Primary teal H icon |
| `haven-icon-light.svg` | Light variant |
| `haven-icon-dark.svg` | Dark variant |
| `haven-icon-only.svg` | Alias for primary icon |

### Logo — PNG

Exported at heights: 1024, 512, 256, 128, 64, 32, 16 in `assets/brand/logo/png/`.

### App icon — PNG

Located in `assets/brand/app-icon/` — light, dark, and monochrome variants for iOS and Android.

Reference: [`assets/brand/brand-identity.png`](../assets/brand/brand-identity.png)

---

## Rules

### Do

- Maintain clear space equal to X (crossbar height) on all sides.
- Use provided SVG when possible.
- Use monochrome variants on photography or busy backgrounds.
- Use icon-only variant when space is constrained.

### Do not

- Rotate the logo.
- Stretch or distort proportions.
- Change brand colors (e.g., orange).
- Add drop shadows, glows, or effects.
- Place smaller than 16px (digital) or 12mm (print).

---

## Examples

### Correct

- `HavenLogo(height: 28)` in top bar with clear space
- Primary SVG on light `surface` background

### Incorrect

- Logo at 12px height on mobile ❌
- Orange-tinted H for seasonal campaign ❌
- Drop shadow behind logo for "depth" ❌

---

## Accessibility

- When logo is decorative alongside "Haven" wordmark elsewhere, mark SVG as decorative.
- When logo is the only brand identifier, provide accessible name: "Haven".

---

## Future extensions

- Wordmark lockup specifications (if separate from icon)
- Co-branding rules
- Print color profile documentation

---

## Validation notes

- Logo exported from Figma and rendered via `flutter_svg`.
- App icons generated via `flutter_launcher_icons`.
- Construction grid validated against brand identity reference.

---

## Related

- [HDL/07-color-system.md](07-color-system.md) — brand color tokens
- [HDL/20-components.md](20-components.md) — HavenLogo component
