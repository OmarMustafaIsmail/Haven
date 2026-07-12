# Product Decisions

Not ideas. Decisions.

Every important discussion ends with a decision recorded here. Any new developer who joins Haven opens this file and immediately understands the thinking behind the product.

**Before proposing changes:** check this file. Locked decisions should not be revisited without a compelling reason.

---

## Index

| ID | Decision | Status |
|---|---|---|
| PD-001 | Haven is a Financial Operating System | Locked |
| PD-002 | Pull to Check Your Financial Pulse replaces pull-to-refresh | Superseded |
| PD-003 | Financial Pulse is wellbeing, not a score | Locked |
| PD-004 | Refer to people as "members," not "users" | Locked |
| PD-005 | Logo: Hidden Compass H | Locked |
| PD-006 | Logo usage rules | Locked |
| PD-007 | Tagline: Navigate your money with confidence | Locked |
| PD-008 | Home screen direction: Concept C (Warm • Human • Reassuring) | Locked |
| PD-009 | Home signature elements | Locked |
| PD-010 | Five-tab bottom navigation | Locked |
| PD-011 | Four-state status indicator system | Locked |
| PD-012 | Light mode first | Locked |
| PD-013 | Design inspiration: study principles, do not copy | Locked |
| PD-014 | Three app icon variants | Locked |
| PD-015 | Color system remains experimental until multi-screen validation | Experimental |
| PD-016 | Financial Pulse colors | Locked |
| PD-017 | Logo assets: Figma source of truth | Locked |
| PD-018 | Home answers "How am I doing?" not "How much money?" | Locked |
| PD-019 | Financial Pulse is the screen hero; money is supporting evidence | Locked |
| PD-020 | HDL evolves build-first with three-state status model | Locked |
| PD-021 | Manifesto v2 is product soul only — engineering lives elsewhere | Locked |
| PD-022 | Home Experience v2: flowing layout supersedes stacked cards | Superseded |
| PD-023 | Signature opening heartbeat unfold | Superseded |
| PD-024 | Check In with your Pulse — daily recognition ritual | Superseded |
| PD-025 | Header Pull Emergence — signature check-in ritual | Superseded |
| PD-026 | Financial Pulse remains a simple circular form | Locked |
| PD-027 | Home Experience v4 — welcoming first launch + connected Check-In | Locked |
| PD-028 | FinancialPulse component architecture — event-driven, Home-agnostic | Locked |
| PD-029 | Home v5 — Concept C soft-card layout + v4 Pulse integration | Locked |
| PD-030 | Pulse Line — hospital ECG reading during Check-In | Locked |
| PD-031 | Layered navigation — Pulse as transition camera | Locked |
| PD-032 | Hero three-layer structure — Financial State, Safe to Spend, Today's Moment | Locked |
| PD-033 | Five core primitives — Pulse, Moment, Money Place, Plan, Activity | Locked |
| PD-034 | Moment primitive — generic engine, Hero, acknowledgement, Activity | Locked |
| PD-035 | Money Place — manual source, CRUD, Connected future | Locked |
| PD-036 | Plans layer — intent, create/detail, layered navigation | Locked |
| PD-037 | Haven-native form primitives — sheets, fields, selects | Locked |

---

# PD-001

**Decision:** Haven is a Financial Operating System — the central place where members understand and manage their financial life.

**Reason:** Differentiates from commodity finance apps. Aligns with the mission of reducing uncertainty, not just tracking spending.

**Status:** Locked

**Alternatives rejected:** Expense tracker, budgeting app, banking application.

---

# PD-002

**Decision:** Pull to Check Your Financial Pulse replaces traditional pull-to-refresh.

**Reason:** We believe checking your financial wellbeing should feel intentional rather than mechanical.

**Status:** Superseded by PD-025

**Reason:** Pull borrows refresh muscle memory if executed poorly — v3 reframes pull as *summoning* the Pulse from the header for check-in, not refreshing data. v2 rejected pull entirely in favor of open recognition (PD-024).

**Validation:** Pull interaction removed in PD-024 implementation. Restored as check-in ritual in v3 direction (PD-025).

---

# PD-003

**Decision:** The Financial Pulse is a living representation of a member's financial wellbeing. It is not a score and it is not AI.

