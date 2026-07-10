# HDL 13 — Financial Pulse

## Purpose

Visual specification for the Financial Pulse — a **simple circle** in the Home Header. Form is locked (PD-026). Identity comes from motion and behaviour.

## Status

**LOCKED** (form) · **EXPERIMENTAL** (v4 Check-In motion)

## Reasoning

The circle is timeless, calm, and neutral. Haven's recognizability is built through ritual and emotional design — not through complex symbol design. v3 abstract glyph exploration is rejected.

---

## Form (Locked — PD-026)

| Attribute | Specification |
|---|---|
| Shape | **Circle** — perfect round, soft multi-layer glow |
| Passive size | ~20–24px diameter in Home Header |
| Check-In size | Expands slightly during heartbeat; not hero-scale transformation |
| Identity | Motion and behaviour — not silhouette |

### Rejected as Pulse glyph (PD-026)

Hearts · ECG lines as logo/icon · Blobs · Seeds · Droplets · Capsules · Pebbles · Compass icons · Abstract glyphs · Logo marks

### Pulse Line — Check-In reading (PD-030)

A **transient ECG-style sweep** on `HavenHeroCard` during Check-In. Hospital-monitor metaphor — calm, restrained, colored by current `PulseState`. **Not** the header circle. **Not** a brand logo.

| Do | Don't |
|---|---|
| Single calm line sweep | Red alarm aesthetics, beeping metaphor |
| Hold at end if response is slow | Random number scrambling |
| Reveal real status after line + response | Fake cycling status labels |

---

## Placement

### Header rest (passive)

```
Good morning, Omar                     ○
```

- Greeting left-aligned.
- Circle right-aligned in fixed Home Header.

### First launch (expanded)

- Greeting and Pulse presented larger, vertically stacked.
- Pulse centered beneath greeting.
- Full content visible below — welcoming, not empty.

### Check-In (active pull)

- Pulse **grows** and **travels toward screen center** — pulled with the member's gesture.
- Greeting stays in header layout.
- Content below shifts down — **HavenHeroCard unchanged** until Pulse arrives.

### Heartbeat

- Pulse at **screen center** — double beat.
- HavenHeroCard enters Pulse reading **only after Pulse reaches destination**.

### Pulse reading

- HavenHeroCard shows Pulse Line (ECG sweep) at beat threshold.
- Previous wellbeing content dims — never fakes data.

---

## Passive State

- ~20–24px circle.
- Almost imperceptible breathing every few seconds.
- Alive but never distracting.
- **No heartbeat while idle.**
- State communicated through color and subtle glow (PD-016) — never numbers.

---

## Active States

| Phase | Visual behaviour |
|---|---|
| First launch expanded | Larger greeting + Pulse with full content |
| Header settle | Greeting + Pulse transition together into header; content shifts up |
| Check-In pull | Pulse grows + moves to center with pull; content shifts; hero card unchanged |
| Heartbeat | Double beat at center; HavenHeroCard reading begins |
| Pulse reading | HavenHeroCard shows Pulse Line (ECG sweep) |
| Reveal | Real wellbeing result after line + response |
| Return | Pulse returns from center to header — **no particles** |

---

## Color

From [HDL/07-color-system.md](07-color-system.md) (PD-016):

| State | Token |
|---|---|
| Calm | `HavenColors.pulseCalm` |
| Strong | `HavenColors.pulseStrong` |
| Attention | `HavenColors.pulseAttention` |

Glow increases subtly during Check-In heartbeat; returns to passive levels after.

---

## Implementation notes

- Circular rendering: reuse [`pulse_orb.dart`](../lib/widgets/pulse_orb.dart) glow layers where appropriate.
- v3 `PulseGlyphPainter` (abstract pebble) is **superseded** — do not extend.
- Target component: `FinancialPulse` per [HDL/20-components.md](20-components.md).

---

## Related

- [HAVEN_FINANCIAL_PULSE.md](../HAVEN_FINANCIAL_PULSE.md) — Check-In specification
- [HDL/12-motion.md](12-motion.md) — motion principles
- [HDL/20-components.md](20-components.md) — FinancialPulse component
- [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md) — PD-026, PD-027, PD-030
