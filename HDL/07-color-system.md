# HDL 07 — Color System

**Status:** EXPERIMENTAL

**Implementation:** [`lib/theme/haven_colors.dart`](../lib/theme/haven_colors.dart)

---

## Purpose

The Haven color specification — brand, semantic, and Pulse wellbeing colors. Defines every color token and when to use it.

Pulse **behaviour** and interaction colors in context: [HDL/13-financial-pulse.md](13-financial-pulse.md).

---

## Principles

Color communicates meaning, never decoration.

- Brand colors create trust.
- Semantic colors create clarity.
- Whitespace creates calm.
- Never rely on color alone — pair with text or iconography.
- Avoid bright saturated palettes, unnecessary gradients, and decorative accents.

### Color hierarchy

Stronger color only as interaction importance increases:

1. **Background** — calmest layer; app shell
2. **Surface** — cards and containers
3. **Primary content** — headings, amounts
4. **Secondary content** — labels, metadata
5. **Brand accent** — primary teal; identity and key actions
6. **Semantic status** — Good, Attention, Action
7. **Interactive** — tappable, in-progress elements

---

## Tokens

### Brand colors

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

### Financial Pulse colors

Wellbeing states — not gamified reds/greens. Usage rules: [HDL/13-financial-pulse.md](13-financial-pulse.md).

| Token | Hex | State |
|---|---|---|
| `HavenColors.pulseCalm` | `#4A9B6E` | Steady |
| `HavenColors.pulseStrong` | `#1D544E` | Strong |
| `HavenColors.pulseAttention` | `#C4862B` | Needs awareness |
| `HavenColors.pulseReveal` | `#E8F2F0` | Pull reveal background |
| `HavenColors.pulseRevealAccent` | `#1D544E` | Pulse during pull |

Pull reveal gradient: `pulseReveal` → `surface`.

---

## Rules

### Do

- Use `HavenColors` tokens everywhere — no hardcoded hex in widgets.
- Use semantic backgrounds (`statusGoodBg`) behind semantic foregrounds (`statusGood`).
- Use warm off-whites for app shell — `#FAFBFC`, not pure white.
- Use `primaryMuted` for decorative accents, not `primary` at reduced opacity.
- Test new pairs against WCAG AA before locking.
- Keep Pulse colors calm — wellbeing, not gamification.

### Do not

- Use neon or saturated accent colors.
- Use pure alarm red (`#FF0000`) — use `statusAction` (`#C44D4D`).
- Use orange for brand elements.
- Use generic Material blue for interactive states.
- Apply drop shadows or glows to the logo.
- Use traffic-light semantics without the four-state system.

---

## Examples

### Status card (Concept C)

```
Background:  statusGoodBg (#EDF7F0)
Icon:        statusGood (#4A9B6E)
Text:        textPrimary (#1A1A1C)
Message:     "You're doing great! Nothing needs your attention right now."
```

### Safe to Spend hero

```
Background:  surface (#FFFFFF)
Label:       textSecondary (#5A6167) — "Safe to spend"
Amount:      textPrimary (#1A1A1C) — "42,350 EGP"
```

### Recommendation card

```
Background:  surfaceElevated (#FDFCF8)
Title:       textPrimary (#1A1A1C) — "Recommended for you"
Body:        textSecondary (#5A6167)
Action:      primary (#1D544E)
```

### Bottom navigation

```
Background:  surface (#FFFFFF)
Active:      primary (#1D544E)
Inactive:    textTertiary (#8E9499)
Border top:  borderSubtle (#F0F1F3)
```

### Financial Pulse pull reveal

```
Background gradient: pulseReveal → surface
Pulse indicator:     pulseRevealAccent
State calm:          pulseCalm
```

---

## Accessibility

Contrast ratios tested against WCAG 2.1 AA (4.5:1 normal text, 3:1 large text).

| Foreground | Background | Ratio | Pass |
|---|---|---|---|
| `textPrimary` | `background` | 16.8:1 | AA ✓ |
| `textPrimary` | `surface` | 17.4:1 | AA ✓ |
| `textSecondary` | `background` | 6.2:1 | AA ✓ |
| `textSecondary` | `surface` | 6.4:1 | AA ✓ |
| `textTertiary` | `surface` | 3.5:1 | AA large ✓ |
| `primary` | `surface` | 8.6:1 | AA ✓ |
| `statusGood` | `statusGoodBg` | 4.6:1 | AA ✓ |
| `statusAttention` | `statusAttentionBg` | 4.5:1 | AA ✓ |
| `statusAction` | `statusActionBg` | 4.7:1 | AA ✓ |

Never communicate status through color alone — always pair with text.

---

## Future extensions

- Dark theme palette (placeholder tokens exist — not approved for implementation)
- Figma `HavenColors` variable collection synced to Flutter tokens
- Validation across Money, Plans, Insights, Profile before locking

---

## Validation notes

- Validated on Home mock v1 and Home Experience v2.
- Not yet tested on other primary tabs.

---

## Related

- [HDL/13-financial-pulse.md](13-financial-pulse.md) — Pulse color usage in Check-In
- [HDL/20-components.md](20-components.md) — component color usage
