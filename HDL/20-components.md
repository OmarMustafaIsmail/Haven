# HDL 20 — Components

## Purpose

Shared UI components used across Haven — including product-defining components like `FinancialPulse` and Home content cards.

## Status

**LOCKED** — Home v5 (PD-029) implemented with Concept C cards + v4 Pulse integration.

## Reasoning

`FinancialPulse` is Haven's signature component — it owns animation state and ritual behaviour. Home composes around it. Architecture locked in PD-028. Content cards restore Concept C hierarchy (PD-008, PD-029).

---

## FinancialPulse

**Status:** Integrated on Home (PD-027, PD-029)
**Spec:** [HAVEN_FINANCIAL_PULSE.md](../HAVEN_FINANCIAL_PULSE.md)
**Architecture:** [FINANCIAL_PULSE_ARCHITECTURE.md](../FINANCIAL_PULSE_ARCHITECTURE.md) (PD-028)
**Visual:** [HDL/13-financial-pulse.md](13-financial-pulse.md)

### Public API (locked — PD-028)

```dart
FinancialPulse({
  required String greeting,
  required PulseState pulseState,
  bool showHeroPresentation = true,
  VoidCallback? onPresentationSettled,
  VoidCallback? onCheckInStarted,
  VoidCallback? onThresholdReached,
  Future<void> Function()? onResolveBeat,
  VoidCallback? onHeartbeatFinished,
  VoidCallback? onReturnedHome,
  ValueChanged<double>? onPullProgress,
  ValueChanged<double>? onBeatProgress,
  Widget? child,
})
```

### Callback contract

| Callback | When | Home reaction |
|---|---|---|
| `onPresentationSettled` | Hero → header settle complete | Optional — Home uses `showHeroPresentation: false` |
| `onCheckInStarted` / `onBeatStarted` | Pull began | No-op — content shift only (`onPullProgress`) |
| `onThresholdReached` | Pulse reached center | `onBeatThreshold` — hero card reading; start `onResolveBeat` |
| `onResolveBeat` | At destination | `HomeCubit` fetches pulse status; awaited before return home |
| `onBeatProgress` | During heartbeat at center | Header double beat only |
| `onHeartbeatFinished` | Heartbeat + resolve complete | Reveal HavenHeroCard result |
| `onReturnedHome` | Back in header | Clear transient Check-In state |
| `onPullProgress` | During pull | Content shift via `PulseLayoutResolver` |

### Internal decomposition

| Component | Role |
|---|---|
| `PulseRitualController` | Pure state machine |
| `PulseAnimationEngine` | AnimationController + spring motion |
| `PulseLayoutResolver` | Greeting + circle geometry + content shift |
| `PulseCircle` | Circular visual (PD-026) |

### Implementation

```
lib/pulse/financial_pulse.dart
lib/pulse/demo/financial_pulse_demo_screen.dart
```

---

## HavenCard

**File:** `lib/widgets/haven_card.dart`
**Status:** Standardized (PD-029)

Shared soft-card surface for Home content.

| Property | Token |
|---|---|
| Radius | `HavenRadius.lg` (24) |
| Padding | `HavenSpacing.lg` (24) |
| Margin | horizontal `md`, vertical `sm` |
| Fill | `HavenColors.surface` (override per card) |
| Border | `HavenColors.borderSubtle` |
| Shadow | None |

---

## Home Content Components

**Location:** `lib/features/home/widgets/`

| Widget | File | Role |
|---|---|---|
| `HavenHeroCard` | `haven_hero_card.dart` | Wellbeing + Safe to Spend — first card. Hosts **Pulse Line** during Check-In (PD-030). |
| `RecommendationCard` | `recommendation_card.dart` | One recommendation only |
| `ActivitySection` | `activity_section.dart` | Recent activity list |
| `PulseLine` | `pulse_line.dart` | Hospital-monitor ECG sweep — transient reading animation (PD-030) |

**Composition:** `HomeScreen` wraps cards in `FinancialPulse` child slot (scrollable `ListView`).

### HavenHeroCard states (PD-030)

| State | Visual |
|---|---|
| Resting | Current wellbeing headline + Safe to Spend |
| Pull | **Unchanged** — shifts down; Pulse grows and travels to center above |
| Pulse at center | Enters **Pulse reading** — Pulse Line appears |
| Revealed | Real Check-In result — status from `PulseState` + amount |

---

## Other Components

| Widget | File | Status |
|---|---|---|
| HavenPrimaryButton | `haven_primary_button.dart` | In code, not used on Home |
| HavenTextButton | `haven_text_button.dart` | In code, not used on Home |
| HavenLogo | `haven_logo.dart` | In use |

---

## Related

- [FINANCIAL_PULSE_ARCHITECTURE.md](../FINANCIAL_PULSE_ARCHITECTURE.md)
- [HAVEN_ARCHITECTURE.md](../HAVEN_ARCHITECTURE.md)
- [HAVEN_FINANCIAL_PULSE.md](../HAVEN_FINANCIAL_PULSE.md)
