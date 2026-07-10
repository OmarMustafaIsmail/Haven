# Haven

A modern personal finance platform focused on reducing financial anxiety.

**Navigate your money with confidence.**

## Foundation Documents

Start here for every session:

1. **[HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md)** — why Haven exists (product soul)
2. **[HAVEN_HOME_EXPERIENCE.md](HAVEN_HOME_EXPERIENCE.md)** — daily financial check-in on Home
3. **[HAVEN_FINANCIAL_PULSE.md](HAVEN_FINANCIAL_PULSE.md)** — Check-In interaction specification (v4 source of truth)
4. **[HAVEN_ARCHITECTURE.md](HAVEN_ARCHITECTURE.md)** — engineering architecture
5. **[HDL.md](HDL.md)** — Haven Design Language (discovered while building)
6. **[PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md)** — locked decisions with rationale

## Flutter App

```
lib/
├── main.dart
├── theme/              # Design tokens
├── pulse/              # FinancialPulse system (v3 — refactor to v4)
├── widgets/            # Shared components (PulseOrb — circular form)
└── features/
    ├── home/           # Home orchestrates around FinancialPulse
    └── shell/          # Bottom navigation
```

Brand assets: `assets/brand/logo/` (SVG) · `assets/brand/app-icon/` (PNG)

```bash
flutter run
```

## Current Milestone

**Home Experience v4 (documentation)** — Welcoming first launch. Circular Pulse in header. Connected Check-In (greeting + Pulse together). Content always visible. Simple return to header. See **PD-027**.

Existing `lib/pulse/` code reflects **superseded v3** (abstract glyph, particle return, hidden content) and requires refactor to v4.

## HDL Status

| Area | Status |
|---|---|
| Foundations, Brand Assets | LOCKED |
| Financial Pulse form (circle) | LOCKED (PD-026) |
| Color, Typography, Spacing, Radius | EXPERIMENTAL |
| Motion, Components (FinancialPulse) | EXPERIMENTAL (v4) |
| Elevation | FUTURE |

See [HDL.md](HDL.md) for the full document index.
