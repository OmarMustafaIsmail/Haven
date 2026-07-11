# Product Architecture

How Haven is structured as a product — screens, journeys, information hierarchy, and domain concepts.

Product soul: [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md). UI implementation: [HDL/](HDL/). Locked decisions: [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md).

**Current direction:** Home Experience v4/v5 + Layered Navigation (PD-027, PD-029, PD-030, PD-031).

---

## Product Principles

These govern every screen and feature:

1. **Reduce anxiety.** Every interaction should leave members calmer than before.
2. **Answer "How am I doing?" before "How much do I have?"** Confidence is the primary output (PD-018, PD-019).
3. **Money is evidence, not the product.** Numbers support wellbeing — they do not headline the experience.
4. **One hero per screen.** Visual hierarchy is non-negotiable.
5. **Guidance over data.** Tell members what to do, not just what happened.
6. **Premium through restraint.** v4 deliberately simplifies earlier directions — no particles, no hidden content, no abstract glyphs.
7. **Product-defining systems stay independent.** The Financial Pulse owns its ritual. Home orchestrates around it (PD-028).

---

## Navigation

Haven does not switch screens. Members **go deeper** into the same financial space (PD-031).

Think Apple Health. Apple Wallet. Expanding context — not navigating away.

### Layered experience model

Home, Money, and Plans are **layers** of one continuous Haven experience — not separate pages.

| Layer | Question | Role |
|---|---|---|
| **Home** | "How am I doing?" | Emotional entry — wellbeing, guidance, activity |
| **Money** | "Where is my money?" | Structure — totals, places, plans, movement |
| **Plans** | "What am I building toward?" | Intent — goals and funds (future) |

**Persistent chrome** (always visible across layers):

- Greeting + Financial Pulse (header)
- HavenHeroCard — three layers: Financial State, Safe to Spend, Today's Moment

**Morphing body** (changes per layer):

- Home: Recent Activity
- Money: Total Money + places + connected plans + recent movement

The member should never feel they left Home. They went deeper into one aspect of it.

### Bottom navigation (PD-010, reframed)

Five-tab bar is a **depth affordance**, not a page router:

| Tab | Layer |
|---|---|
| **Home** | Surface — daily check-in |
| **Money** | Deeper — organizational structure |
| **Plans** | Deeper — forward intent (future) |
| **Insights** | Awareness patterns (future) |
| **Profile** | Member settings (future) |

No Material push. No slide-left. No hard cuts between layers.

### Entering Money

Two entry points — **identical transition**:

1. Bottom navigation: Home → Money
2. Chevron inside Safe to Spend (HavenHeroCard)

