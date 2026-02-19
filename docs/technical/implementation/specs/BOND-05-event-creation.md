# BOND-05: Event Creation Form + Impact Preview
*Card ID: BOND-05 | Estimated effort: 3 days | Priority: P0 | Role: Full-stack*

---

## Overview

Build the event creation form and wire it to `calculateSocialImpact` for a real-time drain preview before the event is saved. The client debounces calls by ~500ms on form field changes. On save, write the event document to Firestore at `/events/{eventId}` with all required fields including the computed `impact` object.

---

## Dependencies

- **Requires**: BOND-03 (`calculateSocialImpact` Cloud Function must be deployed), BOND-04 (Home Dashboard provides navigation to event creation — implementation can start in parallel if navigation is deferred)
- **Blocks**: BOND-06 (event save triggers `onEventCreated`)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| Event schema | [system-design.md](../../design/system-design.md) | §2.5 |
| `calculateSocialImpact` API contract | [system-design.md](../../design/system-design.md) | §3.1 |
| Validation rules | [system-design.md](../../design/system-design.md) | §3.1 (Validation Rules) |
| Error codes + client behavior | [system-design.md](../../design/system-design.md) | §3.1, §3.5 |
| Event state machine | [system-design.md](../../design/system-design.md) | §4 |
| Event creation requirements | [requirements.md](../../design/requirements.md) | FR-30 – FR-35 |
| Debounce requirement | [requirements.md](../../design/requirements.md) | FR-31 |
| Google Maps location classification | [system-architecture.md](../../design/system-architecture.md) | §3.4 |

---

## Implementation Tasks

### Form UI
- [ ] Event type selector: `quick_call | deep_connection | group_event`
- [ ] Title input (required)
- [ ] Duration selector (15 / 30 / 60 / 90 / 120 minutes)
- [ ] Date/time picker for `scheduledAt` (future dates only)
- [ ] Contact selector (choose from contacts list; required for `quick_call` and `deep_connection`)
- [ ] Location input (optional text field) with Google Maps Places autocomplete
- [ ] Location category auto-populated from Maps API; allow manual override (`restorative | neutral | stressful`)
- [ ] Mode selector: `phone | in-person | video`
- [ ] Send method: `text | email | both`

### Impact Preview Panel
- [ ] Display `drainPct`, `sluCost`, and `projectedDailyPctAfter` from the Cloud Function response
- [ ] Show Ghost Bar on a mini Social Bar preview within the form
- [ ] Show guardrail banner if `guardrailTriggered: true`
- [ ] Debounce `calculateSocialImpact` calls by ~500ms using `setTimeout`/`clearTimeout` (see FR-31)
- [ ] Cancel any in-flight request when a newer debounced call fires
- [ ] On `CALCULATION_TIMEOUT`: show "Preview unavailable — proceed anyway?" (save is not blocked)
- [ ] On `CALCULATION_FAILED` / other errors: show "Unable to preview impact" and **block save**

### Save
- [ ] On save, write event document to `/events/{eventId}` with all fields from `system-design.md §2.5`
- [ ] Set `status: "pending"` on create
- [ ] Set `impact.environmentWeight`, `impact.intensityWeight`, `impact.connectionBonus` from last successful preview response
- [ ] Create RSVP documents at `/events/{eventId}/rsvps/{inviteeUserId}` with `status: "pending"` for each invited contact
- [ ] Set `rescheduleProposal` to `{ proposedBy: null, proposedAt: null, newScheduledAt: null }`
- [ ] Disable save button while preview is loading or errored (except CALCULATION_TIMEOUT)

---

## Tests

### Unit Tests
- [ ] Debounce: rapid field changes fire only one Cloud Function call after 500ms of inactivity
- [ ] Save is blocked when `calculateSocialImpact` returns `CALCULATION_FAILED`
- [ ] Save is NOT blocked when `calculateSocialImpact` returns `CALCULATION_TIMEOUT`
- [ ] Date picker prevents selecting dates in the past

### Integration Tests (Firestore Emulator)
- [ ] Save event → `/events/{eventId}` document exists with all required fields
- [ ] Save event with 2 invitees → 2 RSVP documents created at `/events/{eventId}/rsvps/`
- [ ] `impact` object fields are populated from the last preview response
- [ ] `status` is `"pending"` on save

### Manual Verification
- [ ] Changing duration field triggers preview update after ~500ms (not on every keystroke)
- [ ] Guardrail banner appears when projected usage exceeds capacity
- [ ] Google Maps autocomplete works and auto-fills location category

---

## Acceptance Criteria

- [ ] Form collects all required fields from `system-design.md §2.5`
- [ ] `calculateSocialImpact` is called with ~500ms debounce on form changes
- [ ] Impact preview panel shows drain %, SLU cost, and Ghost Bar
- [ ] Save writes a valid event document and creates RSVP sub-documents for all invitees
- [ ] Correct error handling for `CALCULATION_FAILED` (block save) vs `CALCULATION_TIMEOUT` (allow save)

---

## Out of Scope

- Reschedule flow (part of BOND-07)
- Push notification dispatch on save (BOND-06)
- Calendar integration (Phase 2)
