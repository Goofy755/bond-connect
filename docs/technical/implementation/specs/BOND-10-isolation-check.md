# BOND-10: `onIsolationCheck` Cloud Function + Isolation Drain
*Card ID: BOND-10 | Estimated effort: 2 days | Priority: P1 | Role: Backend*

---

## Overview

Implement the `onIsolationCheck` hourly Pub/Sub Cloud Function that detects users who have had no social contact for 6+ hours and activates isolation drain on their Social Bar. Also set up the Cloud Scheduler Pub/Sub infrastructure that triggers the function.

---

## Dependencies

- **Requires**: BOND-03 (`socialState/current` schema must exist; algorithm context needed), BOND-01 (Cloud Scheduler setup)
- **Blocks**: Nothing

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| `onIsolationCheck` spec | [system-design.md](../../design/system-design.md) | §3.4 |
| Isolation drain algorithm | [social-bar-algorithm.md](../../design/social-bar-algorithm.md) | §9 |
| Cloud Scheduler + Pub/Sub setup | [deployment.md](../deployment.md) | §4.4 |
| Timezone & DST handling | [system-architecture.md](../../design/system-architecture.md) | §3.2 (note below table) |
| User profile fields | [system-design.md](../../design/system-design.md) | §2.2 (`nextIsolationCheckAt`, `timezone`) |
| Error handling | [system-design.md](../../design/system-design.md) | §3.5 |

---

## Implementation Tasks

### Infrastructure (one-time, per project)
- [ ] Create Pub/Sub topic `isolation-check-trigger` (per `deployment.md §4.4`)
- [ ] Create Cloud Scheduler job: `0 * * * *` → publishes to `isolation-check-trigger`

### Cloud Function
- [ ] Trigger: `functions.pubsub.topic('isolation-check-trigger').onPublish(...)`
- [ ] Query `/users` where `nextIsolationCheckAt <= now` using the Firestore index on `nextIsolationCheckAt`
- [ ] For each matched user:
  - [ ] Look up `user.timezone` and evaluate 6-hour threshold using **`luxon`** (`DateTime.fromISO(lastEventTime, { zone: user.timezone })`)
  - [ ] Query `/events` where `creatorId == userId OR rsvps/{userId}.status == "accepted"` and `scheduledAt >= now - 6h` to find last social contact time
  - [ ] If elapsed time since last event > 6 hours AND no upcoming confirmed/pending event in next 2 hours:
    - [ ] Set `isolationDrainActive: true` in `/users/{userId}/socialState/current`
    - [ ] Apply 2% isolation drain per elapsed hour since last contact (see `social-bar-algorithm.md §9`)
    - [ ] Write updated `dailyCapacityPct` to `socialState/current`
  - [ ] If `soloRechargeActive == true`: skip isolation drain for this user (they are intentionally solo)
  - [ ] Update `nextIsolationCheckAt = now + 1 hour` on user document

### Isolation Drain Deactivation (client-side)
- [ ] When user creates or accepts an event: set `isolationDrainActive: false` in `socialState/current`

---

## Tests

### Unit Tests
- [ ] Elapsed time = 7 hours, no upcoming events → `isolationDrainActive: true`, drain applied
- [ ] Elapsed time = 5 hours → no drain applied
- [ ] `soloRechargeActive: true` → drain skipped entirely
- [ ] DST boundary: use `luxon` mock to verify 6-hour threshold is evaluated in local time, not UTC offset

### Integration Tests (Firestore Emulator)
- [ ] User with `nextIsolationCheckAt = now - 1min`, no events in last 7h → `isolationDrainActive` set to `true`
- [ ] User with `nextIsolationCheckAt = now + 1h` → NOT included in query results
- [ ] `nextIsolationCheckAt` is updated to `now + 1 hour` after processing
- [ ] After function runs, Pub/Sub trigger with 0 matching users → function exits cleanly with no writes

### Manual Verification
- [ ] With no events for 6+ hours, Social Bar shows isolation drain indicator on Home screen (BOND-04)
- [ ] Creating an event clears `isolationDrainActive` immediately

---

## Acceptance Criteria

- [ ] Cloud Scheduler publishes to `isolation-check-trigger` every hour
- [ ] Function queries only users where `nextIsolationCheckAt <= now` (no full collection scans)
- [ ] Isolation drain is activated and applied correctly for users with 6+ hours of no contact
- [ ] `soloRechargeActive` users are skipped
- [ ] Timezone evaluation uses `luxon` in the user's local timezone
- [ ] `nextIsolationCheckAt` is updated after each run

---

## Out of Scope

- Solo Recharge accumulation logic (already handled by the toggle in BOND-04)
- Isolation drain notification / alert (Phase 2)
