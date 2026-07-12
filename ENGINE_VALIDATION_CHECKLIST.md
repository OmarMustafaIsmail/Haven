# Engine Validation Checklist

Manual smoke for the Haven Engine Validation Sprint (PR A → B → C).

Run on Android emulator after clearing `build\.cxx` if native CMake locks recur.

## Safe to Spend trust (PR A)

- [ ] Empty member (no Money Places) → **Unknown** — no large floor; CTAs present
- [ ] Places without salary / undated plans → **Estimated** — "Around X" + "Based on what Haven currently knows."
- [ ] Places + inflow + outflow/runway + all active plans dated → **Confident**
- [ ] Tap Safe to Spend → Why sheet shows available / commitments / plan hold / margin only

## Plans + allocation lens (PR B)

- [ ] Create plan is 5 steps; target date required; multi-select places; allocation capped by selected balances
- [ ] Plan row / detail show Confidence · High / Medium / Low
- [ ] Edit allocation on detail writes Activity ("Plan allocation updated")
- [ ] Change a connected Money Place balance → effective progress and confidence update; STS may change

## Inspector + Activity + compressed time (PR C)

- [ ] Developer Panel → **Inspector** tab: Facts → Derived → Candidates → Winning → Learning
- [ ] You & Haven → Open Developer Panel reaches the same surface
- [ ] Enable compressed time → Tools shows salary (~2m) / commitment (~5m) / plan (~10m) cadences
- [ ] Completing a Moment, editing money, dismissing with learning, updating allocation → human Activity story labels (not technical dumps)

## Automated

```bash
flutter test
```

Expect STS state tests, allocation ripple (balance → confidence → STS), and widget coverage for plan confidence / progress.
