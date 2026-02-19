# BOND-09: Post-Event Reflection + `onReflectionSubmitted` CF
*Card ID: BOND-09 | Estimated effort: 2 days | Priority: P1 | Role: Full-stack*

---

## Overview

Build the post-event reflection prompt that fires when an event transitions to `"completed"`. The user rates their experience (sentiment) and reconnect intent. This writes a sentiment log entry, which triggers `onReflectionSubmitted` — a Cloud Function that detects divergence from the algorithm's prediction and sends a Pm nudge if the user has diverged 2+ times consecutively.

---

## Dependencies

- **Requires**: BOND-07 (events must be completable), BOND-03 (needs `predictedDrainPct` from the impact preview)
- **Blocks**: Nothing (terminal card for the core feedback loop)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Sentiment log schema | [system-design.md](../../design/system-design.md) | §2.7 |
| `onReflectionSubmitted` spec | [system-design.md](../../design/system-design.md) | §3.3 |
| Pm nudge spec | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §8, §9 |
| Pm adjustment step + bounds | [requirements.md](../../design/requirements.md) | FR-91 |
| Pm nudge FCM payload | [system-design.md](../../design/system-design.md) | §3.6 |
| Error handling (concurrent Pm update) | [system-design.md](../../design/system-design.md) | §3.5 |
| `consecutiveDivergenceCount` field | [system-design.md](../../design/system-design.md) | §2.2 |

---

## Implementation Tasks

### Reflection Prompt Trigger
- [ ] Monitor `/events/{eventId}` for `status` transitioning to `"completed"` (use `onSnapshot`)
- [ ] When triggered, show a modal/bottom sheet: "How did [event title] feel?"

### Reflection UI
- [ ] Sentiment picker: `energizing | neutral | draining | deep`
- [ ] Reconnect intent picker: `soon | later | pause`
- [ ] Optional text note field (`reminderNote`)
- [ ] Submit button

### Sentiment Log Write
- [ ] On submit, write to `/users/{userId}/sentimentLog/{reflectionId}` with all fields from `system-design.md §2.7`
- [ ] Set `predictedDrainPct` from the stored `event.impact.drainPct`
- [ ] Calculate `divergence`: compare `sentiment` to predicted drain (see `social-bar-algorithm.md §8`)
- [ ] Set `pmAdjusted: false` initially

### `onReflectionSubmitted` Cloud Function
- [ ] Trigger: Firestore `onCreate` on `/users/{userId}/sentimentLog/{reflectionId}`
- [ ] Read current `consecutiveDivergenceCount` from `/users/{userId}`
- [ ] If `divergence != 0`, increment `consecutiveDivergenceCount`; if `divergence == 0`, reset to 0
- [ ] If `consecutiveDivergenceCount >= 2` → write nudge to `/users/{userId}/notifications/{auto-id}` + send Pm nudge FCM notification
- [ ] Update `consecutiveDivergenceCount` on user doc using a **Firestore transaction** (log conflict if transaction fails — never retry)
- [ ] If user confirms nudge (handled client-side): adjust `personalityMultiplier` by ±0.05, clamp to [0.5, 2.0], set `pmAdjusted: true` on the sentiment log doc

---

## Tests

### Unit Tests
- [ ] Divergence: `sentiment = "draining"`, `predictedDrainPct = 10` (low prediction) → `divergence = +1`
- [ ] Divergence: `sentiment = "energizing"`, `predictedDrainPct = 40` (high prediction) → `divergence = -1`
- [ ] Divergence: `sentiment = "neutral"`, `predictedDrainPct = 18` → `divergence = 0`, `consecutiveDivergenceCount` resets
- [ ] Pm clamp: nudge on Pm=1.98, direction +1 → Pm clamped to 2.0
- [ ] Pm clamp: nudge on Pm=0.52, direction -1 → Pm clamped to 0.5
- [ ] Nudge fires when `consecutiveDivergenceCount` reaches 2

### Integration Tests (Firestore Emulator)
- [ ] Write reflection log → `onReflectionSubmitted` fires (emulator)
- [ ] Two consecutive positive divergences → nudge document created in `/users/{uid}/notifications/`
- [ ] Firestore transaction: concurrent reflection submissions do not corrupt `consecutiveDivergenceCount`

### Manual Verification
- [ ] After event completes, reflection prompt appears automatically
- [ ] Submitting reflection → sentiment log appears in Firestore
- [ ] After 2 diverging reflections → Pm nudge notification appears in-app

---

## Acceptance Criteria

- [ ] Reflection prompt fires when event status transitions to `"completed"`
- [ ] Sentiment log document is created with all fields from `system-design.md §2.7`
- [ ] `consecutiveDivergenceCount` is incremented on divergence and reset on match
- [ ] Pm nudge notification is sent after 2 consecutive divergences
- [ ] Pm adjustment of ±0.05 is clamped to [0.5, 2.0]
- [ ] Concurrent updates use a Firestore transaction

---

## Out of Scope

- Displaying nudge history in settings (Phase 2)
- Changing `sentimentTrend` on the relationship document (deferred — that's a separate update based on logged reflections)
