# HDL 00 — Foundations

**Status:** LOCKED

---

## Purpose

The principles and conventions governing every Haven Design Language decision. Read this first — all other HDL documents inherit from here.

Product soul lives in [HAVEN_MANIFESTO.md](../HAVEN_MANIFESTO.md). Product architecture in [PRODUCT_ARCHITECTURE.md](../PRODUCT_ARCHITECTURE.md). HDL covers **visual and interaction implementation**.

---

## Principles

### Design principles

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

### Visual style

The interface should feel Apple-level minimal, premium, quiet, elegant, modern, and timeless.

**Avoid:** neon colors, heavy gradients, complex dashboards, financial clichés, charts everywhere, visual clutter.

Whitespace is part of the design. Everything should breathe.

### Inspiration sources

Study principles from — do not copy:

- Apple Human Interface Guidelines
- Linear
- Mercury
- Arc Browser
- Things 3

### Quality bar

Before shipping any screen, ask:

- Would Apple ship this?
- Would Linear simplify this?
- Would Copilot Money remove another element?

If not, simplify further.

---

## Tokens

Foundations has no direct token file. Tokens live in [`lib/theme/`](../lib/theme/) and are documented per system:

| System | Document |
|---|---|
| Color | [07-color-system.md](07-color-system.md) |
| Typography | [08-typography.md](08-typography.md) |
| Spacing | [09-spacing.md](09-spacing.md) |
| Radius | [10-radius.md](10-radius.md) |
| Motion | [12-motion.md](12-motion.md) |
| Pulse | [13-financial-pulse.md](13-financial-pulse.md) |

Code tokens are implementation source. HDL documents explain *why*.

---

## Rules

- No hardcoded design values in widgets — use Haven tokens.
- Refer to people as **members**, not users.
- Check [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md) before changing locked decisions.
- Log new locked decisions with date and rationale.
- Consistency beats novelty — do not redesign validated patterns without compelling reason.
- HDL evolves: build → validate → extract → standardize.

---

## Examples

### Correct

- Safe to Spend uses `HavenTypography.display` + `HavenColors.textPrimary`
- One hero message on Home; secondary content below the fold
- Check-In language: "Reading your Pulse" not "Loading…"

### Incorrect

- Hardcoded `#1D544E` in a widget ❌
- Dashboard with six competing metrics on Home ❌
- "Pull to refresh" copy ❌
- Red alarm styling for gentle attention states ❌

---

## Accessibility

- Accessibility is a feature, not an afterthought.
- Never communicate state through color alone.
- Financial copy must be plain language — no jargon without explanation.
- Motion and haptics supplement accessible text — never replace it.

---

## Future extensions

- Dark mode foundations (after light experience is complete)
- Tablet and responsive layout principles
- Localization typography rules
- Component-level accessibility checklist in HDL/20

---

## Validation notes

- Brand identity validated in Figma and exported to production assets.
- Home Concept C scored highest on emotional criteria.
- Home Experience applies: one hero (Financial Pulse), confidence before data, subtraction over addition.

---

## Related

- [HAVEN_MANIFESTO.md](../HAVEN_MANIFESTO.md)
- [PRODUCT_ARCHITECTURE.md](../PRODUCT_ARCHITECTURE.md)
- [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md)
- [HDL.md](../HDL.md) — document index