**Reason:** Scores create anxiety and competition. AI labeling feels opaque. Wellbeing framing supports calm and trust.

**Status:** Locked

**Alternatives rejected:** Credit-score-style number, AI-generated health rating.

---

# PD-004

**Decision:** Refer to people who use Haven as "members," not "users."

**Reason:** "Members" implies belonging and partnership. "Users" is transactional and impersonal.

**Status:** Locked

---

# PD-005

**Decision:** The Haven logo is a minimalist geometric uppercase H. The horizontal crossbar is a compass needle pointing North. Vertical bars have width 2X; crossbar height is X. All corners are rounded. Clear space on all sides equals X.

**Reason:** The H is noticed first; the compass is discovered over time. Symbolizes quiet guidance — understanding where you are before deciding where to go.

**Status:** Locked

**Alternatives rejected:** Literal compass icons, dollar/finance clichés, complex illustrative marks.

---

# PD-006

**Decision:** Do not rotate, stretch, recolor (e.g., orange), or add effects (drop shadows, glows) to the logo.

**Reason:** Preserves brand integrity and the calm, premium aesthetic.

**Status:** Locked

---

# PD-007

**Decision:** Tagline is "Navigate your money with confidence."

**Reason:** Reinforces guidance (compass metaphor) and the core emotional outcome (confidence, not anxiety).

**Status:** Locked

---

# PD-008

**Decision:** Concept C — "Warm • Human • Reassuring" wins as the home screen direction.

**Reason:** Creates emotional connection, feels human and reassuring, passes the 3-second test. Scored highest on reduces anxiety, communicates trust, morning habit potential, clarity, and distinctiveness.

**Status:** Locked

**Alternatives rejected:** Concept A (Apple — calm/minimal but less distinctive), Concept B (Linear — structured/informative but less emotionally warm).

Reference: [assets/concepts/home-concepts-evaluation.png](assets/concepts/home-concepts-evaluation.png)

---

# PD-009

**Decision:** The Haven home screen includes: conversational greeting, Financial Pulse hero, wellbeing answer, safe-to-spend evidence, Haven guidance, and recent activity context.

**Reason:** Each element serves the mission — Pulse and wellbeing answer reduce anxiety, safe-to-spend builds confidence, guidance directs next actions, activity provides context without overwhelming.

**Status:** Locked

**Alternatives rejected:** Data-dense dashboard (Concept B), single-hero-only layout without guidance (Concept A).

---

# PD-010

**Decision:** Five-tab bottom navigation: Home, Money, Plans, Insights, Profile.

**Reason:** Covers the core financial life areas without overwhelming.

**Status:** Locked

**Alternatives rejected:** Fewer tabs (loses Plans/Insights separation), more tabs (adds complexity).

---

# PD-011

**Decision:** Four status colors: Green (Good), Orange (Attention), Red (Action needed), Blue (Interactive).

**Reason:** Provides clear, calm communication of financial state without alarm. Blue distinguishes interactive elements from status.

**Status:** Locked

**Alternatives rejected:** Binary good/bad indicators, traffic-light only (no interactive state).

---

# PD-012

**Decision:** HDL will be defined for light mode first. Dark mode is deferred until light mode is validated across screens.

**Reason:** Concept C (the winning direction) is light mode. Focusing on one mode ensures quality before expanding.

**Status:** Locked

---

# PD-013

**Decision:** HDL is inspired by Apple HIG, Linear, Mercury, Arc Browser, and Things 3. We study their principles; we do not copy their designs.

**Reason:** Learn from quality standards without creating a derivative product.

**Status:** Locked

---

# PD-014

**Decision:** Three app icon variants: Light (teal H on white), Dark (white H on teal), Monochrome (white H on black).

**Reason:** Covers standard platform requirements while maintaining brand consistency.

**Status:** Locked

Reference: [assets/brand/brand-identity.png](assets/brand/brand-identity.png)

---

# PD-015

**Decision:** The HDL Color System remains experimental until multiple real application screens have been built and tested. Primary teal is `#1D544E`; interactive semantic is `#4A8F88`.

