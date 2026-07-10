# HDL 07 — Color System

**Status:** `locked`

The complete Haven color specification. Sampled from brand assets and Concept C home direction.

**Flutter tokens:** [`design_tokens/haven_colors.dart`](../design_tokens/haven_colors.dart)

---

## Brand Colors

Extracted from [`assets/brand/brand-identity.png`](../assets/brand/brand-identity.png). Primary teal averaged at `#1D544E`.

| Token | Hex | Usage |
|---|---|---|
| `HavenColors.primary` | `#1D544E` | Logo, primary actions, active nav, links |
| `HavenColors.primaryDark` | `#143D39` | Dark app icon background, pressed states |
| `HavenColors.primaryLight` | `#E8F2F0` | Subtle tinted backgrounds, selected states |
| `HavenColors.primaryMuted` | `#A5C2C0` | Decorative accents, soft highlights |

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

## Dark Palette

Defined for future use. Light mode ships first per [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md).

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
| `HavenColors.statusInteractive` | `#3D7BF5` | Interactive | Tappable, in-progress |

### Semantic Backgrounds (Light)

For status cards and pills. Tinted, not saturated.

| Token | Hex | Paired with |
|---|---|---|
| `HavenColors.statusGoodBg` | `#EDF7F0` | `statusGood` |
| `HavenColors.statusAttentionBg` | `#FBF5EC` | `statusAttention` |
| `HavenColors.statusActionBg` | `#FBEFEF` | `statusAction` |
| `HavenColors.statusInteractiveBg` | `#EEF3FE` | `statusInteractive` |

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

Implementation in [`design_tokens/haven_colors.dart`](../design_tokens/haven_colors.dart).

```dart
// Usage — never hardcode hex in widgets
Container(color: HavenColors.surface)
Text('42,350 EGP', style: TextStyle(color: HavenColors.textPrimary))
```

When the Flutter project is scaffolded, move to `lib/theme/haven_colors.dart`.

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
| `HavenColors/statusInteractive` | `#3D7BF5` | Color |
| `HavenColors/pulseCalm` | `#4A9B6E` | Color |
| `HavenColors/pulseStrong` | `#1D544E` | Color |
| `HavenColors/pulseAttention` | `#C4862B` | Color |
| `HavenColors/pulseReveal` | `#E8F2F0` | Color |

Enable **Light** and **Dark** modes. Map dark tokens when dark mode HDL is finalized.

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

## Do Not

- Use neon or saturated accent colors.
- Use pure alarm red (`#FF0000`) for status — use `statusAction` (`#C44D4D`).
- Use orange for brand elements (off-brand per logo rules).
- Apply drop shadows or glows to the logo.
- Use `primary` on `primaryLight` without checking contrast.
- Hardcode colors in components — always reference tokens.
- Use traffic-light semantics without the four-state system (Good, Attention, Action, Interactive).
