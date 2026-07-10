# Product Decisions

Locked decisions for Haven. Every entry records what was chosen, why, and what was rejected.

**Before proposing changes:** check this file. Locked decisions should not be revisited without a compelling reason.

**Format:**

```
### [Decision Title]
- **Status:** Locked
- **Date:** YYYY-MM-DD
- **Decision:** ...
- **Rationale:** ...
- **Alternatives rejected:** ...
```

---

### Haven is a Financial Operating System
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Haven is positioned as a Financial Operating System—the central place where members understand and manage their financial life.
- **Rationale:** Differentiates from commodity finance apps. Aligns with the mission of reducing uncertainty, not just tracking spending.
- **Alternatives rejected:** Expense tracker, budgeting app, banking application.

---

### Financial Pulse is wellbeing, not a score
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** The Financial Pulse is a living representation of a member's financial wellbeing. It is not a score and it is not AI.
- **Rationale:** Scores create anxiety and competition. AI labeling feels opaque. Wellbeing framing supports calm and trust.
- **Alternatives rejected:** Credit-score-style number, AI-generated health rating.

---

### Pull to Check Your Financial Pulse
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Replace pull-to-refresh with "Pull to Check Your Financial Pulse™"—members gently pull down to reveal their current Financial Pulse.
- **Rationale:** Signature interaction that reinforces the product's core concept. Feels calm and intentional, not playful.
- **Alternatives rejected:** Standard pull-to-refresh, swipe gestures, tap-to-refresh.

---

### Members terminology
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Refer to people who use Haven as "members," not "users."
- **Rationale:** "Members" implies belonging and partnership. "Users" is transactional and impersonal.
- **Alternatives rejected:** Users, customers, subscribers.

---

### Logo: Hidden Compass H
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** The Haven logo is a minimalist geometric uppercase H. The horizontal crossbar is a compass needle pointing North. Vertical bars have width 2X; crossbar height is X. All corners are rounded. Clear space on all sides equals X (the crossbar height). Minimum size: 16px digital, 12mm print.
- **Rationale:** The H is noticed first; the compass is discovered over time. Symbolizes quiet guidance—understanding where you are before deciding where to go.
- **Alternatives rejected:** Literal compass icons, dollar/finance clichés, complex illustrative marks.

### Logo usage rules
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Do not rotate, stretch, recolor (e.g., orange), or add effects (drop shadows, glows) to the logo.
- **Rationale:** Preserves brand integrity and the calm, premium aesthetic.
- **Alternatives rejected:** Decorative logo treatments, off-brand color variations.

---

### Tagline
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** "Navigate your money with confidence."
- **Rationale:** Reinforces guidance (compass metaphor) and the core emotional outcome (confidence, not anxiety).
- **Alternatives rejected:** Budget-focused taglines, feature-list taglines.

---

### Home screen direction: Concept C (Haven)
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Concept C — "Warm • Human • Reassuring" wins as the home screen direction.
- **Rationale:** Creates emotional connection, feels human and reassuring, passes the 3-second test. Scored highest on: Reduces Anxiety (5), Communicates Trust (5), Morning Habit Potential (5), Clarity (5), Distinctive/Memorable (5).
- **Alternatives rejected:** Concept A (Apple — calm/minimal but less distinctive), Concept B (Linear — structured/informative but less emotionally warm).

Reference: [assets/concepts/home-concepts-evaluation.png](assets/concepts/home-concepts-evaluation.png)

---

### Home screen signature elements
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** The Haven home screen includes: scenic header background, conversational greeting, reassuring status card, Safe to Spend hero amount, "Recommended for you" proactive recommendation card, and recent activity list.
- **Rationale:** Each element serves the mission—status card reduces anxiety, Safe to Spend builds confidence, recommendations guide next actions, activity provides context without overwhelming.
- **Alternatives rejected:** Data-dense dashboard (Concept B), single-hero-only layout without recommendations (Concept A).

---

### Bottom navigation
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Five-tab bottom navigation: Home, Money, Plans, Insights, Profile.
- **Rationale:** Covers the core financial life areas without overwhelming. Consistent across all three concepts evaluated.
- **Alternatives rejected:** Fewer tabs (loses Plans/Insights separation), more tabs (adds complexity).

---

### Status indicator system
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Four status colors: Green (Good), Orange (Attention), Red (Action needed), Blue (Interactive).
- **Rationale:** Provides clear, calm communication of financial state without alarm. Blue distinguishes interactive elements from status.
- **Alternatives rejected:** Binary good/bad indicators, traffic-light only (no interactive state).

---

### Light mode first
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** HDL will be defined for light mode first. Dark mode is deferred until light mode tokens are complete.
- **Rationale:** Concept C (the winning direction) is light mode. Focusing on one mode ensures quality before expanding.
- **Alternatives rejected:** Dark mode first (Concept B direction was rejected), simultaneous light/dark definition.

---

### Design inspiration approach
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** HDL is inspired by Apple HIG, Linear, Mercury, Arc Browser, and Things 3. We study their principles; we do not copy their designs.
- **Rationale:** Learn from quality standards without creating a derivative product.
- **Alternatives rejected:** Copying Linear's dark dashboard aesthetic, copying Apple's exact layout patterns.

