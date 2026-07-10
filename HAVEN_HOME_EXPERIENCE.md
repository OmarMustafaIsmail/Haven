# Haven Home Experience

Forget dashboards.

Forget pull-to-refresh.

Forget traditional finance applications.

Haven is a **daily financial check-in**.

Members open Haven and immediately answer one question:

**"How am I doing?"**

The product should never feel like refreshing data. It should feel like checking in with financial wellbeing.

Everything supports this single emotional goal.

**Source of truth for interaction detail:** [HAVEN_FINANCIAL_PULSE.md](HAVEN_FINANCIAL_PULSE.md)

---

## The Goal

The goal is not prettier UI.

The goal is **emotional clarity**.

Money is evidence. The emotional state is the product.

---

## Home Header

The Home Header is a **permanent part of Haven's identity**.

```
Good morning, Omar                     ○
```

| Element | Role |
|---|---|
| **Greeting** (left) | Human warmth |
| **Financial Pulse** (right) | Living circle — ~20–24px, passive breath |

This is the **resting state** of Home. The header is fixed. It does not scroll.

---

## First Launch Experience

When Home opens (entering Home — **once per visit**, not after every Check-In):

The greeting and Pulse begin in their **expanded presentation**:

```
Good morning, Omar

                 ○

Calm today.
42,350 EGP safe to spend
Recommendation
Recent Activity
```

The screen feels **welcoming**. Not empty. Not animated for the sake of animation.

After approximately **one second**:

- Greeting and Pulse **transition together** into the Home Header.
- Remaining content **gently shifts upward** to occupy the space.
- **Nothing disappears. Nothing fades away.**

The member naturally learns where the Greeting and Pulse live.

This transition happens only when **entering Home** — not after every Check-In.

---

## Visual Hierarchy

```
Greeting
    ↓
Financial Pulse
    ↓
Emotional State
    ↓
Safe to Spend
    ↓
Guidance
    ↓
Recent Activity
```

### Emotional state is the product

Examples: *Calm today.* · *You're financially steady.* · *Nothing needs your attention.*

This message is more important than any number.

### Safe to Spend

Money supports the emotion — not the opposite. Quiet evidence, never the headline.

### Guidance

Conversational. Haven speaking directly — not a dashboard widget.

---

## Home Structure (Concept C — PD-029)

Opening Haven should feel like checking on yourself, not opening a banking dashboard. The Pulse is the ritual. Home content is the destination.

```
Header (greeting + passive Pulse)
    ↓
HavenHeroCard — wellbeing status + Safe to Spend (merged)
    ↓
Recommendation Card — one only
    ↓
Recent Activity
```

### Cards

Soft cards via `HavenCard`: large corner radius (`lg`), generous padding, subtle borders, calm backgrounds. One purpose per card. No shadows.

| Component | Role |
|---|---|
| `HavenHeroCard` | Emotional wellbeing + Safe to Spend — always first. Hosts **Pulse Line** during Check-In. |
| `RecommendationCard` | One conversational suggestion |
| `ActivitySection` | Simple recent activity context |

Content is **always visible** on launch. No automatic heartbeat. No hidden pre-check-in state.

---

## Financial Check-In

The interaction is called **Financial Check-In** or **Check-In**.

Never: refresh, pull-to-refresh, reload, sync.

See [HAVEN_FINANCIAL_PULSE.md](HAVEN_FINANCIAL_PULSE.md) for the full specification.

### Pull interaction

1. **Pulse is pulled with the gesture** — grows and moves toward **screen center** as the member pulls down.
2. HavenHeroCard and other content **shift down only** — normal appearance, no loading.
3. At **destination** (Pulse reaches center): double beat, then Pulse Line reading on the hero card.
4. Pulse returns to the header when complete.

### Check-In animation

At pull threshold:

1. Header circle — travels to **screen center**, **calm double beat**. Subtle haptic at each peak.
2. **HavenHeroCard** — shows a **Pulse Line** (hospital-monitor ECG sweep). This is Haven reading your financial wellbeing.
3. Check-In request runs in parallel. If the response is slow, the line **holds calmly** — no spinners, no fake numbers.
4. When the Pulse Line completes **and** the response arrives: reveal real emotional status + Safe to Spend.
5. Greeting and Pulse return together to the header.

No spinner. No loading wheel. No progress bar. No scrambled digits. **The Pulse Line is the check-in.**

### Return

When complete:

- Greeting and Pulse **return together smoothly** to the Home Header.
- **No particles. No magical effects. No flying objects.**
- Premium through **simplicity**. Animation ends exactly where it began.

---

## Motion

Motion should feel: **calm · purposeful · organic · premium · human**

Avoid: playful animation, elastic exaggeration, bouncy effects, overly decorative transitions.

The member should remember the **feeling**, not the animation.

Principles: [HDL/12-motion.md](HDL/12-motion.md)

---

## Loading

Haven never shows loading spinners on Home. During Check-In, the **Pulse Line** on HavenHeroCard carries the wait — a calm ECG sweep, not a generic loader.

---

## Success Criteria

### Ideal emotional journey

Open Haven → Feel welcomed → Understand financial wellbeing → Optionally Check-In → Receive reassurance or guidance → Continue with confidence.

### Succeeds

> "I like checking in."

### Fails

> "Pull to refresh."

**Final question:** Would someone open Haven just to check in, even if nothing changed today?

---

## Quality Bar

- **Would Apple ship this?**
- **Would Linear simplify this?**
- **Would Copilot Money remove another element?**

---

## Prior Directions (Superseded)

| Version | Direction | Status |
|---|---|---|
| v1 | Stacked equal-weight cards | Superseded |
| v2 | Pulse Recognition — auto heartbeat on open, tap re-check | Superseded (PD-024) |
| v3 | Header Pull Emergence — abstract glyph, particle return, hidden pre-check-in content | Superseded (PD-025) |

Current v3 implementation in `lib/pulse/` reflects superseded direction and **must be refactored** to v4 — see [HAVEN_ARCHITECTURE.md](HAVEN_ARCHITECTURE.md).

---

## Related

- [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md) — product soul
- [HAVEN_FINANCIAL_PULSE.md](HAVEN_FINANCIAL_PULSE.md) — Check-In interaction spec
- [HAVEN_ARCHITECTURE.md](HAVEN_ARCHITECTURE.md) — `FinancialPulse` component architecture
- [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) — PD-026, PD-027, PD-029, PD-030
- [HDL/12-motion.md](HDL/12-motion.md) — motion principles
- [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md) — Pulse visual specification
- [HDL/20-components.md](HDL/20-components.md) — `FinancialPulse` component spec
