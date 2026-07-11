# HDL 11 — Elevation & Materials

**Status:** FUTURE

---

## Purpose

Shadows, blur, glass effects, and material hierarchy for surfaces. Defines depth when Haven needs layers beyond flat whitespace.

Home Experience v2 intentionally avoids card elevation — hierarchy comes from whitespace and typography. Elevation tokens will be designed when screens genuinely need depth (modals, sheets, overlays).

---

## Principles

- Depth is rare — flat calm is the default.
- Elevation communicates layering (modal over content), not decoration.
- No drop shadows on standard content cards.
- iOS-quality materials when blur/glass is introduced — not generic Material elevation.

---

## Tokens

No token file yet. **Do not define shadow or blur values until validated in context.**

---

## Rules

- Do not add shadows to `HavenCard` or Home content cards.
- Do not hardcode `BoxShadow` in widgets — wait for `HavenElevation` tokens.
- Modals and sheets must be designed with elevation tokens before implementation.

---

## Examples

### Correct (current Home)

- Flat `HavenCard` with `borderSubtle` hairline — no shadow
- Hierarchy via typography and spacing

### Incorrect

```dart
BoxShadow(blurRadius: 8, ...) // ❌ no elevation tokens yet
```

---

## Accessibility

- Overlays must trap focus and dim background appropriately when designed.
- Sufficient contrast between elevated surface and scrim.

---

## Future extensions

| Planned | Notes |
|---|---|
| Glass and blur effects | iOS-quality |
| Card elevation hierarchy | If cards return in other contexts |
| Background hierarchy | Shell vs modal vs sheet |
| Shadow tokens | Named levels, not raw values |
| Material system | Light-first; dark parity later |

---

## Validation notes

Not yet designed. No screens currently require elevation tokens.

---

## Related

- [HDL/07-color-system.md](07-color-system.md) — surface colors
- [HDL/20-components.md](20-components.md) — HavenCard (flat by design)