---

### App icon variants
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Three app icon variants: Light (teal H on white), Dark (white H on teal), Monochrome (white H on black).
- **Rationale:** Covers standard platform requirements while maintaining brand consistency.
- **Alternatives rejected:** Gradient icons, illustrative icons, non-geometric marks.

Reference: [assets/brand/brand-identity.png](assets/brand/brand-identity.png)

---

### Primary brand color
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Haven primary brand color is `#1D544E` (deep teal). Supporting brand tokens: `primaryDark` `#143D39`, `primaryLight` `#E8F2F0`, `primaryMuted` `#A5C2C0`.
- **Rationale:** Sampled from brand identity assets. Calm, premium, distinctive — not neon, not generic finance green.
- **Alternatives rejected:** Brighter teals, generic `#008080`, blue-green fintech palette.

Reference: [HDL/07-color-system.md](HDL/07-color-system.md)

---

### Light palette
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Light mode uses warm off-white backgrounds (`#FAFBFC`), white surfaces, and neutral text hierarchy (`#1A1A1C` / `#5A6167` / `#8E9499`).
- **Rationale:** Aligns with Concept C's human, reassuring feel. Avoids clinical pure-white app shells.
- **Alternatives rejected:** Pure white `#FFFFFF` backgrounds, cool gray corporate palette.

---

### Semantic color values
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Status colors: Good `#4A9B6E`, Attention `#C4862B`, Action `#C44D4D`, Interactive `#3D7BF5`. Each has a tinted background variant for status cards.
- **Rationale:** Calm and muted — communicates state without alarm. Warm amber for attention, not screaming orange.
- **Alternatives rejected:** Traffic-light neon colors, binary red/green only, `#FF0000` alarm red.

---

### Financial Pulse colors
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Pulse states: Calm `#4A9B6E`, Strong `#1D544E`, Attention `#C4862B`. Pull reveal uses `#E8F2F0` → `#FFFFFF` gradient with `#1D544E` accent.
- **Rationale:** Wellbeing framing — not a score, not gamified. Pull interaction feels calm and intentional.
- **Alternatives rejected:** Score-style red-to-green gradients, animated rainbow pulses, gauge-style color ranges.

---

### Logo SVG assets
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Logo assets created as SVG from geometric construction spec (2X bars, X gap, compass needle). PNG exports generated at 1024–16px. App icons in light, dark, and monochrome variants.
- **Rationale:** Production-ready assets for Flutter, Figma, and platform stores. SVG ensures infinite scalability.
- **Alternatives rejected:** Raster-only logos, hand-traced without geometric grid.

Reference: [HDL/01-brand-assets.md](HDL/01-brand-assets.md), [assets/brand/logo/](assets/brand/logo/)

---

### Primary brand color
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Haven primary brand color is `#1D544E` (deep teal). Supporting brand tokens: `primaryDark` `#143D39`, `primaryLight` `#E8F2F0`, `primaryMuted` `#A5C2C0`.
- **Rationale:** Sampled from brand identity assets. Calm, premium, distinctive — not neon, not generic finance green.
- **Alternatives rejected:** Brighter teals, generic `#008080`, blue-green fintech palette.

Reference: [HDL/07-color-system.md](HDL/07-color-system.md)

---

### Light palette
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Light mode uses warm off-white backgrounds (`#FAFBFC`), white surfaces, and neutral text hierarchy (`#1A1A1C` / `#5A6167` / `#8E9499`).
- **Rationale:** Aligns with Concept C's human, reassuring feel. Avoids clinical pure-white app shells.
- **Alternatives rejected:** Pure white `#FFFFFF` backgrounds, cool gray corporate palette.

---

### Semantic color values
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Status colors: Good `#4A9B6E`, Attention `#C4862B`, Action `#C44D4D`, Interactive `#3D7BF5`. Each has a tinted background variant for status cards.
- **Rationale:** Calm and muted — communicates state without alarm. Warm amber for attention, not screaming orange.
- **Alternatives rejected:** Traffic-light neon colors, binary red/green only, `#FF0000` alarm red.

---

### Financial Pulse colors
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Pulse states: Calm `#4A9B6E`, Strong `#1D544E`, Attention `#C4862B`. Pull reveal uses `#E8F2F0` → `#FFFFFF` gradient with `#1D544E` accent.
- **Rationale:** Wellbeing framing — not a score, not gamified. Pull interaction feels calm and intentional.
- **Alternatives rejected:** Score-style red-to-green gradients, animated rainbow pulses, gauge-style color ranges.

---

### Logo SVG assets
- **Status:** Locked
- **Date:** 2026-07-10
- **Decision:** Logo assets created as SVG from geometric construction spec (2X bars, X gap, compass needle). PNG exports generated at 1024–16px. App icons in light, dark, and monochrome variants.
- **Rationale:** Production-ready assets for Flutter, Figma, and platform stores. SVG ensures infinite scalability.
- **Alternatives rejected:** Raster-only logos, hand-traced without geometric grid.

Reference: [HDL/01-brand-assets.md](HDL/01-brand-assets.md), [assets/brand/logo/](assets/brand/logo/)
