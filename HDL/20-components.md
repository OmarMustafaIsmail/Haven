# HDL 20 — Components

**Status:** LOCKED — Home v5 (PD-029) with Concept C cards + v4 Pulse integration

**Implementation:** [`lib/widgets/`](../lib/widgets/) · [`lib/pulse/`](../lib/pulse/) · [`lib/features/home/widgets/`](../lib/features/home/widgets/)

---

## Purpose

The Haven component catalog — shared UI building blocks and product-defining widgets. Each entry documents purpose, variants, states, spacing, interaction, motion, accessibility, and related tokens.

`FinancialPulse` owns ritual animation. Home composes around it (PD-028). Pulse interaction detail lives in [HDL/13-financial-pulse.md](13-financial-pulse.md) — this catalog references, not duplicates.

---

## Principles

- Components consume **design tokens** — never hardcoded values.
- Product-defining components (`FinancialPulse`) emit **events**; screens **listen**.
- Home content cards follow Concept C hierarchy (PD-008, PD-029).
- One recommendation per screen — no recommendation lists.
- Beautiful by subtraction — no shadows on cards unless elevation tokens exist.

---

## Catalog index

| Component | File | Scope |
|---|---|---|
| [FinancialPulse](#financialpulse) | `lib/pulse/financial_pulse.dart` | Global — Check-In ritual |
| [HavenCard](#havencard) | `lib/widgets/haven_card.dart` | Global — surface container |
| [HavenHeroCard](#havenherocard) | `lib/features/home/widgets/haven_hero_card.dart` | Home — wellbeing hero |
| [PulseLine](#pulseline) | `lib/features/home/widgets/pulse_line.dart` | Home — Check-In reading |
| [Moment](#moment) | `lib/features/moments/models/moment.dart` | Home — Hero Layer 3 |
| [MomentAcknowledgement](#momentacknowledgement) | `lib/features/moments/widgets/moment_acknowledgement.dart` | Home — Hero |
| [MoneyPlaceEditor](#moneyplaceeditor) | `lib/features/money/widgets/money_place_editor_sheet.dart` | Money layer |
| [ActivitySection](#activitysection) | `lib/features/home/widgets/activity_section.dart` | Home |
| [HomeTopBar](#hometopbar) | `lib/features/home/widgets/home_top_bar.dart` | Home |
| [HomeConceptCHeroBackground](#homeconceptcherobackground) | `lib/features/home/widgets/home_concept_c_hero.dart` | Home |
| [HavenExperience](#havenexperience) | `lib/features/shell/haven_experience.dart` | Shell — unified layers |
| [HavenLayerBody](#havenlayerbody) | `lib/features/shell/widgets/haven_layer_body.dart` | Shell — morphing body |
| [MoneyTotalSection](#moneytotalsection) | `lib/features/money/widgets/money_hero.dart` | Money layer |
| [MoneyLivesInSection](#moneylivesinsection) | `lib/features/money/widgets/money_lives_in_section.dart` | Money layer |
| [ConnectedPlansSection](#connectedplanssection) | `lib/features/money/widgets/connected_plans_section.dart` | Money layer |
| [PlansLayerBody](#planslayerbody) | `lib/features/plans/widgets/plans_layer_body.dart` | Plans layer |
| [CreatePlanSheet](#createplansheet) | `lib/features/plans/widgets/create_plan_sheet.dart` | Plans layer |
| [PlanDetailSheet](#plandetailsheet) | `lib/features/plans/widgets/plan_detail_sheet.dart` | Plans layer |
| [RecentMovementSection](#recentmovementsection) | `lib/features/money/widgets/recent_movement_section.dart` | Money layer |
| [HavenBottomNav](#havenbottomnav) | `lib/features/shell/widgets/haven_bottom_nav.dart` | Shell |
| [HavenLogo](#havenlogo) | `lib/widgets/haven_logo.dart` | Global |
| [HavenPrimaryButton](#havenprimarybutton) | `lib/widgets/haven_primary_button.dart` | Global |
| [HavenTextButton](#haventextbutton) | `lib/widgets/haven_text_button.dart` | Global |

---

## FinancialPulse

### Purpose

Haven's signature Check-In ritual widget. Owns breath, pull, heartbeat, haptics, header chrome, and animation state.

### Variants

| Mode | Trigger | Layout |
|---|---|---|
| First launch | `showHeroPresentation: true` | Expanded greeting + larger circle |
| Header rest | Default after settle | Greeting row + 22px circle |

Form is always a **circle** (PD-026). No glyph variants.

### States

Maps to `PulseRitualPhase` — see [HDL/13-financial-pulse.md](13-financial-pulse.md#states).

Wellbeing color from `PulseState`: `calm` · `strong` · `attention`.

### Spacing

- Header height: `HavenMotion.conceptCChromeHeight` (108px)
- Toolbar band: `HavenMotion.conceptCToolbarHeight` (40px)
- Content shift during pull: up to `HavenMotion.pulseContentShiftMax` (76px)

### Interaction

- Pull-down Check-In when scroll at top
- Callbacks: `onCheckInStarted`, `onThresholdReached`, `onResolveBeat`, `onHeartbeatFinished`, `onReturnedHome`, `onPullProgress`, `onBeatProgress`
- Child slot: scrollable Home content

### Motion

Full timing, springs, and haptics: [HDL/13-financial-pulse.md](13-financial-pulse.md).

### Accessibility

Color + copy for state. Pull-only Check-In needs alternative (open). See HDL/13.

### Related tokens

`HavenMotion.*` (pulse) · `HavenColors.pulse*` · `pulseColorFor()`

### Demo

`lib/pulse/demo/financial_pulse_demo_screen.dart`

---

## HavenCard

### Purpose

Shared soft-card surface for content across Haven.

### Variants

| Variant | Fill | Border |
|---|---|---|
| Default | `HavenColors.surface` | `HavenColors.borderSubtle` |
| Elevated | `HavenColors.surfaceElevated` | `HavenColors.borderSubtle` |
| Reading (via HavenHeroCard) | Accent tint blend | Accent at 22% alpha |
| Tappable | Same + `InkWell` | Same |

### States

Default · Pressed (when `onTap` set) · Custom `color` / `borderColor` overrides

### Spacing

| Property | Token | Value |
|---|---|---|
| Radius | `HavenRadius.lg` | 24 |
| Padding | `HavenSpacing.lg` | 24 |
| Margin H | `HavenSpacing.md` | 16 |
| Margin V | `HavenSpacing.sm` | 8 |

Override via constructor `margin`, `padding`.

### Interaction

Optional `onTap` — wraps in `Material` + `InkWell` with matching radius.

### Motion

None intrinsic.

### Accessibility

Ensure tap targets meet 44×44 when `onTap` is used. Pair semantic colors with text.

### Related tokens

`HavenRadius.lg` · `HavenSpacing.*` · `HavenColors.surface` · `HavenColors.borderSubtle`

---

## HavenHeroCard

### Purpose

Emotional center of Home — one calm conversational component (PD-032). Hosts **Pulse Line** during Check-In reading (PD-030).

Answers two questions on every open:

1. *"How am I doing?"* — Layer 1: Financial State
2. *"Is there anything I should know today?"* — Layer 3: Today's Moment

### Three layers

| Layer | Name | Persistence | Source |
|---|---|---|---|
| 1 | Financial State | Always visible | `PulseState` only — via `PulseStatusCopy.financialState()` |
| 2 | Safe to Spend | Always visible, dominant | `safeToSpend` amount |
| 3 | Today's Moment | Optional — hidden when null | `TodaysMoment?` — future Haven Intelligence |

Whitespace separates layers. No dividers between sections. No notification styling.

### Variants

Single layout — content driven by props.

### States

| State | Props | Visual |
|---|---|---|
| Resting | `isReading: false`, `pulseRevealed: true` | All three layers (moment if present) |
| Pull | (Home shifts card) | **Unchanged** — same copy, shifted down |
| Reading | `isReading: true` | "Reading your Pulse" + PulseLine; content dimmed |
| Pre-reveal | `pulseRevealed: false` during reading | Dimmed prior copy |
| Revealed | After Check-In | Layer 1 updates from new `PulseState`; moment unchanged |

### Spacing

- Outer padding: horizontal `HavenSpacing.md`, vertical `HavenSpacing.xs`
- Between layers: `HavenSpacing.lg`
- Inner: inherits `HavenCard` padding (`lg`)

### Interaction

- Safe to Spend chevron → Money layer (`onEnterMoney`)
- Today's Moment actions → `onMomentAction(actionId)`
- Check-In driven by `HomeCubit` via `isReading` / `pulseRevealed`

### Motion

Pulse Line sweep: `HavenMotion.pulseLineDuration` (1800ms). Content dim: 280ms opacity.

### Accessibility

Financial State: text + colored dot — not color alone.

### Related tokens

`HavenTypography.*` · `HavenColors.*` · `pulseColorFor()` · `HavenMotion.pulseLineDuration`

### Supersedes

Separate headline + detail pair; `RecommendationCard` on Home body.

---

## PulseLine

### Purpose

Hospital-monitor-style ECG sweep — transient reading animation during Check-In (PD-030). **Not** the header Pulse circle.

### Variants

Single sweep path. Color passed via `color` prop (typically `PulseState` accent).

### States

| State | Prop | Behaviour |
|---|---|---|
| Active | `active: true` | Animates forward once |
| Complete | — | Fires `onComplete` once |

### Spacing

Height: `HavenMotion.pulseLineHeight` (56px). Width: fills card content area.

### Interaction

None — display-only animation.

### Motion

Duration: `HavenMotion.pulseLineDuration` (1800ms). Single left-to-right sweep.

### Accessibility

Decorative animation — meaning conveyed by surrounding "Reading your Pulse" copy.

### Related tokens

`HavenMotion.pulseLineDuration` · `HavenMotion.pulseLineHeight`

---

## Moment

### Purpose

Hero Layer 3 — the active **Moment** primitive (PD-034). Generic: title, description, dynamic actions. Not a notification, feed, or alert.

### Variants

Any `MomentType` (confirmation, question, reminder, insight, celebration, recommendation, information). UI does not special-case types except acknowledgement copy.

### States

Active (rendered) · Acknowledgement (transient inline) · Absent (section omitted)

### Interaction

Dynamic action buttons from `Moment.actions`. Outcomes: complete, dismiss, later, navigate.

### Related

Rendered inside `HavenHeroCard`. Engine: `lib/features/moments/`.

---

## MomentAcknowledgement

### Purpose

Inline feedback after a Moment action — type-based copy, then fades (PD-034).

### Motion

~2s display, fade out via `HavenMotion` tokens.

---

## MoneyPlaceEditor

### Purpose

Bottom sheet for Add/Edit Money Place — name, balance, source (Manual read-only in MVP).

### Interaction

Save · Delete (edit mode) · Cancel

---

## RecommendationCard

**Superseded by Today's Moment (PD-032).** Removed from Home body.

---

## ActivitySection

### Purpose

Quiet recent-activity context at the bottom of Home — **transactions** and **member interactions** (PD-033, PD-034).

### Variants

| Kind | Display |
|---|---|
| `transaction` | Icon + label + signed amount |
| `interaction` | Icon + label + timestamp (no amount) |

### States

Default · Empty list (not yet designed)

### Spacing

- Section title: horizontal `HavenSpacing.md`
- Title-to-list gap: `HavenSpacing.sm`
- Row padding: symmetric vertical `sm`, horizontal `lg`

### Interaction

Optional `onSeeAll` — `TextButton` in section header.

### Motion

None.

### Accessibility

Each row: merchant + amount + date as separate text nodes.

### Related tokens

`HavenTypography.title` · `HavenColors.primary` · `HavenRadius.sm` (avatar containers)

---

## HomeTopBar

### Purpose

Concept C top bar — logo and quiet actions above the hero illustration.

### Variants

Fixed layout: logo left, gift + notification icons right.

### States

Static.

### Spacing

Padding: horizontal `md`, vertical `xs`. Logo height: 28px in 6px padded circle.

### Interaction

Action icons present — handlers not wired on Home v5.

### Motion

None.

### Accessibility

Icon buttons need semantic labels when wired.

### Related tokens

`HavenSpacing.*` · `HavenColors.surface` · [HavenLogo](#havenlogo)

---

## HomeConceptCHeroBackground

### Purpose

Concept C hero illustration band — gradient tint follows `PulseState`.

### Variants

Tint derived from `pulseColorFor(pulseState)` blended into gradient stops.

### States

Updates when `PulseState` changes after Check-In reveal.

### Spacing

Fills hero region above greeting — height coordinated with `HavenMotion.conceptCChromeHeight`.

### Interaction

None — decorative background.

### Motion

Color transitions when state changes (implicit via rebuild).

### Accessibility

Decorative — no information conveyed by gradient alone.

### Related tokens

`pulseColorFor()` · `HavenColors.background`

---

## HavenBottomNav

### Purpose

Five-tab **depth affordance** — selects Haven layer, not a page router (PD-031).

### Variants

| Item | Status |
|---|---|
| Home | Active — surface layer |
| Money | Active — deeper layer |
| Plans | Active — intent layer |
| Insights, Profile | Disabled placeholder |

### States

Active: `primary` icon + label. Inactive: `textTertiary`. Disabled: reduced opacity.

### Spacing

Vertical padding: `HavenSpacing.sm`. Top border: `borderSubtle`.

### Interaction

Tap Home, Money, or Plans triggers layer morph — no page push. Same transition as Safe to Spend chevron for Money entry.

### Motion

None on nav itself — transition owned by `FinancialPulse` layer ritual.

### Accessibility

Each tab: icon + text label. Disabled tabs should announce unavailable state.

### Related tokens

`HavenColors.primary` · `HavenColors.textTertiary` · `HavenColors.borderSubtle` · `HavenTypography.caption`

---

## HavenExperience

### Purpose

Unified Haven shell — persistent chrome + morphing layer body (PD-031).

### Variants

Single composition: `FinancialPulse` + `HavenHeroCard` + `HavenLayerBody`.

### States

`HavenLayer.home` · `HavenLayer.money` · `HavenLayer.plans` · transitioning (blocks re-entry).

### Interaction

- Bottom nav selects layer
- HavenHeroCard chevron → Money layer
- Check-In pull unchanged on Home layer

### Motion

Layer transition via `FinancialPulse.runLayerTransition` — see HDL/13.

### Related tokens

`HavenMotion.layerTravelDuration` · `HavenMotion.layerBodyFadeDuration`

---

## HavenLayerBody

### Purpose

Crossfades Home body (recommendation + activity) ↔ Money body (total, places, plans, movement).

### Motion

Fade + slide driven by `morphProgress` during layer heartbeat window.

---

## MoneyTotalSection

### Purpose

"Total Money" + amount — compact section beneath HavenHeroCard. Keyed `money_hero` for future interaction.

**Supersedes:** standalone `MoneyScreen` scaffold title.

---

## HavenLogo

### Purpose

Renders Haven brand mark from SVG assets.

### Variants

Asset selection via constructor (primary default). See [HDL/01-brand-assets.md](01-brand-assets.md).

### States

Static.

### Spacing

Controlled by `height` prop. Maintain clear space per brand rules.

### Interaction

None intrinsic.

### Motion

None.

### Accessibility

Mark as decorative or provide `semanticLabel: 'Haven'` when standalone.

### Related tokens

Brand colors in SVG — see HDL/01.

---

## HavenPrimaryButton

### Purpose

Primary filled action button for forms and confirmations.

### Variants

| Variant | Prop |
|---|---|
| Full width | `expanded: true` (default) |
| Intrinsic width | `expanded: false` |

### States

Enabled · Disabled (`onPressed: null`) — `primaryMuted` background

### Spacing

Padding: horizontal `lg`, vertical `md`. Radius: `HavenRadius.md` (16).

### Interaction

Standard `FilledButton` press.

### Motion

Material ripple.

### Accessibility

Minimum tap height from padding + `FilledButton` defaults.

### Related tokens

`HavenColors.primary` · `HavenColors.surface` · `HavenTypography.title`

---

## HavenTextButton

### Purpose

Text-only secondary action.

### Variants

Single style — primary-colored label.

### States

Enabled · Disabled

### Spacing

Minimal — platform `TextButton` defaults.

### Interaction

Standard text button press.

### Motion

Material ripple.

### Accessibility

Ensure label describes action.

### Related tokens

`HavenColors.primary` · `HavenTypography.body`

---

## Composition — HavenExperience

```
FinancialPulse (persistent chrome + layer transition)
├── HomeConceptCHeroBackground
├── HomeTopBar
├── Greeting + Pulse
└── child: ListView
    ├── HavenHeroCard (persistent — chevron → Money)
    └── HavenLayerBody
        ├── Home: ActivitySection
        └── Money: MoneyTotalSection + places + plans + movement
HavenBottomNav (depth affordance)
```

Standalone `HomeScreen` remains for widget tests. Production shell uses `HavenExperience`.

---

## Rules

- Import Pulse spec from HDL/13 — do not duplicate ritual rules here.
- Use `HavenCard` for all card surfaces — no one-off card decorations.
- Today's Moment max one per Hero — no moment lists
- Never drive `FinancialPulse` animation from cubit rebuilds.

---

## Examples

### Correct — Home composition

`FinancialPulse` wraps scrollable list. Hero card receives `isReading` / `pulseRevealed` from cubit after threshold.

### Incorrect

- Duplicate card styling without `HavenCard` ❌
- Multiple recommendation cards ❌
- Pulse Line in header circle ❌
- Scrambled amounts in `HavenHeroCard` during reading ❌

---

## Accessibility

- All status communication: text + color.
- Icon-only controls need labels when wired.
- Check-In pull needs non-gesture alternative (tracked in HDL/13).

---

## Future extensions

| Component | Extension |
|---|---|
| HavenCard | Elevation variant when HDL/11 tokens exist |
| HavenPrimaryButton | Loading state |
| ActivitySection | Empty state |
| HavenBottomNav | Enable remaining tabs |
| MoneyScreen scaffold | Superseded by HavenExperience layer composition |
| HomeTopBar | Wire notification / gift actions |

---

## Related

- [HDL/13-financial-pulse.md](13-financial-pulse.md) — definitive Pulse spec
- [PRODUCT_ARCHITECTURE.md](../PRODUCT_ARCHITECTURE.md) — Home product architecture
- [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md) — PD-028, PD-029, PD-030