**Reason:** Color should be validated in context, not locked from documentation alone. The overall hue (deep calming teal) is part of Haven's identity and should not dramatically change.

**Status:** Experimental

**Validation:** Used on Home mock v1 and Home Experience v2. Not yet validated on Money, Plans, Insights, or Profile.

Reference: [HDL/07-color-system.md](HDL/07-color-system.md)

---

# PD-016

**Decision:** Pulse states: Calm `#4A9B6E`, Strong `#1D544E`, Attention `#C4862B`. Pull reveal uses `#E8F2F0` → `#FFFFFF` gradient with `#1D544E` accent.

**Reason:** Wellbeing framing — not a score, not gamified. Pull interaction feels calm and intentional.

**Status:** Locked

**Alternatives rejected:** Score-style red-to-green gradients, animated rainbow pulses, gauge-style color ranges.

---

# PD-017

**Decision:** Logo assets are exported from Figma [Haven Brand Assets](https://www.figma.com/design/qJe22LWuxcsQ0bcLxg0eov/Haven-Brand-Assets). Figma is the master; repo holds exports.

**Reason:** Mathematically constructed in Figma — not AI-generated or pixel-traced.

**Status:** Locked

Reference: [HDL/01-brand-assets.md](HDL/01-brand-assets.md)

---

# PD-018

**Decision:** The Home screen answers "How am I doing?" within two seconds — not "How much money do I have?"

**Reason:** Confidence is the product. Money is evidence that supports confidence, not the primary message.

**Status:** Locked

**Date:** 2026-07-10

---

# PD-019

**Decision:** Financial Pulse is the screen hero on Home. Safe-to-spend and other numbers are supporting evidence, visually de-emphasized.

**Reason:** Aligns with the manifesto principle "confidence before data." The Pulse communicates wellbeing; numbers confirm it.

**Status:** Locked

**Date:** 2026-07-10

---

# PD-020

**Decision:** HDL evolves build-first: Build → Validate in context → Extract patterns → Then standardize. Three statuses: LOCKED, EXPERIMENTAL, FUTURE.

**Reason:** Prevents documenting hypothetical decisions. Design language should be discovered while building, not declared ahead of the product.

**Status:** Locked

**Date:** 2026-07-10

Reference: [HDL.md](HDL.md)

---

# PD-021

**Decision:** HAVEN_MANIFESTO.md is product soul only. Engineering conventions, AI instructions, and token specs live in separate documents.

**Reason:** The manifesto should inspire everyone who works on Haven. Mixing implementation details dilutes its purpose.

**Status:** Locked

**Date:** 2026-07-10

---

# PD-022

**Decision:** Home Experience v2 uses a flowing layout with one hero (Financial Pulse), not stacked equal-weight cards.

**Reason:** The v1 implementation was clean but emotionally flat — stacked cards competed for attention instead of communicating hierarchy. v2 creates rhythm through whitespace and typography.

**Status:** Experimental

**Validation:** Currently being implemented on Home. Needs member testing for emotional clarity and 2-second test.

**Date:** 2026-07-10

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md)

---

# PD-023

**Decision:** Haven's signature moment is the opening heartbeat unfold — the entire Home screen reveals from one Financial Pulse beat.

**Reason:** Every iconic app has a signature moment. Haven's is not the pull gesture — it is when the app opens. The Pulse performs one gentle heartbeat; as it beats, emotional status fades in, the amount count-ups, and guidance glides into place. The member feels "I'm okay" before reading a number.

**Status:** Superseded by PD-024

**Validation:** Full-screen cascade unfold simplified. Heartbeat + answer timing is the ritual; secondary content fades after recognition.

**Date:** 2026-07-10

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md)

---

# PD-024

**Decision:** Haven's daily ritual is **Check In with your Pulse** — recognition heartbeat on app open, tap Pulse to re-check. Pull-to-refresh semantics are rejected.

**Reason:** Every great product has a ritual. Haven's is not pull-to-refresh — it is checking in. Opening Haven triggers a Face ID–parallel recognition heartbeat; the emotional answer materializes from the beat within 2 seconds. Tap the Pulse for intentional re-check later in the day.

**Status:** Superseded by PD-025

