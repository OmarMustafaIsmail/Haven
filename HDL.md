# Haven Design Language (HDL)

The HDL is no longer a specification written ahead of the product.

It is a **living design language** discovered while building Haven.

---

## How HDL Evolves

1. **Build first.** Ship real screens with real content.
2. **Validate in context.** Test whether patterns feel calm, clear, and confident on actual member flows.
3. **Extract patterns.** Name what worked — colors, spacing, motion, voice.
4. **Then standardize.** Lock tokens and components only after validation.

The HDL should evolve with the product rather than dictate it. Avoid documenting hypothetical decisions.

---

## Status Taxonomy

Every HDL section is one of three states:

| Status | Meaning |
|---|---|
| **LOCKED** | Already proven in the product. Safe to treat as canonical. |
| **EXPERIMENTAL** | Being validated on Home. May change. |
| **FUTURE** | Not yet designed. No tokens documented. |

---

## Document Template

Every HDL document includes:

- **Purpose** — what this section governs
- **Status** — LOCKED, EXPERIMENTAL, or FUTURE
- **Reasoning** — why these choices were made
- **Validation notes** — where and how they were tested
- **Implementation notes** — where tokens live in code (when applicable)

---

## Documents

| # | Document | Status |
|---|---|---|
| 00 | [Foundations](HDL/00-foundations.md) | LOCKED |
| 01 | [Brand Assets](HDL/01-brand-assets.md) | LOCKED |
| 07 | [Color System](HDL/07-color-system.md) | EXPERIMENTAL |
| 08 | [Typography](HDL/08-typography.md) | EXPERIMENTAL |
| 09 | [Spacing](HDL/09-spacing.md) | EXPERIMENTAL |
| 10 | [Radius](HDL/10-radius.md) | EXPERIMENTAL |
| 11 | [Elevation & Materials](HDL/11-elevation.md) | FUTURE |
| 12 | [Motion](HDL/12-motion.md) | EXPERIMENTAL |
| 13 | [Financial Pulse](HDL/13-financial-pulse.md) | LOCKED (form) / EXPERIMENTAL (motion) |
| 20 | [Components](HDL/20-components.md) | EXPERIMENTAL |

## Design Tokens (Implementation)

Code tokens in [`lib/theme/`](lib/theme/) are the implementation source. HDL documents explain *why* — they do not dictate ahead of build.

| Token file | HDL reference | Status |
|---|---|---|
| [`haven_colors.dart`](lib/theme/haven_colors.dart) | [07 — Color System](HDL/07-color-system.md) | EXPERIMENTAL |
| [`haven_typography.dart`](lib/theme/haven_typography.dart) | [08 — Typography](HDL/08-typography.md) | EXPERIMENTAL |
| [`haven_spacing.dart`](lib/theme/haven_spacing.dart) | [09 — Spacing](HDL/09-spacing.md) | EXPERIMENTAL |
| [`haven_radius.dart`](lib/theme/haven_radius.dart) | [10 — Radius](HDL/10-radius.md) | EXPERIMENTAL |
| [`haven_motion.dart`](lib/theme/haven_motion.dart) | [12 — Motion](HDL/12-motion.md) | EXPERIMENTAL |
| [`haven_theme.dart`](lib/theme/haven_theme.dart) | Theme built from tokens | EXPERIMENTAL |

---

## Related

- [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md) — product soul
- [HAVEN_HOME_EXPERIENCE.md](HAVEN_HOME_EXPERIENCE.md) — emotional experience spec
- [HAVEN_FINANCIAL_PULSE.md](HAVEN_FINANCIAL_PULSE.md) — signature interaction spec
- [HAVEN_ARCHITECTURE.md](HAVEN_ARCHITECTURE.md) — engineering architecture
- [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) — locked decisions with rationale
