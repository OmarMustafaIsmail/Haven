# Engine Validation Checklist

Manual smoke + **Product Confidence** scorecard (PD-045).

Run on Android emulator after clearing `build\.cxx` if native CMake locks recur.

## Product Confidence

| Capability | Status | What would move it |
|---|---|---|
| Safe to Spend | 🟡 | Land Engine Confidence continuum (PD-040); keep Why |
| Pulse | 🟢 | Ritual + sibling recompute shipped |
| Plans | 🟡 | Optional allocation UX (PD-041); connect-money Moment |
| Moments | 🔴 | Stronger ranking evidence + Moment Why (PD-042) |
| Learning | 🟡 | Human "Haven learned…" copy only (PD-044) |
| Insights | ⚪ | Depth / Why not validated |

## Smoke — Safe to Spend

- [ ] Cash without salary is **not** automatically blank/Unknown — Engine Confidence Medium possible (PD-040)
- [ ] Thin picture → cautious copy; rich picture → confident floor
- [ ] Tap Safe to Spend → Why (first of many Whys — PD-042)

## Smoke — Plans

- [ ] Create plan with date, **without** places/allocation — allowed (PD-041)
- [ ] No allocation → Low plan confidence; Moment can ask to connect money
- [ ] With allocation, place balance change recalculates siblings in one engine pass (PD-043)

## Smoke — Inspector + Time

- [ ] Inspector: Facts → Derived → Candidates → Winning → Learning
- [ ] Inspector shows **Time**: simulated clock, upcoming commitments, upcoming plan deadlines, next compressed tick / recalculation note
- [ ] Compressed cadences still fire Moments through IntelligenceEngine

## Smoke — Activity (member story)

- [ ] ✓ Salary confirmed / plan completed / balance updated / Haven learned payday
- [ ] ✗ No "STS recalculated" / engine diary rows (PD-044)

## Architecture check

- [ ] No feature described as Money → Plan → STS → Pulse chain
- [ ] Model is Facts + Time → Engine → sibling readings (PD-043)

## Automated

```bash
flutter test
```