Both trigger the same content morph transition. See [Layer transition](#layer-transition) below.

### Returning Home

Not an instant page swap. Money content fades away. Home content returns quickly. The member should feel: *"I zoomed back out."*

### Layer transition

**Pulse stays in the header.** Layer navigation does not animate the Pulse — that ritual is reserved for pull Check-In only.

**Sequence (Home → Money):**

1. Activity fades out with a slight slide (~240ms).
2. Money body fades in beneath the unchanged hero chrome.
3. Pulse continues passive breath in the header throughout.

**Sequence (Money → Home):** reverse — Money fades, Home returns.

Full motion tokens: [HDL/12-motion.md](HDL/12-motion.md).

### Check-In vs layer transition

| | Check-In | Layer transition |
|---|---|---|
| **Trigger** | Pull down on Home | Bottom nav or Safe to Spend chevron |
| **Pulse animation** | Yes — travel, double beat, return | **No** — header Pulse unchanged |
| **Pulse Line** | Yes — hero reading | No |
| **Hero update** | Yes — reveal wellbeing | No — hero unchanged |
| **Body change** | Reveal on hero card | Morph Home ↔ Money body (~240ms) |
| **Member feels** | "I checked in" | "I went deeper" / "I zoomed back out" |

Check-In (pull-down) remains unchanged (PD-030).

---

## Home

### Philosophy

Haven is a **daily financial check-in**, not a dashboard.

Members open Home and immediately answer one question: **"How am I doing?"**

The product should never feel like refreshing data. It should feel like checking in with financial wellbeing.

The goal is not prettier UI. The goal is **emotional clarity**.

### Header

The Home Header is a permanent part of Haven's identity:

```
Good morning, Omar                     ○
```

| Element | Role |
|---|---|
| **Greeting** (left) | Human warmth |
| **Financial Pulse** (right) | Living circle — passive breath at rest |

The header is fixed. It does not scroll.

### First launch (entering Home)

When Home opens (once per visit — not after every Check-In):

- Greeting and Pulse appear in **expanded presentation** with full content visible below.
- The screen feels welcoming — not empty, not animated for the sake of animation.
- After ~1 second: Greeting and Pulse settle into the Home Header together.
- Remaining content shifts upward. **Nothing disappears. Nothing fades away.**

This teaches the member where Greeting and Pulse live.

### Information hierarchy

```
Greeting
    ↓
Financial Pulse
    ↓
HavenHeroCard
    ├── Financial State (Pulse only)
    ├── Safe to Spend
    └── active Moment (optional)
    ↓
Recent Activity
```

**Financial State** answers *"How am I doing?"* — from Pulse only; never from reminders or events.

**Safe to Spend** is the primary value — visually dominant, always visible.

**Today's Moment** answers *"Is there anything I should know today?"* — one relevant **Moment**, sometimes none (PD-034).

### Home structure (Concept C — PD-029, PD-032)

Opening Haven should feel like checking on yourself, not opening a banking dashboard. The Pulse is the ritual. Home content is the destination.

```
Header (greeting + passive Pulse)
    ↓
HavenHeroCard — Financial State + Safe to Spend + active Moment
    ↓
Recent Activity
```

Content is **always visible** on launch. No automatic heartbeat. No hidden pre-check-in state.

Card system: soft cards, borders only, no shadows. One purpose per card. See [HDL/20-components.md](HDL/20-components.md) for component specs.

### Financial Check-In

The interaction is called **Financial Check-In** or **Check-In**.

Never: refresh, pull-to-refresh, reload, sync.

**Member journey:**

1. Member pulls down — Pulse grows and travels toward screen center, as if drawn with the gesture.
2. HavenHeroCard and other content shift down only — normal appearance, no loading.
3. At destination (Pulse reaches center): double beat, then Pulse Line reading on the hero card.
4. When Pulse Line completes and the response arrives: reveal real wellbeing status + Safe to Spend.
5. Pulse returns to the header. Premium through simplicity.

Full interaction, motion, and component specs: [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md).

### Loading

Haven never shows loading spinners on Home. During Check-In, the **Pulse Line** carries the wait — not a generic loader.

### Success criteria

**Ideal journey:** Open Haven → Feel welcomed → Understand wellbeing → Optionally Check-In → Receive reassurance → Continue with confidence.

**Succeeds:** *"I like checking in."*

**Fails:** *"Pull to refresh."*

**Final question:** Would someone open Haven just to check in, even if nothing changed today?

---

## Money

Money is a **layer**, not a separate screen (PD-031).

Answers: **"Where is my money?"** — structure, not reassurance.

### What persists from Home

Greeting, Pulse, HavenHeroCard (emotional context + Safe to Spend) remain visible. The upper portion stays visually connected to Home.

### Money Places (PD-035)

Each Place: **name**, **balance**, **source** (`Manual` | `Connected`).

MVP: manual CRUD — add, edit, delete, update balance. Future bank connections use `Connected` without UI redesign.

### Money body (beneath hero)

```
Total Money
42,350 EGP

Money lives in
Main Bank · Savings · Wallet · Cash

Connected Plans
Apartment Fund · Emergency Fund · Vacation

Recent movement
Salary · Lunch · Transfer
```

**Do not repeat:** recommendation cards, Home insights, Pulse reading, Safe to Spend duplication.

Typography and whitespace carry hierarchy — no dashboard cards on Money body. See existing Money widgets in `lib/features/money/widgets/`.

### Entry and exit

Same Pulse-anchored transition whether entering via bottom nav or Safe to Spend chevron. Returning Home morphs body back — no page transition.

---

## Plans

Goals, funds, and forward-looking financial intent (PD-010).

Recommendations on Home may reference Plans (e.g. "Move 12,000 EGP to your Apartment fund").

---

## Insights

Patterns and awareness — helping members understand trends without dashboard overload (PD-010).

---

## Profile

Member settings, preferences, and account management (PD-010).

---

## Shared Interaction Principles

### Language (Check-In)

| Use | Never use |
|---|---|
| Check-In / Financial Check-In | Refresh |
| Check in with your Pulse | Pull to refresh |
| Financial wellbeing | Update data, sync |
| The heartbeat is the check-in | Loading, syncing |
| Reading your Pulse | Updating, fetching |

**"Pulse" is product identity** — a verb and a noun. Members do not refresh; they **Pulse**.

### Motion (product level)

Motion should feel: **calm · purposeful · organic · premium · human**

Avoid: playful animation, elastic exaggeration, bouncy effects, overly decorative transitions.

The member should remember the **feeling**, not the animation.

Details: [HDL/12-motion.md](HDL/12-motion.md).

### Quality bar

- Would Apple ship this?
- Would Linear simplify this?
- Would Copilot Money remove another element?

---

## Domain Concepts

Haven is organized around **five core primitives** (PD-033). Everything else composes from these.

### Pulse

The living representation of **Financial Wellbeing** (PD-003).

- Not a score. Members are never rated.
- Not AI. Not a chatbot.
- Not a refresh indicator.

A **simple circle** in the Home Header. Identity comes from motion and ritual — passive breath, Check-In heartbeat, quiet return home.

States: **calm**, **strong**, **attention** (PD-016) — wellbeing framing, not gamification.

Hero **Layer 1 (Financial State)** reflects Pulse only. It never changes because of reminders, events, or notifications.

### Moment

The single most relevant piece of information Haven wants to share with the member today (PD-034).

A Moment may be an observation, reminder, question, celebration, or request for confirmation. It is **contextual** — not a notification, feed, or alert center.

- At most **one active Moment** in the Hero at a time
- Some days there is **no Moment** — that is valid
- Types (confirmation, reminder, insight, etc.) are examples — the architecture is generic
- Completing a Moment shows inline acknowledgement, then records an **Activity** interaction

Future: powered by Haven Intelligence. MVP uses mocked data through a reusable engine.

### Money Place

Where money currently lives (PD-035).

Each Place has a name, balance, and **source** (`Manual` in MVP; `Connected` when bank links arrive). Members can add, edit, delete, and update balances manually without redesigning the Money layer.

### Plan

What money is working toward — goals and funds (PD-010). Connected Plans on the Money layer reference Plans. Full Plans layer is future work.

### Activity

A historical record of **financial transactions** and **member interactions with Haven** (Moment completed, reminder dismissed, balance updated, etc.).

Recent Activity on Home is not transactions-only. It reflects that Haven understands the member's life through ongoing dialogue.

### Financial Wellbeing

The felt sense that a member's financial life is understood, stable, and moving in the right direction — with clear guidance when it is not.

Not net worth. Not a credit score. Not monthly savings. Expressed through **Pulse**.

### Pulse orchestration

The Pulse **emits events**. Home **listens**. Animation drives the interface — never the reverse (PD-028).

The Pulse owns the ritual (breath, pull, heartbeat, return). The Haven Experience orchestrates content (Financial State, Safe to Spend, active Moment, layer body).

---

## Future Architecture

### Not yet designed

- Plans, Insights, Profile layer transitions (Money layer prototype first)
- Dark mode (PD-012 — light mode first)
- Check-In without pull — accessibility fallback (open)

### Superseded directions

| Version | Direction | Status |
|---|---|---|
| v1 | Stacked equal-weight cards | Superseded (PD-022) |
| v2 | Pulse Recognition — auto heartbeat on open | Superseded (PD-024) |
| v3 | Header Pull Emergence — abstract glyph, particle return, hidden content | Superseded (PD-025) |

---

## Related

- [HAVEN_MANIFESTO.md](HAVEN_MANIFESTO.md) — why Haven exists
- [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md) — locked decisions
- [HDL/13-financial-pulse.md](HDL/13-financial-pulse.md) — Pulse interaction and implementation
- [HDL/20-components.md](HDL/20-components.md) — Home components
