# BOND-07: Inbox + RSVP Flow UI
*Card ID: BOND-07 | Estimated effort: 2 days | Priority: P0 | Role: Frontend*

---

## Overview

Build the Inbox screen showing pending event invites in real time, and the accept/decline RSVP flow. The Inbox listens to the user's pending RSVP documents, displays event details, and allows the user to accept or decline. Tapping a push notification deep link should navigate directly to the relevant invite.

---

## Dependencies

- **Requires**: BOND-06 (`onEventCreated` must create RSVPs + send FCM)
- **Blocks**: BOND-09 (post-event reflection fires after event completes)

---

## References

| Topic | Document | Section |
|:---|:---|:---|
| RSVP document schema | [system-design.md](../../design/system-design.md) | §2.6 |
| Event schema | [system-design.md](../../design/system-design.md) | §2.5 |
| Inbox real-time listener | [system-design.md](../../design/system-design.md) | §5 |
| Event state machine | [system-design.md](../../design/system-design.md) | §4 |
| FCM deep link format | [system-design.md](../../design/system-design.md) | §3.6 |
| Inbox requirements | [requirements.md](../../design/requirements.md) | FR-40 – FR-55 |

---

## Implementation Tasks

### Real-Time Listener
- [ ] Subscribe to Firestore listener on `/events/{eventId}/rsvps/{uid}` where `status == "pending"`
- [ ] For each pending RSVP, fetch the parent `/events/{eventId}` document for display data
- [ ] Unsubscribe on unmount

### Inbox Screen
- [ ] List of pending invites: show event title, type, creator name, date/time, duration
- [ ] Badge count on Inbox tab showing number of pending RSVPs
- [ ] Empty state: "No pending invites"

### RSVP Detail Screen
- [ ] Full event details view (triggered by tapping an invite)
- [ ] After accept: update RSVP `status: "accepted"`, `respondedAt: now`.
- [ ] After accept: if this is a 1:1 event, update event `status` to `"confirmed"`.
- [ ] After accept: for group events, keep `status: "pending"` until all mandatory RSVPs are accepted or a threshold is met.
- [ ] After decline: update RSVP `status: "declined"`, `respondedAt: now`.
- [ ] After decline: update event `status` to `"cancelled"` only if the creator has no other accepted RSVPs (or if the event can no longer proceed).
- [ ] Show "Already responded" state if RSVP is no longer pending

### Deep Link Handling
- [ ] Handle `bondconnect://inbox?token={inviteToken}` deep link on notification tap
- [ ] Navigate to the RSVP detail screen for the corresponding event
- [ ] Handle expired/invalid token gracefully ("This invite has expired")

---

## Tests

### Unit Tests
- [ ] `status: "accepted"` → Accept button writes correct fields to Firestore
- [ ] `status: "declined"` → Decline button writes correct fields
- [ ] Badge count = number of RSVPs with `status == "pending"`
- [ ] If RSVP already `"accepted"` or `"declined"` → show "Already responded" state (no action buttons)

### Integration Tests (Firestore Emulator)
- [ ] Accept RSVP → `/events/{eventId}/rsvps/{uid}.status` is `"accepted"` and `respondedAt` is set
- [ ] Decline RSVP → status is `"declined"` and event status updates to `"cancelled"`
- [ ] Real-time listener fires when a new RSVP is added by `onEventCreated`

### Manual Verification
- [ ] Tap push notification → app opens directly to the invite detail screen
- [ ] Badge count on Inbox tab updates immediately when a new invite arrives
- [ ] Declining an invite removes it from the Inbox list in real time

---

## Acceptance Criteria

- [ ] Inbox shows all pending RSVPs in real time
- [ ] User can accept or decline an invite; Firestore is updated correctly
- [ ] Event status transitions correctly (pending → confirmed / cancelled)
- [ ] Deep link from push notification navigates to the correct invite
- [ ] Badge count on tab accurately reflects pending RSVP count

---

## Out of Scope

- Reschedule flow (deferred to Phase 2)
- Invite token validation via `validateInviteToken` CF (BOND-11 — use `eventId` lookup for MVP)
