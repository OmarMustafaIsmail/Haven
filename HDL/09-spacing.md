# HDL 09 — Spacing

## Purpose

Spacing scale based on an 8pt grid for margins, padding, and layout rhythm.

## Status

**EXPERIMENTAL**

## Reasoning

An 8pt grid provides consistent rhythm across Home screen elements. Values were extracted from Home mock v1 implementation patterns.

## Validation notes

- Used on Home Experience v2 for hero zone, guidance, and activity spacing.
- Not yet validated on other screens or component library.
- Safe area insets handled by Flutter `SafeArea` — not yet tokenized.

## Implementation notes

**Flutter tokens:** [`lib/theme/haven_spacing.dart`](../lib/theme/haven_spacing.dart)

| Token | Value | Current usage |
|---|---|---|
| `xs` | 4 | Tight gaps, icon padding |
| `sm` | 8 | Small vertical rhythm |
| `md` | 16 | Standard padding, horizontal margins |
| `lg` | 24 | Section spacing, hero padding |
| `xl` | 32 | Pulse orb base size |
| `xxl` | 48 | Bottom scroll padding, hero top spacing |

---

## Planned (not yet validated)

- Safe area inset tokens
- Component-specific spacing rules
- Responsive spacing for tablet
