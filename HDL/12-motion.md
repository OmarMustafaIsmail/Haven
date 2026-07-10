# HDL 12 — Motion

## Purpose

Motion principles for Haven — especially the Financial Check-In and first-launch presentation. Principles precede values. Tokenize durations in code only after prototype validation.

## Status

**EXPERIMENTAL** — Home Experience v4 (PD-027)

## Reasoning

v4 deliberately simplifies v3 motion. Premium feeling comes from **restraint, clarity, and motion quality** — not visual complexity. No particles, no elastic exaggeration, no disappearing content.

---

## Principles

### Core qualities

| Quality | Meaning |
|---|---|
| **Calm** | Lowers heart rate; never startles |
| **Purposeful** | Every movement has reason |
| **Organic** | Breathing, not looping decoration |
| **Premium** | Restrained, polished, confident |
| **Human** | Warm, not mechanical |

### Avoid

- Playful animations
- Elastic exaggeration
- Bouncy effects (no overshoot springs)
- Overly decorative transitions
- Particles, flying objects, magical effects
- Refresh or loading metaphors (spinners, progress bars, rotation icons)
- Content disappearing or fading during Check-In

### Product rule

The **heartbeat is the Check-In** — not a loading state.

The member should remember the **feeling**, not the animation.

---

## Motion Phases (v4)

### Passive breath

- Almost imperceptible scale/opacity cycle every few seconds on header circle.
- No heartbeat. No attention-seeking.

### First launch presentation

- Greeting + Pulse in expanded layout with full content visible.
- After ~1 second: greeting and Pulse transition **together** into header.
- Content shifts upward smoothly. **Nothing disappears. Nothing fades away.**
- Triggered on entering Home — not after every Check-In.

### Check-In pull

- Pulse **grows** and **travels toward screen center** with the pull gesture.
- Content below shifts down — **HavenHeroCard stays visually unchanged**.

### Heartbeat

- Pulse at **center** — calm **double beat**.
- HavenHeroCard enters **Pulse reading** only when Pulse reaches destination.

### Pulse reading

- **Pulse Line** — hospital-monitor-style ECG sweep on `HavenHeroCard`.
- Sweeps left-to-right once (or holds calmly at end if response is slow).
- Color: current `PulseState` accent. No clinical alarm styling.
- Previous wellbeing copy may dim — **never** replaced with fake/scrambled values.

### Reveal

- When Pulse Line completes **and** Check-In response arrives: show real emotional status + Safe to Spend.
- Quiet transition — not a slot-machine or count-up gimmick.

### Return to header

- Pulse returns from **screen center** to header position.
- **No particles. No arc animations. No compression effects.**
- Ends exactly where it began.

---

## Home Content Motion

During Check-In:

| Phase | HavenHeroCard |
|---|---|
| Pull | **Unchanged** — shifts down with content only |
| Beat threshold | Enters **Pulse reading** — Pulse Line appears |
| Pulse reading | ECG sweep — the wait |
| Reveal | Real status + Safe to Spend from response |
| Return | Settled result remains; Pulse returns to header |

**Never during Check-In:** random number scrambling, fake status cycling, spinners, progress bars.

Content shifts downward during pull to make room — never hide or fade the Home away.

---

## Global Haven Motion

- Everything moves slowly.
- Everything breathes where appropriate.
- Nothing bounces.
- Restrained spring animations only where physically justified.
- All validated durations live in `HavenMotion` — never hardcoded in widgets.

---

## Validation notes

### Superseded

| Version | Rejected motion patterns |
|---|---|
| v2 | Auto-recognition heartbeat on every open |
| v3 | Abstract glyph stretch, particle return, elastic pull, hidden content reveal |

### v4 (validated direction — PD-030 pending implementation)

- First-launch expanded → header settle (~1s)
- Connected greeting + Pulse settle/return; pull shifts content only; beat at center (PD-030)
- Content shift (not hide) during pull
- Header circle double beat + HavenHeroCard Pulse Line reading
- Result reveal after line completes and response arrives

---

## Implementation notes

**Current code:** [`lib/pulse/`](../lib/pulse/) reflects **superseded v3** motion (glyph painter, particle return). Refactor to v4.

**Circular Pulse:** [`lib/widgets/pulse_orb.dart`](../lib/widgets/pulse_orb.dart) — reuse glow/breath/heartbeat logic.

**Interaction spec:** [HAVEN_FINANCIAL_PULSE.md](../HAVEN_FINANCIAL_PULSE.md)

---

## Related

- [HDL/13-financial-pulse.md](13-financial-pulse.md) — circular Pulse visual spec
- [HDL/20-components.md](20-components.md) — FinancialPulse component
- [HAVEN_HOME_EXPERIENCE.md](../HAVEN_HOME_EXPERIENCE.md) — Home screen spec
