# BOND-03: `calculateSocialImpact` Cloud Function
*Card ID: BOND-03 | Estimated effort: 3 days | Priority: P0 | Role: Backend*

---

## Overview

Implement the `calculateSocialImpact` HTTPS callable Cloud Function. This is the core of the product — it computes the projected Social Bar drain for a proposed event using the SSH, Pm, Ew, Ii, and Cb components, returns a Ghost Bar projection, and flags guardrail violations. It is called client-side with a ~500ms debounce on event form changes.

---

## Dependencies

- **Requires**: BOND-02 (user profile with `personalityMultiplier` must exist)
- **Blocks**: BOND-04 (Social Bar UI reads from `socialState/current`), BOND-05 (event creation calls this function)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Full algorithm spec | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | All sections |
| API request/response contract | [system-design.md](../../design/system-design.md) | §3.1 |
| Ghost Bar projection logic | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §10 |
| Error codes + client behavior | [system-design.md](../../design/system-design.md) | §3.1, §3.5 |
| Cb default for new contacts | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §7 |
| Pm values and seeds | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §4 |

---

## Implementation Tasks

### Input Validation
- [ ] Validate `durationMinutes`: required, must be > 0 and ≤ 480; return `INVALID_DURATION` otherwise
- [ ] Validate `scheduledAt`: must be in the future; return `PAST_DATE_ERROR` otherwise
- [ ] Validate `contactId`: required for `quick_call` and `deep_connection`; optional for `group_event`
- [ ] Validate `locationCategory`: must be one of `restorative | neutral | stressful` or `null`
- [ ] Set a 5-second function timeout; return `CALCULATION_TIMEOUT` if exceeded

### Algorithm Implementation
- [ ] Read caller's user profile from Firestore (`/users/{uid}`) — return `USER_NOT_FOUND` if missing
- [ ] Read caller's `socialState/current` for current `dailyCapacityPct`
- [ ] Read contact's relationship document (`/users/{uid}/relationships/{contactId}`) for `sentimentTrend` and `socialBarWithContact.stage`; default `sentimentTrend = "neutral"` if null/missing
- [ ] Compute `durationFactor = durationMinutes / 60`
- [ ] Set `SSH_base = 20` (constant per `social-bar-algorithm.md §3.1`)
- [ ] Look up `Ew` multiplier from `locationCategory` (restorative=0.85, neutral=1.00, stressful=1.15; default=1.00 if null)
- [ ] Look up `Ii` multiplier from `eventType` (see `social-bar-algorithm.md §6`)
- [ ] Compute `Cb` from `sentimentTrend` and relationship stage (see `social-bar-algorithm.md §7`)
- [ ] Compute `drainPct = (SSH_base × durationFactor × Pm × Ew × Ii) − Cb`, clamped to [0, 100]
- [ ] Compute `sluCost = drainPct / 20` (1 SLU = 20%)
- [ ] Compute `projectedDailyPctAfter = dailyCapacityPct + drainPct`
- [ ] Compute Ghost Bar: sum drain from all `confirmed`/`pending` events in next 4 hours + any isolation drain in that window; no Solo Recharge recovery (see `social-bar-algorithm.md §10`)
- [ ] Check if `projectedDailyPctAfter` exceeds `user.weeklyCapacityTarget`; set `guardrailTriggered: true` if so
- [ ] Return full success response per `system-design.md §3.1`

### Error Handling
- [ ] Return `CALCULATION_FAILED` for any unexpected error
- [ ] Log all errors to Firestore `/errors` collection with `userId`, `timestamp`, and `errorCode`

---

## Tests

### Unit Tests
- [ ] `durationFactor`: 60 min → 1.0, 30 min → 0.5, 120 min → 2.0
- [ ] Drain formula: `quick_call`, 60 min, Pm=1.0, Ew=1.00, Ii=0.80, Cb=0 → `drainPct = 12.0`
- [ ] Drain formula: `deep_connection`, 60 min, Pm=1.4, Ew=1.15, Ii=1.20, Cb=5 → verify against worked example in `social-bar-algorithm.md §11`
- [ ] `drainPct` is clamped to 0 minimum (Cb cannot make it negative)
- [ ] Guardrail triggers when `projectedDailyPctAfter > weeklyCapacityTarget`
- [ ] `sentimentTrend = null` → Cb = 0
- [ ] `locationCategory = null` → Ew = 1.00

### Integration Tests (Firestore Emulator)
- [ ] Valid request with known user → returns correct `drainPct`, `sluCost`, `projectedGhostPct`
- [ ] `scheduledAt` in the past → returns `PAST_DATE_ERROR`
- [ ] `durationMinutes = 0` → returns `INVALID_DURATION`
- [ ] `durationMinutes = 481` → returns `INVALID_DURATION`
- [ ] User document does not exist → returns `USER_NOT_FOUND`
- [ ] `contactId` missing for `quick_call` → returns validation error

---

## Acceptance Criteria

- [ ] Function returns the correct drain % (verified against the worked example in `social-bar-algorithm.md §11`)
- [ ] All 4 validation error codes are returned correctly
- [ ] Ghost Bar projection is correct for a user with one confirmed upcoming event
- [ ] Guardrail message is returned when projected usage exceeds `weeklyCapacityTarget`
- [ ] Function handles missing `contactId` / `sentimentTrend` gracefully with defaults

---

## Out of Scope

- Writing results back to `socialState/current` (that happens when an event is actually saved, not previewed)
- Isolation drain trigger (BOND-10)
