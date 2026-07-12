# Haven Design Language (HDL)

The HDL is Haven's **design system source of truth** — colors, typography, spacing, motion, Pulse, and components. Product architecture lives in [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md).

---

## How to use this system

### For engineers and AI agents

1. Read [HDL/00-foundations.md](HDL/00-foundations.md) for principles.
2. Implement tokens from [`lib/theme/`](lib/theme/) — never hardcode values.
3. For Check-In / Pulse: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md) is **self-contained** — implement from this doc alone.
4. For UI components: [HDL/20-components.md](HDL/20-components.md) catalog.
5. Check [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) before changing locked behaviour.

### Document structure

Every HDL document uses this hierarchy where applicable:

| Section | Contents |
|---|---|
| **Purpose** | Why this system exists |
| **Principles** | Design philosophy |
| **Tokens** | Named values (tables) |
| **Rules** | Hard implementation rules |
| **Examples** | Correct vs incorrect usage |
| **Accessibility** | A11y considerations |
| **Future extensions** | Reserved for later versions |

---

## How HDL evolves

1. **Build first.** Ship real screens with real content.
2. **Validate in context.** Test calm, clear, confident on actual member flows.
3. **Extract patterns.** Name what worked.
4. **Then standardize.** Lock tokens and components only after validation.

---

## Status taxonomy

| Status | Meaning |
|---|---|
| **LOCKED** | Proven in product. Canonical. |
| **EXPERIMENTAL** | Being validated. May change. |
| **FUTURE** | Not yet designed. |

---

## Documents

| # | Document | Status | Scope |
|---|---|---|---|
| 00 | [Foundations](HDL/00-foundations.md) | LOCKED | Principles, quality bar |
| 01 | [Brand Assets](HDL/01-brand-assets.md) | LOCKED | Logo, assets |
| 07 | [Color System](HDL/07-color-system.md) | EXPERIMENTAL | Palette, semantic, Pulse colors |
| 08 | [Typography](HDL/08-typography.md) | EXPERIMENTAL | Type scale, currency |
| 09 | [Spacing](HDL/09-spacing.md) | EXPERIMENTAL | 8pt grid |
| 10 | [Radius](HDL/10-radius.md) | EXPERIMENTAL | Corner radii |
| 11 | [Elevation & Materials](HDL/11-elevation.md) | FUTURE | Shadows, blur |
| 12 | [Motion](HDL/12-motion.md) | EXPERIMENTAL | Global motion principles |
| 13 | [Financial Pulse](HDL/13-financial-pulse.md) | LOCKED / EXPERIMENTAL | **Definitive Pulse spec** |
| 20 | [Components](HDL/20-components.md) | LOCKED | Component catalog |

### Cross-reference map (avoid duplication)

| Topic | Authoritative doc |
|---|---|
| Pulse interaction, motion, haptics, API | **13** |
| Pulse color meaning in context | **13** (tokens in **07**) |
| Global motion principles | **12** |
| Component variants, states, spacing | **20** |
| Product journey, member rituals | [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md) |
| Locked decisions | [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) |

---

## Design tokens (implementation)

Code in [`lib/theme/`](lib/theme/) is the implementation source. HDL explains *why*.

| Token file | HDL reference |
|---|---|
| [`haven_colors.dart`](lib/theme/haven_colors.dart) | [07 — Color System](HDL/07-color-system.md) |
| [`haven_typography.dart`](lib/theme/haven_typography.dart) | [08 — Typography](HDL/08-typography.md) |
| [`haven_spacing.dart`](lib/theme/haven_spacing.dart) | [09 — Spacing](HDL/09-spacing.md) |
| [`haven_radius.dart`](lib/theme/haven_radius.dart) | [10 — Radius](HDL/10-radius.md) |
| [`haven_motion.dart`](lib/theme/haven_motion.dart) | [12 — Motion](HDL/12-motion.md) + [13 — Pulse](HDL/13-financial-pulse.md) |

---

## Related

- [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md) — product soul
- [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md) — product architecture
- [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) — locked decisions
