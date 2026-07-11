# HDL 08 — Typography

**Status:** EXPERIMENTAL

**Implementation:** [`lib/theme/haven_typography.dart`](../lib/theme/haven_typography.dart)

---

## Purpose

Font families, type scale, and currency formatting rules. Ensures readable, calm financial communication across Haven.

---

## Principles

- Typography creates hierarchy — one primary message per screen.
- Amounts use tabular figures for stability.
- SF Pro conveys premium calm; system fallback until fonts are bundled.
- De-emphasize raw numbers where emotional status matters more (Home Experience v2).

---

## Tokens

### Font families

| Family | Usage |
|---|---|
| `SF Pro Display` | Large amounts, greetings, hero text |
| `SF Pro Text` | Body, captions, card titles |

Bundle `.otf` files in [`assets/fonts/`](../assets/fonts/). Fallback: platform system sans-serif.

### Type scale

| Token | Size | Weight | Usage |
|---|---|---|---|
| `HavenTypography.display` | 40 | Bold | Safe to Spend amount |
| `HavenTypography.hero` | 32 | Semibold | Reserved |
| `HavenTypography.h1` | 28 | Semibold | Greeting |
| `HavenTypography.h2` | 20 | Semibold | Section headers |
| `HavenTypography.title` | 17 | Semibold | Card titles |
| `HavenTypography.body` | 17 | Regular | Status message, body |
| `HavenTypography.bodySmall` | 15 | Regular | Secondary body |
| `HavenTypography.caption` | 13 | Regular | Labels ("Safe to spend") |
| `HavenTypography.number` | display + tabular figures | Bold | Financial figures |

### Currency formatting

| Method | Example |
|---|---|
| `HavenTypography.formatAmount(42350)` | `42,350 EGP` |
| `HavenTypography.formatSignedAmount(-185)` | `-185 EGP` |

Locale: `en_US` grouping, EGP suffix.

---

## Rules

- Use `HavenTypography` tokens — no raw `fontWeight`, `fontSize`, or color in widgets.
- Use `HavenTypography.amountStyle()` or `formatAmount()` for money — never manual string formatting.
- Greeting uses `h1`; card titles use `title` at 17 semibold.
- Do not stack more than two weight levels in one card.

---

## Examples

### Correct

```dart
Text('42,350 EGP', style: HavenTypography.amountStyle())
Text('Safe to spend', style: HavenTypography.caption)
Text(greeting, style: HavenTypography.h1)
```

### Incorrect

```dart
Text('42,350 EGP', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)) // ❌
Text('LOADING...', style: TextStyle(fontSize: 24)) // ❌ alarm copy + hardcoded size
```

---

## Accessibility

- Minimum body size 15 (`bodySmall`) for secondary text; 17 for primary body.
- Dynamic type scaling not yet tokenized — test with system font scaling enabled.
- Financial amounts should remain readable at large accessibility sizes.

---

## Future extensions

- Bundle SF Pro `.otf` files for cross-platform parity
- Localized currency formatting (beyond EGP)
- Dynamic type scale mapping
- Revise `display` scale if amounts stay de-emphasized on Home

---

## Validation notes

- Used on Home: greeting (h1), wellbeing (body), money evidence (bodySmall), guidance (body).
- SF Pro not yet bundled — platform fallback active.

---

## Related

- [HDL/07-color-system.md](07-color-system.md) — text color tokens
- [HDL/20-components.md](20-components.md) — component typography usage
