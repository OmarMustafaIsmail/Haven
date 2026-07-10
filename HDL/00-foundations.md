# HDL 00 — Foundations

**Status:** `locked`

The principles and conventions that govern every Haven Design Language decision.

---

## Design Principles

- Calm over exciting.
- Confidence before data.
- One primary message per screen.
- Motion communicates.
- Beautiful by subtraction.
- Automation over manual work.
- Trust is the product.
- Accessibility is a feature.
- Members are never judged.
- Explain every recommendation.

---

## Visual Style

The interface should feel Apple-level minimal, premium, quiet, elegant, modern, and timeless.

**Avoid:** neon colors, heavy gradients, complex dashboards, financial clichés, charts everywhere, visual clutter.

Whitespace is part of the design. Everything should breathe.

---

## Inspiration Sources

Study principles from—do not copy:

- Apple Human Interface Guidelines
- Linear
- Mercury
- Arc Browser
- Things 3

---

## Token Naming Convention

All design values are expressed as tokens. No hardcoded values in implementation.

| Token family | Purpose |
|---|---|
| `HavenColors` | Color palette and semantic colors |
| `HavenTypography` | Type scale, weights, line heights |
| `HavenSpacing` | Spacing scale |
| `HavenRadius` | Border radius scale |
| `HavenMotion` | Duration, easing, animation principles |
| `HavenElevation` | Shadows, blur, materials |

Flutter token files live in [`design_tokens/`](../design_tokens/). Figma variable names must match 1:1.

---

## HDL Roadmap

| # | Document | Status |
|---|---|---|
| 00 | Foundations | locked |
| 01 | Brand Assets | locked |
| 07 | Color System | locked |
| 08 | Typography | pending |
| 09 | Spacing | pending |
| 10 | Radius | pending |
| 11 | Elevation & Materials | pending |
| 12 | Motion | pending |
| 20 | Components | pending |
