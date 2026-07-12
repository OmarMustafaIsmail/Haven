# Haven Engine

How Haven thinks.

This is the product's intellectual core. It is not a technical specification. It is the mental model every feature, screen, and interaction must respect.

When something new is proposed and cannot be explained with these ideas, challenge it before building it.

---

## How Haven Thinks

Haven is not a banking app. It is a Financial Operating System.

Its purpose is not to display balances. Its purpose is to help members understand where they stand, spend today with confidence, and move toward the life they are building.

Two ideas hold everything together:

1. **Facts are owned by the member.** Everything else is derived by Haven.
2. **Haven reasons about Facts and Time** — not only about what changed, but about what today means.

The Financial Picture is not the source of truth. It is Haven's *understanding* of the member's financial life — a derived reading of the facts.

```
Facts the member owns
        ↓
What Haven derives
        ↓
What the member experiences
```

Never store a derivation as if it were a fact. Never invent a new primitive when an existing one can carry the idea.

---

## The Two Inputs

### Facts

Things the member can assert, confirm, or edit:

- Where money lives
- What they expect to receive or pay
- What they are working toward
- What has already happened

### Time

Some things matter because a number changed. Others matter because **today** became meaningful — payday, rent day, a deadline approaching, a trip next week — even when nothing else moved.

Haven stays awake to both.

---

## The Facts

### Money Places

Where money currently lives.

Money always lives in Money Places. It never "moves into" a Plan. Plans do not hold balances.

A Place has a name, a balance, a source (manual today; connected later), and qualities that matter for judgment:

- **Liquidity** — how available is this money?
- **Reliability** — how sure are we of this balance?

Future bank connections are not a new concept. They are simply another **source** on the same shape.

### Commitments

Expected future movements of money the member is reasonably sure about.

Salary. Rent. Subscriptions. Loans. Insurance. Recurring transfers. Expected bonuses. Expected tax.

A Commitment has a direction (in / out), a cadence, an amount, a confidence, and optionally a linked Money Place.

Commitments are how Haven sees slightly into the future without pretending to predict it. They turn "money today" into "the shape of the month."

**MVP restraint:** members enter only a few big, obvious commitments. Haven does not invent the rest. Unknown is better than guessed. Over time, memory may notice patterns and reduce the need to ask.

This is what retires hardcoded salary reminders. Salary is a Commitment — not a special Moment type.

### Plans

A Plan is a **financial intention** — not a vault.

It has a name, a target, a horizon, and a priority. It answers: *what is this money working toward?*

An **Allocation** is a lens: how much of the money that already exists is currently understood to support that intention. Allocations do not move money. The same buffer may support more than one intention.

Haven's question is not *"Has this money been reserved?"*

It is *"Will the member still achieve this Plan?"*

Two measures, kept distinct:

- **Progress** — how far along (the past)
- **Confidence** — whether it will happen in time, given commitments, cashflow, and horizon (the future)

Because money is shared, confidence is a judgment about the **whole picture**, not per-plan arithmetic that pretends cash can be counted twice.

Deadlines raise urgency. They do not invent new features — they change ranking and tone.

### Activity

The member's financial **journey** — the story of how their financial life evolves.

Not merely transactions. Activity includes:

- Financial transactions
- Manual edits
- Completed Moments
- Plan milestones
- Money Place changes
- Confirmed observations

Activity is what the member can look back on — and what the Intelligence Engine remembers.

---

## What Haven Derives

From the same facts, Haven produces independent readings. They are **siblings**, not a chain.

### Safe to Spend

A Haven belief, not a calculation to worship:

> Safe to Spend is not a prediction. It is not an estimate. It is the amount Haven is **confident** the member can spend today while staying aligned with their intentions.

It is intentionally **conservative** — a trustworthy floor. Haven would rather be quietly low than wrong.

It asks: *what is the most you could spend without pushing any Plan out of confidence or leaving an imminent Commitment uncovered?*

It is not "liquid total minus plan allocations." That would fake reservations that do not exist.

### Pulse

Pulse is the felt sense of financial wellbeing — *How am I doing?*

It is emotional, calm, and never a score. Members are never rated.

Pulse and Safe to Spend both read the facts. Neither feeds the other. One answers how you feel about your position; the other answers what you can do today.

### The Intelligence Engine

One reasoning system. Two volumes.

```
Facts never draw the screen.
Facts produce observations.
Observations compete.
The engine ranks them.
The highest ranked becomes the Home Moment.
The rest become Insights.
```

Moments and Insights are the same thoughts at different volumes — one interruptive, one browsable. There is one Moment on Home by design. Competition is what guarantees that.

Ranking listens to intent, relevance, confidence, urgency, expiration, and available actions.

**Memory** lives inside this engine — product memory, not artificial intelligence:

- Confirmed observations gain confidence. Haven eventually stops asking.
- Dismissed observations lose rank. Haven learns what to leave alone.
- Repeated rhythms are noticed. Patterns become quieter Commitments over time.

Memory is how Haven becomes less chatty and more sure.

---

## The Complete Lifecycle

The member updates a Money Place.

Activity records the change as part of the journey.

Because a fact moved, Haven re-derives in parallel:

- Safe to Spend recalculates the trustworthy floor
- Each active Plan re-checks whether it is still confident
- Pulse re-reads overall wellbeing

None of these wait on each other. All three read the same facts.

The Intelligence Engine re-examines its observations. Some become more relevant; some less. They compete again. A new one may rise to become the Home Moment. The others settle into Insights.

If the member acts on that Moment, memory adjusts future confidence, and Activity records the interaction.

One change. A calm ripple. No chain reaction.

Time works the same way without a fact change: today becomes payday, a deadline approaches, a trip is next week — and the engine wakes observations that compete on the same field.

---

## Weaknesses We Accept Honestly

- **False precision** destroys trust. Safe to Spend stays a floor with margin.
- **Joint achievability is subtle.** Shared money can flatter multiple Plans; confidence must judge the whole.
- **Confidence is hard.** Prefer qualitative bands (on track / tight / at risk) before precise percentages.
- **Time can nag.** Competition, expiration, and memory must quiet the repetitive.
- **Commitment entry is friction.** Memory is the long-term answer — not more forms.
- **Pulse can become unexplainable.** Constrain what it may reflect.

---

## The Simplest Mental Model

```
Money Places · Commitments · Plans · Activity     ← facts
                      ↓
         Safe to Spend  ·  Pulse                  ← sibling readings
                      ↓
              Intelligence Engine                 ← observations + memory
                      ↓
              Moment  ·  Insights                 ← two volumes of one thought
```

Extend these. Do not invent around them.

If a feature cannot be explained with this model, it does not belong in Haven yet.
