# HDL 09 — Spacing

**Status:** EXPERIMENTAL

**Implementation:** [`lib/theme/haven_spacing.dart`](../lib/theme/haven_spacing.dart)

---

## Purpose

Spacing scale based on an 8pt grid for margins, padding, and layout rhythm across Haven.

---

## Principles

- Consistent rhythm reduces cognitive load.
- Whitespace is intentional — cards and sections must breathe.
- Prefer token combinations over arbitrary pixel values.
- Safe area handled by Flutter `SafeArea` — not yet tokenized.

---

## Tokens

| Token | Value | Usage |
|---|---|---|
| `HavenSpacing.xs` | 4 | Tight gaps, icon padding |
| `HavenSpacing.sm` | 8 | Small vertical rhythm |
| `HavenSpacing.md` | 16 | Standard padding, horizontal margins |
| `HavenSpacing.lg` | 24 | Section spacing, card padding |
| `HavenSpacing.xl` | 32 | Reserved |
| `HavenSpacing.xxl` | 48 | Bottom scroll padding, hero top spacing |

---

## Rules

- Use `HavenSpacing` exclusively — no magic numbers in widgets.
- Card default margin: horizontal `md`, vertical `sm` (see `HavenCard`).
- Card default padding: `lg`.
- Section title horizontal inset: `md` to align with cards.

---

## Examples

### Correct

```dart
padding: const EdgeInsets.all(HavenSpacing.lg),
const SizedBox(height: HavenSpacing.sm),
```

### Incorrect

```dart
padding: const EdgeInsets.all(20), // ❌ not on grid
const SizedBox(height: 12),         // ❌ arbitrary
```

---

## Accessibility

- Ensure tap targets meet minimum 44×44 logical pixels — add padding tokens, not shrink text.
- Adequate spacing between tappable rows in lists (minimum `sm` vertical).

---

## Future extensions

- Safe area inset tokens
- Component-specific spacing rules (catalog in HDL/20)
- Responsive spacing for tablet

---

## Validation notes

- Used on Home Experience v2 for hero zone, guidance, and activity spacing.
- Not yet validated on other screens.

---

## Related

- [HDL/20-components.md](20-components.md) — per-component spacing
- [HDL/10-radius.md](10-radius.md) — corner radius scale