**Validation:** Implemented in v2 (`PulseRecognition`, removed). v3 partial implementation in `lib/pulse/` — superseded by v4 (PD-027).

**Supersedes:** PD-002 (pull as primary), PD-023 (full-screen unfold as signature).

**Date:** 2026-07-10

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md)

---

# PD-025

**Decision:** Haven's signature interaction is **Header Pull Emergence** — a ~20–24px Pulse Glyph in the Home Header that members pull downward to check in with their financial wellbeing. The glyph detaches, follows the finger, performs one calm heartbeat at center, orchestrates Home content emergence, then returns home as a glowing particle.

**Reason:** The Financial Pulse must become product-defining — recognizable without a logo. A persistent header glyph with a physical pull-to-summon arc creates a signature distinct from pull-to-refresh (no spinners, no refresh copy, return-home closure). Members check in; they do not refresh.

**Status:** Superseded by PD-027

**Validation:** Partially implemented in `lib/pulse/` (abstract glyph, particle return, hidden pre-check-in content). Implementation diverges from v4 — refactor required.

**Supersedes:** PD-024 (open recognition + tap re-check as primary ritual).

**Date:** 2026-07-10

Reference: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md)

---

# PD-026

**Decision:** The Financial Pulse remains a **simple circular form**. Its recognizability comes from behaviour and interaction — not from iconography. Haven's identity is created through motion, ritual, and emotional design.

**Reason:** Abstract glyph exploration (v3) added visual complexity without emotional gain. The circle is timeless, calm, and neutral. At header size, identity must come from motion (breath, heartbeat, Check-In ritual) rather than silhouette.

**Status:** Locked

**Alternatives rejected:** Pebble, capsule, organic blob, seed, droplet, heart, ECG, compass metaphors.

**Date:** 2026-07-10

Reference: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md), [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md)

---

# PD-027

**Decision:** Home Experience v4 redefines the Financial Check-In: **welcoming first-launch presentation**, **connected Greeting + Pulse detach**, **content always visible**, **simple return to header** — no particles, no hidden content, no abstract glyphs.

**Reason:** v3 over-engineered visual complexity (glyph exploration, particle return, disappearing content). v4 achieves premium feel through restraint, clarity, and motion quality. Members should feel welcomed on open, grounded during Check-In, and reassured — never like they are refreshing a dashboard.

**Status:** Locked

**Key behaviours:**

1. **First launch presentation** — expanded greeting + Pulse with full content; after ~1s, settle into header; content shifts up (nothing disappears).
2. **Check-In** — Greeting and Pulse detach together; Pulse beneath greeting; content shifts down, stays visible.
3. **Heartbeat** — one calm beat updates content; no spinner.
4. **Return** — Greeting and Pulse return together to header; no particles or decorative effects.

**Language:** Financial Check-In / Check-In — never refresh.

**Supersedes:** PD-025 (Header Pull Emergence v3).

**Validation:** Implemented — Home composes `FinancialPulse` (PD-028). See PD-029 for card layout.

**Date:** 2026-07-10

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md), [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md)

---

# PD-028

**Decision:** Financial Check-In is implemented as an independent **`FinancialPulse`** component with strict boundaries: Pulse emits events, Home listens, animation drives interface — never the reverse.

**Reason:** Enables days of ritual polish without rewriting Home. Home can iterate on content orchestration while Pulse iteration stays isolated. Architecture documented in [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md).

**Status:** Locked

**Component decomposition:** `FinancialPulse` (public) · `PulseRitualController` (state) · `PulseAnimationEngine` (animation) · `PulseLayoutResolver` (layout) · `PulseCircle` (visual)

**Phase 2 callbacks (locked):** `onPresentationSettled`, `onCheckInStarted`, `onThresholdReached`, `onHeartbeatFinished`, `onReturnedHome`, `onPullProgress`

**Date:** 2026-07-10

Reference: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md), [HDL/20-components.md](HDL/20-components.md)

---

# PD-029

**Decision:** Home v5 returns to **Concept C soft-card layout** (borders only, no shadows) with **v4 `FinancialPulse`** as the Check-In entry ritual. Content is **always visible** on launch. Home composes cards; Pulse owns the header chrome and ritual.

