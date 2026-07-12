# HDL 10 — Radius

**Status:** EXPERIMENTAL

**Implementation:** [`lib/theme/haven_radius.dart`](../lib/theme/haven_radius.dart)

---

## Purpose

Border radius scale for cards, buttons, sheets, and containers. Rounded corners communicate calm and approachability.

---

## Principles

- Larger radius on larger surfaces — cards use `lg`, small elements use `sm`.
- Consistent radius within a component — `InkWell` must match container radius.
- `full` (999) for circular elements only.

---

## Tokens

| Token | Value | Usage |
|---|---|---|
| `HavenRadius.sm` | 8 | Small elements, activity avatars |
| `HavenRadius.md` | 16 | Buttons (`HavenPrimaryButton`) |
| `HavenRadius.lg` | 24 | `HavenCard` |
| `HavenRadius.xl` | 32 | Reserved |
| `HavenRadius.full` | 999 | Circular elements |
| `HavenRadius.sheet` | 24 (`lg`) | Bottom sheet top corners (PD-037) |
| `HavenRadius.input` | 16 (`md`) | Text fields and selects (PD-037) |

---

## Rules

- `HavenCard` always uses `lg` — do not override without design review.
- Button radius: `md` until sheet/dialog tokens exist.
- When wrapping tappable cards, `InkWell.borderRadius` must equal container radius.

---

## Examples

### Correct

```dart
BorderRadius.circular(HavenRadius.lg)  // HavenCard
BorderRadius.circular(HavenRadius.md)  // HavenPrimaryButton
```

### Incorrect

```dart
BorderRadius.circular(20) // ❌ off-scale
BorderRadius.circular(12) // ❌ not a Haven token
```

---

## Accessibility

Radius does not replace adequate tap target size — pair with spacing tokens.

---

## Future extensions

- Sheet and dialog radius
- Input field radius
- Bottom sheet top corner standard

---

## Validation notes

- `lg` (24) validated on `HavenCard` for Home v5.
- Button radius validated in `HavenPrimaryButton` — not yet used on Home.

---

## Related

- [HDL/20-components.md](20-components.md) — HavenCard, HavenPrimaryButton
- [HDL/09-spacing.md](09-spacing.md) — padding scale
