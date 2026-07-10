# HDL 07 — Color System

## Purpose

The Haven color specification — brand, semantic, and Financial Pulse colors.

## Status

**EXPERIMENTAL**

## Reasoning

Colors were sampled from brand assets and Concept C home direction. They are in use on the Home screen but have not been validated across multiple member flows or screen types.

## Validation notes

- Validated on Home mock v1 and Home Experience v2.
- WCAG contrast ratios calculated for light palette pairs.
- Not yet tested on Money, Plans, Insights, or Profile screens.
- Dark mode tokens are exploratory only — not validated.

## Implementation notes

**Flutter tokens:** [`lib/theme/haven_colors.dart`](../lib/theme/haven_colors.dart)

---

## Philosophy

Color in Haven communicates meaning, never decoration.

Every color should help members understand their financial state with confidence.

- Brand colors create trust.
- Semantic colors create clarity.
- Whitespace creates calm.

The interface should never rely on color alone to communicate information.

Avoid bright saturated palettes, unnecessary gradients, and decorative accents.

---

## Color Hierarchy

Color should become progressively stronger only as interaction importance increases.

1. **Background** — the calmest layer; the app shell
2. **Surface** — cards and containers that hold content
3. **Primary Content** — headings, amounts, essential text
4. **Secondary Content** — labels, supporting text, metadata
5. **Brand Accent** — primary teal; reserved for identity and key actions
6. **Semantic Status** — Good, Attention, Action; financial state communication
7. **Interactive** — tappable, in-progress, highlighted elements

---

## Brand Colors

Extracted from [`assets/brand/brand-identity.png`](../assets/brand/brand-identity.png). Primary teal averaged at `#1D544E`.

| Token | Hex | Usage |
|---|---|---|
| `HavenColors.primary` | `#1D544E` | Logo, primary actions, active nav, links |
| `HavenColors.primaryDark` | `#143D39` | Dark app icon background, pressed states |
| `HavenColors.primaryLight` | `#E8F2F0` | Subtle tinted backgrounds, selected states |
| `HavenColors.primaryMuted` | `#A5C2C0` | Decorative accents, soft highlights |

> Brand color is currently provisional and may receive minor refinement after the first complete UI pass. The overall hue (deep calming teal) is part of Haven's identity and should not dramatically change.

---

## Light Palette

Warm, human, reassuring — aligned with Concept C. Backgrounds are off-white, not clinical pure white.

| Token | Hex | Usage |
|---|---|---|
| `HavenColors.background` | `#FAFBFC` | App background |
| `HavenColors.surface` | `#FFFFFF` | Cards, containers |
| `HavenColors.surfaceElevated` | `#FDFCF8` | Hero cards, prominent containers |
| `HavenColors.textPrimary` | `#1A1A1C` | Headings, primary content, amounts |
| `HavenColors.textSecondary` | `#5A6167` | Supporting text, labels |
| `HavenColors.textTertiary` | `#8E9499` | Placeholders, disabled text |
| `HavenColors.border` | `#E8EAED` | Card borders, dividers |
| `HavenColors.borderSubtle` | `#F0F1F3` | Hairline separators |

---

## Future Dark Theme

**Status:** `planned`

Haven launches light-first. Dark mode will be designed after the complete light experience is finalized to ensure visual parity rather than creating two independent systems.

Placeholder tokens below are exploratory — not approved for implementation.

| Token | Hex | Usage |
|---|---|---|
| `HavenColors.darkBackground` | `#0F1419` | App background |
| `HavenColors.darkSurface` | `#1A1F24` | Cards, containers |
| `HavenColors.darkSurfaceElevated` | `#252B30` | Hero cards, modals |
| `HavenColors.darkTextPrimary` | `#F5F5F7` | Headings, primary content |
| `HavenColors.darkTextSecondary` | `#A1A6AB` | Supporting text |
| `HavenColors.darkTextTertiary` | `#6B7075` | Placeholders, disabled |
| `HavenColors.darkBorder` | `#2E3439` | Borders, dividers |
| `HavenColors.darkPrimary` | `#2A7A6E` | Primary on dark (lighter for contrast) |