**Reason:** Concept C communicated trust and reduced cognitive load. The v2 flowing layout (PD-022) was emotionally flat. Cards restore clear hierarchy — emotion first, money second, guidance third, activity fourth — while the Pulse ritual introduces the experience without replacing it.

**Status:** Locked

**Home structure:**

1. Header — greeting + passive Pulse (owned by `FinancialPulse`)
2. StatusCard — emotional wellbeing answer
3. SafeToSpendCard — quiet money evidence
4. RecommendationCard — one recommendation only
5. ActivitySection — recent activity context

**Card system:** `HavenCard` — `HavenRadius.lg`, generous padding, `borderSubtle` border, calm surface fills. No elevation shadows (HDL/11).

**Interaction:** Check-In pull gated to scroll-top. Content shifts during pull. Check-In request at threshold; result reveals after Pulse Line completes and response arrives (PD-030).

**Supersedes:** PD-022 (flowing layout without cards).

**Date:** 2026-07-10

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md), [HDL/20-components.md](HDL/20-components.md)

---

# PD-030

**Decision:** During Financial Check-In, **HavenHeroCard** displays a **Pulse Line** — a calm, hospital-monitor-style ECG sweep — while Haven reads the member's financial wellbeing. **Results reveal only after the Pulse Line completes and the Check-In response arrives.**

**Reason:** "Pulse" is Haven's product identity — not a loading spinner and not scrambled placeholder numbers. The ECG metaphor communicates care and measurement without clinical alarm. The header circle (PD-026) stays the permanent Pulse form; the Pulse Line is a **transient reading ritual** on the hero card.

**Status:** Locked

**Rules:**

1. **Header circle** — travels to **screen center** for double beat at threshold (unchanged from implementation direction).
2. **Pull** — Pulse grows and moves to center with the gesture; content shifts down; HavenHeroCard **unchanged** until destination.
3. **HavenHeroCard** — Pulse Line **only after Pulse reaches center**; previous content dims, never fakes data.
4. **Check-In API** — starts at threshold; runs parallel to animation.
5. **Latency** — line holds calmly at end if response is slow; no frantic loop, no fake digits.
6. **Reveal** — real `PulseState` status + Safe to Spend from response only.
7. **Never** — random number scrambling, slot-machine UX, fake status cycling, spinners, progress bars.

**PD-026 nuance:** ECG lines remain **rejected as the Pulse glyph/logo**. ECG is allowed **only** as the transient Pulse Line on HavenHeroCard during Check-In.

**PD-030 refinement:** Pull draws Pulse toward center (grow + travel); hero card unchanged until Pulse arrives. Supersedes fixed-header-during-pull for Concept C Home.

**Resolves:** Open question "Heartbeat during data latency" in [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md).

**Date:** 2026-07-10

Reference: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md), [HDL/12-motion.md](HDL/12-motion.md), [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md)

---

# PD-031

**Decision:** Home, Money, and Plans are **layers** of one continuous Haven experience — not separate screens. Navigation between layers uses **Pulse-anchored morph transitions**, not page pushes or tab switches.

**Reason:** Members should feel they went **deeper** into Haven, not that they opened another app screen. The Pulse is the **transition camera** — it draws attention to center while content morphs underneath. This is distinct from Check-In, where Pulse performs a financial reading.

**Status:** Locked

**Rules:**

1. **Persistent chrome** — Greeting, Pulse header, HavenHeroCard remain visible across Home and Money layers.
2. **Morphing body only** — Home body (recommendation + activity) ↔ Money body (total, places, plans, movement).
3. **Two Money entry points** — bottom nav and Safe to Spend chevron — **identical** transition.
4. **Layer transition** — programmatic Pulse travel to center → single light heartbeat + haptic → body morph → Pulse returns to header. **No Pulse Line. No hero reading.**
5. **Return Home** — reverse morph; member feels *"I zoomed back out."*
6. **Never** — Material push, slide-left navigation, hard cuts, separate Scaffold for Money.
7. **Mutually exclusive** — layer transition and Check-In cannot run simultaneously.

**PD-010 amendment:** Five-tab bar remains but is reframed as **depth affordances**, not page routers.

**Date:** 2026-07-11

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md), [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md), [HDL/12-motion.md](HDL/12-motion.md)

