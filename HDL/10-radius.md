# HDL 10 — Radius

## Purpose

Border radius scale for cards, buttons, sheets, and containers.

## Status

**EXPERIMENTAL**

## Reasoning

Rounded corners communicate calm and approachability. Values were chosen during Home mock v1 for HavenCard and button components.

## Validation notes

- `lg` (24) used for HavenCard on Home v1 — Home Experience v2 reduces card usage.
- Button radius not yet validated in production UI.
- Sheet, dialog, and input radius not yet designed.

## Implementation notes

**Flutter tokens:** [`lib/theme/haven_radius.dart`](../lib/theme/haven_radius.dart)

| Token | Value | Current usage |
|---|---|---|
| `sm` | 8 | Small elements |
| `md` | 16 | Icon containers |
| `lg` | 24 | HavenCard |
| `xl` | 32 | Reserved |
| `full` | 999 | Circular elements |

---

## Planned (not yet validated)

- Button radius standardization
- Sheet and dialog radius
- Input field radius
