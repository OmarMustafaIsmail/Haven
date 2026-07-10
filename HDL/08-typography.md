# HDL 08 — Typography

## Purpose

Font families, type scale, and currency formatting rules.

## Status

**EXPERIMENTAL**

## Reasoning

Typography tokens were defined to support Home mock v1. SF Pro is referenced by family name with system fallback until font files are bundled.

## Validation notes

- Used on Home screen: greeting (h1), wellbeing answer (body), money evidence (bodySmall), guidance (body).
- SF Pro `.otf` files not yet bundled — rendering uses platform fallback.
- Amount display de-emphasized in Home Experience v2 — display scale may need revision.

## Implementation notes

**Flutter tokens:** [`lib/theme/haven_typography.dart`](../lib/theme/haven_typography.dart)

---

## Font Families

| Family | Usage |
|---|---|
| `SF Pro Display` | Large amounts, greetings, hero text |
| `SF Pro Text` | Body, captions, card titles |

Bundle `.otf` files in [`assets/fonts/`](../assets/fonts/). See README there.

Fallback: platform system sans-serif until fonts are bundled.

---

## Type Scale

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

---

## Currency Formatting

| Method | Example |
|---|---|
| `HavenTypography.formatAmount(42350)` | `42,350 EGP` |
| `HavenTypography.formatSignedAmount(-185)` | `-185 EGP` |

- Locale: `en_US` grouping, EGP suffix
- Numbers use tabular figures via `HavenTypography.number`

---

## Usage

```dart
Text('42,350 EGP', style: HavenTypography.amountStyle())
Text('Safe to spend', style: HavenTypography.caption)
Text(greeting, style: HavenTypography.h1)
```

Do not use raw `fontWeight`, `fontSize`, or `Colors` in widgets.
