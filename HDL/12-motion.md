# HDL 12 — Motion

**Status:** EXPERIMENTAL

**Implementation:** [`lib/theme/haven_motion.dart`](../lib/theme/haven_motion.dart)

---

## Purpose

Global motion principles and shared motion tokens for Haven. Defines how movement should feel across the product.

**Pulse-specific motion** (Check-In ritual, heartbeat, springs, haptics) is specified entirely in [HDL/13-financial-pulse.md](13-financial-pulse.md). This document covers principles and non-Pulse tokens only.

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

### Global rules

- Everything moves **slowly**.
- Everything **breathes** where appropriate.
- Nothing **bounces** — no overshoot springs except where physically justified.
- All validated durations live in `HavenMotion` — **never hardcoded** in widgets.
- The member should remember the **feeling**, not the animation.

### Avoid

- Playful animations
- Elastic exaggeration
- Bouncy effects
- Overly decorative transitions
- Particles, flying objects, magical effects
- Refresh or loading metaphors (spinners, progress bars, rotation icons)
- Content disappearing or fading during Check-In
- Page push / slide-left between Haven layers (use Pulse-anchored morph — PD-031)

---

## Tokens

Non-Pulse tokens in `HavenMotion`:

### Layer transition (PD-031)

Body morph when deepening between Home and Money. **Pulse animation is reserved for pull Check-In only** — layer changes do not move or beat the Pulse.

| Token | Duration / value |
|---|---|
| `layerBodyMorphDuration` | 240ms |
| `layerBodySlideOffset` | 12px |
| `layerCurve` | `easeOutCubic` |

### Home unfold stagger (legacy)

Used for sequential content appearance after heartbeat. May be revised.

| Token | Duration |
|---|---|
| `unfoldStatusDelay` | 100ms |
| `unfoldMoneyDelay` | 250ms |
| `unfoldGuidanceDelay` | 450ms |
| `unfoldActivityDelay` | 600ms |
| `countUpDuration` | 800ms |
| `homeUnfoldTotalDuration` | heartbeat + 800ms |

### Curves

| Token | Curve |
|---|---|
| `unfoldCurve` | `easeOut` |
| `pulseBreathCurve` | `easeInOut` |
| `pulseSettleCurve` | `easeOut` |
| `pulseRevealCurve` | `easeOutCubic` |
| `pulseHeartbeatExpandCurve` | `easeOutCubic` |
| `pulseHeartbeatContractCurve` | `easeInOut` |

### Shared pull threshold

| Token | Value |
|---|---|
| `pullThreshold` | 120px |

Used by Pulse Check-In — see HDL/13 for pull behaviour.

---

## Rules

- Reference `HavenMotion` for every duration, curve, and spring.
- Do not duplicate Pulse phase documentation here — link to HDL/13.
- Do not add motion without a product reason.
- Respect platform reduced-motion settings when implementing fallbacks.

---

## Examples

### Correct

```dart
duration: HavenMotion.countUpDuration,
curve: HavenMotion.unfoldCurve,
```

### Incorrect

```dart
duration: const Duration(milliseconds: 800), // ❌ hardcoded
```

Pulse timing, springs, and haptics — see [HDL/13-financial-pulse.md](13-financial-pulse.md).

---

## Accessibility

- Motion must not be the sole carrier of critical information.
- Provide reduced-motion alternatives for ritual animations (future — tracked in HDL/13).
- Haptics supplement visual feedback — never replace accessible copy.

---

## Future extensions

| Item | Status |
|---|---|
| Reduced-motion system-wide fallback | Not designed |
| Screen transition tokens | Layer morph tokens added (PD-031) — see Layer transition above |
| Sheet/modal motion | Not designed |
| Tokenize safe-area motion offsets | Planned |

### Superseded patterns (do not reintroduce)

| Version | Rejected |
|---|---|
| v2 | Auto-recognition heartbeat on every open |
| v3 | Abstract glyph stretch, particle return, elastic pull, hidden content reveal |

---

## Related

- [HDL/13-financial-pulse.md](13-financial-pulse.md) — definitive Pulse motion spec
- [HDL/20-components.md](20-components.md) — component catalog
- [PRODUCT_DECISIONS.md](../PRODUCT_DECISIONS.md) — PD-027, PD-030, PD-031