---

# PD-032

**Decision:** HavenHeroCard is a **three-layer Hero** — one calm conversational component, not stacked dashboard widgets.

**Reason:** The Hero must answer two distinct questions every time a member opens Haven: *"How am I doing?"* and *"Is there anything I should know today?"* Those must never replace each other.

**Status:** Locked

**Layers:**

1. **Financial State** (persistent) — single line from `PulseState` only. Changes only when Pulse changes — never from reminders, events, or notifications.
2. **Safe to Spend** (persistent) — visually dominant; never hidden, collapsed, or replaced.
3. **Today's Moment** (dynamic) — max one relevant message; optional lightweight actions; section absent when no moment (no empty placeholder).

**Rules:**

- Whitespace separates layers — no excessive dividers, no notification styling.
- Today's Moment is not a feed, alert center, or notification.
- RecommendationCard on Home is **superseded** — guidance moves into Today's Moment when relevant.
- Future: Today's Moment powered by Haven Intelligence; UI supports this without redesign.

**Date:** 2026-07-11

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md), [HDL/20-components.md](HDL/20-components.md)

---

# PD-033

**Decision:** Haven is built from **five core primitives**: Pulse, Moment, Money Place, Plan, Activity.

**Reason:** Without shared primitives, Haven becomes a collection of unrelated features. Every screen and interaction should compose from this vocabulary.

**Status:** Locked

**Date:** 2026-07-11

Reference: [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md), [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md)

---

# PD-034

**Decision:** **Moment** is a generic product primitive with a reusable engine. The Hero displays at most one active Moment.

**Reason:** Flexible contextual communication — not one-off reminders or notification feeds.

**Status:** Locked

**Amends:** PD-032 Layer 3 — UI label "Today's Moment"; primitive is **Moment**.

**Date:** 2026-07-11

---

# PD-035

**Decision:** **Money Place** supports manual CRUD with `source: Manual`; `Connected` reserved for future bank links.

**Status:** Locked

**Date:** 2026-07-11

---

# PD-036

**Decision:** **Plans** is a first-class Haven layer answering *"What is my money working toward?"* Members create plans, view progress, and see plan activity — all within the layered shell (PD-031).

**Reason:** Without Plans, Money Places are static storage. Plans turn money into intent and close the loop: Place → Plan → Moment → Activity.

**Status:** Locked

**Rules:**

1. Same persistent chrome as Money — Greeting, Pulse, HavenHeroCard.
2. Body hierarchy: Your Plans → Active → Completed → Suggested → Recent Plan Activity.
3. Typography-first; cards only for plan rows with progress.
4. Create flow is lightweight (name + target required; rest optional).
5. Detail shows progress, target, allocated, connected place, milestones, contributions.
6. Intelligence recommendations (increase allocation, pause, adjust target) are **not** MVP.
7. Bottom nav Plans tab enabled; morph transition matches Home ↔ Money philosophy.

**Date:** 2026-07-12

Reference: [PRODUCT_ARCHITECTURE.md](PRODUCT_ARCHITECTURE.md), [HDL/20-components.md](HDL/20-components.md)

---

# PD-037

**Decision:** All member-facing forms use Haven form primitives — `HavenSheet`, `HavenTextField`, `HavenAmountField`, `HavenSelect`, `HavenDateField`, `HavenChoiceChip` — instead of Material defaults.

**Reason:** Default Flutter forms break Haven's calm, premium feel. Forms are how members teach Haven about their life; they must feel like Haven.

**Status:** Locked

**Rules:**

1. No Material `OutlineInputBorder` text fields, `DropdownButton`, or system `showDatePicker` in product flows.
2. Sheet top radius = `HavenRadius.sheet`; input radius = `HavenRadius.input`.
3. Sheet entry uses `HavenMotion.sheetEnterDuration` / `sheetCurve`.
4. Large touch targets; gentle primary focus ring; filled soft background on fields.
5. Selects and dates open Haven sheets, not Material chrome.

**Date:** 2026-07-12

Reference: [HDL/10-radius.md](HDL/10-radius.md), [HDL/12-motion.md](HDL/12-motion.md), [HDL/20-components.md](HDL/20-components.md)