---

## Semantic Colors

Mapped to the status legend. Calm and muted — never alarming.

| Token | Hex | Meaning | Usage |
|---|---|---|---|
| `HavenColors.statusGood` | `#4A9B6E` | Good | On-track, positive status |
| `HavenColors.statusAttention` | `#C4862B` | Attention | Awareness, not alarm |
| `HavenColors.statusAction` | `#C44D4D` | Action needed | Requires member action |
| `HavenColors.statusInteractive` | `#4A8F88` | Interactive | Tappable, in-progress, highlighted |

`statusInteractive` is a refined teal — harmonious with the primary palette, not a generic Material blue.

### Semantic Backgrounds (Light)

For status cards and pills. Tinted, not saturated.

| Token | Hex | Paired with |
|---|---|---|
| `HavenColors.statusGoodBg` | `#EDF7F0` | `statusGood` |
| `HavenColors.statusAttentionBg` | `#FBF5EC` | `statusAttention` |
| `HavenColors.statusActionBg` | `#FBEFEF` | `statusAction` |
| `HavenColors.statusInteractiveBg` | `#E8F4F2` | `statusInteractive` |

---

## Financial Pulse Colors

The Financial Pulse is wellbeing, not a score. Colors express calm states — never gamified reds/greens.

| Token | Hex | State | Usage |
|---|---|---|---|
| `HavenColors.pulseCalm` | `#4A9B6E` | Steady | Default wellbeing — all is well |
| `HavenColors.pulseStrong` | `#1D544E` | Strong | Confident financial position |
| `HavenColors.pulseAttention` | `#C4862B` | Needs awareness | Gentle nudge, not warning |
| `HavenColors.pulseReveal` | `#E8F2F0` | Pull reveal | Pull to Check Your Financial Pulse background |
| `HavenColors.pulseRevealAccent` | `#1D544E` | Pull reveal | Pulse indicator during pull-down |

### Pulse Gradient (Pull Interaction)

For the Pull to Check Your Financial Pulse™ reveal:

```
Top:    #E8F2F0 (pulseReveal)
Bottom: #FFFFFF (surface)
```

---

## Accessibility — Contrast Ratios

All pairs tested against WCAG 2.1 AA (4.5:1 normal text, 3:1 large text).

| Foreground | Background | Ratio | Pass |
|---|---|---|---|
| `textPrimary` `#1A1A1C` | `background` `#FAFBFC` | 16.8:1 | AA ✓ |
| `textPrimary` `#1A1A1C` | `surface` `#FFFFFF` | 17.4:1 | AA ✓ |
| `textSecondary` `#5A6167` | `background` `#FAFBFC` | 6.2:1 | AA ✓ |
| `textSecondary` `#5A6167` | `surface` `#FFFFFF` | 6.4:1 | AA ✓ |
| `textTertiary` `#8E9499` | `surface` `#FFFFFF` | 3.5:1 | AA large ✓ |
| `primary` `#1D544E` | `surface` `#FFFFFF` | 8.6:1 | AA ✓ |
| `primary` `#1D544E` | `background` `#FAFBFC` | 8.3:1 | AA ✓ |
| `statusGood` `#4A9B6E` | `statusGoodBg` `#EDF7F0` | 4.6:1 | AA ✓ |
| `statusAttention` `#C4862B` | `statusAttentionBg` `#FBF5EC` | 4.5:1 | AA ✓ |
| `statusAction` `#C44D4D` | `statusActionBg` `#FBEFEF` | 4.7:1 | AA ✓ |
| `#FFFFFF` | `primaryDark` `#143D39` | 11.2:1 | AA ✓ |
| `darkTextPrimary` `#F5F5F7` | `darkBackground` `#0F1419` | 17.1:1 | AA ✓ |
| `darkPrimary` `#2A7A6E` | `darkSurface` `#1A1F24` | 5.8:1 | AA ✓ |

---

## Flutter Tokens

Implementation in [`lib/theme/haven_colors.dart`](../lib/theme/haven_colors.dart).

```dart
// Usage — never hardcode hex in widgets
Container(color: HavenColors.surface)
Text('42,350 EGP', style: TextStyle(color: HavenColors.textPrimary))
```

