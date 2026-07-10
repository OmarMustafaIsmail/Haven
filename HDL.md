# Haven Design Language (HDL)

The evolving design specification for Haven. Token values live here—not in the manifesto.

**Status legend:** `locked` · `in-progress` · `pending`

---

## Foundations `locked`

### Design Principles

- Calm over exciting.
- Confidence before data.
- One primary message per screen.
- Motion communicates.
- Beautiful by subtraction.
- Automation over manual work.
- Trust is the product.
- Accessibility is a feature.
- Members are never judged.
- Explain every recommendation.

### Visual Style

The interface should feel Apple-level minimal, premium, quiet, elegant, modern, and timeless.

**Avoid:** neon colors, heavy gradients, complex dashboards, financial clichés, charts everywhere, visual clutter.

Whitespace is part of the design. Everything should breathe.

### Inspiration Sources

Study principles from—do not copy:

- Apple Human Interface Guidelines
- Linear
- Mercury
- Arc Browser
- Things 3

### Token Naming Convention `locked`

All design values are expressed as tokens. No hardcoded values in implementation.

| Token family | Purpose |
|---|---|
| `HavenColors` | Color palette and semantic colors |
| `HavenTypography` | Type scale, weights, line heights |
| `HavenSpacing` | Spacing scale |
| `HavenRadius` | Border radius scale |
| `HavenMotion` | Duration, easing, animation principles |

---

## Color System `in-progress`

### Primary

| Token | Value | Usage |
|---|---|---|
| `HavenColors.primary` | TBD — deep teal/forest green | Brand color, primary actions, logo |
| `HavenColors.primaryLight` | TBD | Light backgrounds, subtle accents |
| `HavenColors.primaryDark` | TBD | Dark app icon background, emphasis |

> Exact hex values pending finalization from brand assets. See [assets/brand/brand-identity.png](assets/brand/brand-identity.png).

### Semantic (Status Indicators) `locked`

Mapped to the product status legend. See [PRODUCT_DECISIONS.md](PRODUCT_DECISIONS.md).

| Token | Meaning | Usage |
|---|---|---|
| `HavenColors.statusGood` | Good | Positive status, on-track indicators |
| `HavenColors.statusAttention` | Attention | Items needing awareness, not alarm |
| `HavenColors.statusAction` | Action needed | Requires member action |
| `HavenColors.statusInteractive` | Interactive | Tappable, in-progress, or highlighted elements |

> Hex values TBD. Semantic meaning is locked; values will be defined during color system finalization.

### Surfaces (Light Mode) `in-progress`

Concept C (Haven home direction) is light-mode first. Dark mode deferred until light mode HDL is complete.

| Token | Value | Usage |
|---|---|---|
| `HavenColors.background` | TBD | App background |
| `HavenColors.surface` | TBD | Cards, elevated containers |
| `HavenColors.surfaceElevated` | TBD | Hero cards, prominent containers |
| `HavenColors.textPrimary` | TBD | Headings, primary content |
| `HavenColors.textSecondary` | TBD | Supporting text, labels |
| `HavenColors.textTertiary` | TBD | Placeholders, disabled text |
| `HavenColors.border` | TBD | Card borders, dividers |

### Do Not

- Use off-brand colors (e.g., orange for brand elements).
- Apply drop shadows or glows to the logo.
- Use neon or saturated accent colors.
- Hardcode hex values in components—always reference tokens.

---

## Typography `pending`

| Token | Value | Usage |
|---|---|---|
| `HavenTypography.display` | TBD | Safe to Spend hero amounts |
| `HavenTypography.heading1` | TBD | Screen titles |
| `HavenTypography.heading2` | TBD | Section headers |
| `HavenTypography.body` | TBD | Primary body text |
| `HavenTypography.bodySmall` | TBD | Secondary content |
| `HavenTypography.caption` | TBD | Labels, metadata |
| `HavenTypography.wordmark` | TBD | HAVEN wordmark (all-caps, generous tracking) |

---

## Spacing `pending`

| Token | Value | Usage |
|---|---|---|
| `HavenSpacing.xs` | TBD | Tight internal padding |
| `HavenSpacing.sm` | TBD | Compact spacing |
| `HavenSpacing.md` | TBD | Default spacing |
| `HavenSpacing.lg` | TBD | Section gaps |
| `HavenSpacing.xl` | TBD | Major section separation |
| `HavenSpacing.xxl` | TBD | Screen-level breathing room |

---

## Radius `pending`

| Token | Value | Usage |
|---|---|---|
| `HavenRadius.sm` | TBD | Small elements, chips |
| `HavenRadius.md` | TBD | Cards, buttons |
| `HavenRadius.lg` | TBD | Hero cards, modals |
| `HavenRadius.full` | TBD | Circular elements, avatars |

Logo construction uses rounded corners on all geometric elements. Radius scale should feel calm and elegant—not playful.

---

## Motion `pending`

Principles (locked):

- Motion communicates—it does not decorate.
- Interactions feel calm and intentional, never playful or distracting.
- Pull to Check Your Financial Pulse™ is the signature motion interaction.

| Token | Value | Usage |
|---|---|---|
| `HavenMotion.durationFast` | TBD | Micro-interactions |
| `HavenMotion.durationNormal` | TBD | Standard transitions |
| `HavenMotion.durationSlow` | TBD | Pull to Check Your Financial Pulse reveal |
| `HavenMotion.easingDefault` | TBD | Standard easing curve |
| `HavenMotion.easingDecelerate` | TBD | Elements entering view |

---

## Iconography `pending`

- Style: minimal, geometric, consistent stroke weight.
- Status indicators use the four semantic colors.
- No financial clichés (piggy banks, dollar signs, etc.).

---

## Components `pending`

Component library will be defined after color, typography, spacing, radius, and motion tokens are locked.

Anticipated components from Concept C home screen:

- Greeting header (with scenic background)
- Status card (reassuring message + indicator)
- Safe to Spend hero
- Recommendation card
- Recent activity row
- Bottom navigation bar (Home, Money, Plans, Insights, Profile)