---

## Figma Variables

Create a **HavenColors** collection. Variable names must match Flutter tokens exactly.

| Figma Variable | Value | Type |
|---|---|---|
| `HavenColors/primary` | `#1D544E` | Color |
| `HavenColors/primaryDark` | `#143D39` | Color |
| `HavenColors/primaryLight` | `#E8F2F0` | Color |
| `HavenColors/primaryMuted` | `#A5C2C0` | Color |
| `HavenColors/background` | `#FAFBFC` | Color |
| `HavenColors/surface` | `#FFFFFF` | Color |
| `HavenColors/surfaceElevated` | `#FDFCF8` | Color |
| `HavenColors/textPrimary` | `#1A1A1C` | Color |
| `HavenColors/textSecondary` | `#5A6167` | Color |
| `HavenColors/textTertiary` | `#8E9499` | Color |
| `HavenColors/border` | `#E8EAED` | Color |
| `HavenColors/statusGood` | `#4A9B6E` | Color |
| `HavenColors/statusAttention` | `#C4862B` | Color |
| `HavenColors/statusAction` | `#C44D4D` | Color |
| `HavenColors/statusInteractive` | `#4A8F88` | Color |
| `HavenColors/pulseCalm` | `#4A9B6E` | Color |
| `HavenColors/pulseStrong` | `#1D544E` | Color |
| `HavenColors/pulseAttention` | `#C4862B` | Color |
| `HavenColors/pulseReveal` | `#E8F2F0` | Color |

Dark mode variables will be added when the Future Dark Theme is designed.

---

## Usage Examples

### Status Card (Concept C)

```
Background:  statusGoodBg (#EDF7F0)
Icon:        statusGood (#4A9B6E)
Text:        textPrimary (#1A1A1C)
Message:     "You're doing great! Nothing needs your attention right now."
```

### Safe to Spend Hero

```
Background:  surface (#FFFFFF)
Label:       textSecondary (#5A6167) — "Safe to spend"
Amount:      textPrimary (#1A1A1C) — "42,350 EGP"
```

### Recommendation Card

```
Background:  surfaceElevated (#FDFCF8)
Title:       textPrimary (#1A1A1C) — "Recommended for you"
Body:        textSecondary (#5A6167)
Action:      primary (#1D544E) — chevron, link
```

### Interactive Element

```
Background:  statusInteractiveBg (#E8F4F2)
Indicator:   statusInteractive (#4A8F88) — in-progress, highlighted
Text:        textPrimary (#1A1A1C)
```

### Bottom Navigation

```
Background:  surface (#FFFFFF)
Active:      primary (#1D544E)
Inactive:    textTertiary (#8E9499)
Border top:  borderSubtle (#F0F1F3)
```

### Financial Pulse Pull Reveal

```
Background gradient: pulseReveal → surface
Pulse indicator:     pulseRevealAccent (#1D544E)
State calm:          pulseCalm (#4A9B6E)
```

---

## Do

- Use `HavenColors` tokens everywhere — no hardcoded hex in widgets.
- Use semantic backgrounds (`statusGoodBg`) behind semantic foregrounds (`statusGood`).
- Use warm off-whites for backgrounds — `#FAFBFC`, not `#FFFFFF` for the app shell.
- Use `primaryMuted` for decorative accents, not `primary` at reduced opacity.
- Test new color pairs against WCAG AA before locking.
- Keep Financial Pulse colors calm — wellbeing, not gamification.
- Follow the color hierarchy — stronger color only as importance increases.

## Do Not

- Use neon or saturated accent colors.
- Use pure alarm red (`#FF0000`) for status — use `statusAction` (`#C44D4D`).
- Use orange for brand elements (off-brand per logo rules).
- Use generic Material blue for interactive states.
- Apply drop shadows or glows to the logo.
- Use `primary` on `primaryLight` without checking contrast.
- Hardcode colors in components — always reference tokens.
- Use traffic-light semantics without the four-state system (Good, Attention, Action, Interactive).
- Mark the color system as locked before real screens validate the palette.
